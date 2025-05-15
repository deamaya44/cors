resource "aws_acm_certificate" "cors" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "www.${var.domain_name}",
  ]

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_route53_record" "cors" {
  for_each = {
    for dvo in aws_acm_certificate.cors.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "cors" {
  certificate_arn         = aws_acm_certificate.cors.arn
  validation_record_fqdns = [for record in aws_route53_record.cors : record.fqdn]
}