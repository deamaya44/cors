resource "aws_apigatewayv2_api" "rest_api" {
  name          = "${var.environment}-cors-api"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_integration" "vpc_link_integration" {
  api_id           = aws_apigatewayv2_api.rest_api.id
  integration_type = "HTTP_PROXY"
  integration_uri  = "http://${var.alb_dns}/${var.environment}/${var.name}/api/items"
  connection_type  = "VPC_LINK"
  connection_id    = var.vpclink_id
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
