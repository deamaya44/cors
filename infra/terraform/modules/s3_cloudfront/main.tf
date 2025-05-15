resource "aws_s3_bucket" "s3_cors" {
  bucket = var.bucket_name
  acl    = var.s3_access
}
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for ${var.bucket_name}"
}

resource "aws_cloudfront_distribution" "s3_distribution_cors" {
  origin {
    domain_name = aws_s3_bucket.s3_cors.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.s3_cors.bucket}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  custom_error_response {
    error_code            = 403
    response_page_path    = "/"
    response_code         = 200
    error_caching_min_ttl = 10
  }
  custom_error_response {
    error_code            = 404
    response_page_path    = "/index.html"
    response_code         = 200
    error_caching_min_ttl = 10
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${var.bucket_name}"
  default_root_object = "index.html"

  aliases = var.aliases # Add your domain names here, e.g., ["example.com", "www.example.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.s3_cors.bucket}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn      = var.acm_certificate_arn # Provide your ACM certificate ARN here
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}
resource "aws_s3_bucket_policy" "bucket_policy_cors" {
  bucket = aws_s3_bucket.s3_cors.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.s3_cors.arn}/*"
      }
    ]
  })
}