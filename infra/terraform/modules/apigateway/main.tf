resource "aws_apigatewayv2_api" "rest_api" {
  name          = "${var.environment}-cors-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "vpc_link_integration" {
  api_id             = aws_apigatewayv2_api.rest_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = "http://${var.alb_dns}/${var.environment}/"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name        = "example-vpc-link"
  subnet_ids  = var.subnet_ids
  security_group_ids = var.security_group_ids
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.rest_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.vpc_link_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.rest_api.id
  name        = "$default"
  auto_deploy = true
}

variable "albdns" {
  description = "The DNS name of the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the VPC link"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the VPC link"
  type        = list(string)
}