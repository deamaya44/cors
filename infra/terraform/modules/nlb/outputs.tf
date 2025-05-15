output "nlb_micros_services_dns_name" {
  value = aws_lb.cors-nlb.dns_name
}

output "nlb_micros_services_ar" {
  value = aws_lb.cors-nlb.arn
}
output "vpc_link_id" {
  value = aws_api_gateway_vpc_link.vpc_link.id
}