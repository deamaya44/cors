# API Gateway Principal
resource "aws_api_gateway_rest_api" "my_api" {
  name        = "${var.environment}-${var.name}-api"
  description = var.description
}

# Iterar sobre rutas y métodos
resource "aws_api_gateway_resource" "proxy" {
  for_each = var.routes

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = basename(each.value.path) # Ej: "/resource1" -> "resource1"
}

resource "aws_api_gateway_method" "http_method" {
  for_each = merge([
    for route_key, route in var.routes : {
      for method in keys(route.methods) :
      "${route_key}-${method}" => {
        route_key = route_key,
        method    = method
      }
    }
  ]...)

  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.proxy[each.value.route_key].id
  http_method   = each.value.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  for_each = aws_api_gateway_method.http_method

  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = each.value.resource_id
  http_method             = each.value.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.alb_dns}/${var.environment}/${var.name}/${aws_api_gateway_resource.proxy[split("-", each.key)[0]].path_part}"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link
}

######### Adding options method #########
resource "aws_api_gateway_method" "options" {
  for_each = var.routes

  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.proxy[each.key].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "options_integration" {
  for_each = aws_api_gateway_method.options

  rest_api_id       = aws_api_gateway_rest_api.my_api.id
  resource_id       = each.value.resource_id
  http_method       = "OPTIONS"
  type              = "MOCK"
  request_templates = { "application/json" = "{\"statusCode\": 200}" }
}
resource "aws_api_gateway_method_response" "options_response" {
  for_each = aws_api_gateway_method.options

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = each.value.resource_id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "options_response" {
  for_each = aws_api_gateway_method.options

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = each.value.resource_id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-CHANNEL'"
  }
  depends_on = [aws_api_gateway_method_response.options_response]
}

######### Adding level2 #########

# resource "aws_api_gateway_resource" "level2" {
#   for_each = { for k, v in var.routes : k => v if try(v.path2 != null, false) }

#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   parent_id   = aws_api_gateway_resource.proxy[basename(each.value.path)].id
#   path_part   = each.value.path2 # Now guaranteed to exist due to filtered for_each
# }

# resource "aws_api_gateway_resource" "level2" {
#   for_each = {
#     for k, v in var.routes : k => v
#     if lookup(v, "path2", null) != null # Filtra solo rutas con path2 definido y no nulo
#   }

#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   parent_id   = aws_api_gateway_resource.proxy[basename(each.value.path)].id
#   path_part   = trimprefix(each.value.path2, "/") # Elimina "/" si existe
# }
resource "aws_api_gateway_resource" "level2" {
  for_each = merge([
    for route_key, route in var.routes :
    {
      for path2_key, path2_config in coalesce(route.path2, {}) :
      "${route_key}-${path2_key}" => {
        route_key   = route_key
        path2_key   = path2_key
        path_config = path2_config
      }
      if path2_config.path != null # Filtra los elementos donde `path` no es `null`
    }
  ]...)

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_resource.proxy[each.value.route_key].id
  path_part   = trimprefix(each.value.path_config.path, "/")
}


# Crear métodos HTTP para los recursos de nivel 2
resource "aws_api_gateway_method" "level2_methods" {
  for_each = merge([
    for route_key, route in var.routes :
    merge([
      for path2_key, path2_config in coalesce(route.path2, {}) :
      {
        for method in keys(path2_config.methods) :
        "${route_key}-${path2_key}-${method}" => {
          route_key   = route_key
          path2_key   = path2_key
          method      = method
          path_config = path2_config
        }
      } if path2_config.path != null
    ]...)
  ]...)

  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.level2["${each.value.route_key}-${each.value.path2_key}"].id
  http_method   = each.value.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "level2_integration" {
  for_each = aws_api_gateway_method.level2_methods

  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = each.value.resource_id
  http_method             = each.value.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.alb_dns}/${var.environment}/${var.name}/${aws_api_gateway_resource.proxy[split("-", each.key)[0]].path_part}/${aws_api_gateway_resource.level2["${split("-", each.key)[0]}-${split("-", each.key)[1]}"].path_part}"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link
}

# resource "aws_api_gateway_method" "level2" {
#   for_each = var.routes2

#   rest_api_id   = aws_api_gateway_rest_api.my_api.id
#   resource_id   = aws_api_gateway_resource.proxy[basename(each.value.path)].id
#   http_method   = each.value.methods2
#   authorization = "NONE"
# }


# Deployment (igual que antes)
resource "aws_api_gateway_deployment" "my_deployment" {
  depends_on  = [aws_api_gateway_integration.integration, aws_api_gateway_integration.options_integration]
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = var.environment
  triggers = {
    redeployment = "${timestamp()}"
  }
}