output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution_cors.domain_name
}
output "s3_cloudfront_bucket" {
  description = "The S3 bucket name"
  value       = aws_s3_bucket.s3_cors.bucket 
}
output "cloudfront_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution_cors.id
}