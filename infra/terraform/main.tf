module "ecs" {
  source          = "./modules/ecs"
  environment     = local.environment
  vpc_id          = data.aws_vpc.control_tower_vpc.id
  private_subnets = data.aws_subnets.private_subnets.ids
}
module "ecr" {
  source               = "./modules/ecr"
  for_each             = local.microservices
  environment          = local.environment
  name                 = "${local.environment}-ms-${each.key}"
  image_tag_mutability = each.value.image_tag_mutability
  scan_on_push         = each.value.scan_on_push
}
module "alb" {
  source          = "./modules/alb"
  name            = "microservices"
  environment     = local.environment
  vpc_id          = data.aws_vpc.control_tower_vpc.id
  private_subnets = data.aws_subnets.private_subnets.ids
  internal = true

}

module "nlb" {
  source          = "./modules/nlb"
  name            = "microservices"
  environment     = local.environment
  vpc_id          = data.aws_vpc.control_tower_vpc.id
  private_subnets = data.aws_subnets.private_subnets.ids
  alb_arn         = module.alb.alb_arn
}
module "roles" {
  source      = "./modules/roles"
  environment = local.environment
  globals_arn = distinct(concat([for td in module.task_definition : td.globals_arn]))
}

module "task_definition" {
  source           = "./modules/task_definition"
  environment      = local.environment
  for_each         = local.microservices
  name             = "${local.environment}-${each.key}"
  image            = "${local.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.environment}-ms-${each.key}:latest"
  region           = data.aws_region.current.name
  role             = module.roles.role_arn
  cluster_id       = module.ecs.ecs_cluster_id
  private_subnets  = data.aws_subnets.private_subnets.ids
  vpc_id           = data.aws_vpc.control_tower_vpc.id
  listener_alb_arn = local.environment == "dev" ? module.alb.alb_listener : data.aws_lb_listener.listener.arn
  listener_alb2_arn = local.environment == "dev" ? module.alb2.alb_listener : data.aws_lb_listener.listener_public.arn
  cpu              = each.value.cpu
  memory           = each.value.memory
  containerPort    = each.value.containerPort
  desired_count    = each.value.desired_count
  from_port        = each.value.ingress.from_port
  to_port          = each.value.ingress.to_port
  cidr_blocks      = each.value.ingress.cidr_blocks
  path             = each.value.hc.path
  matcher          = each.value.hc.matcher
  secret           = local.secret
  rds_sg           = data.aws_security_group.rds_sg.id
  websocket        = each.value.websocket
}
module "cloudfront" {
  source      = "./modules/s3_cloudfront"
  environment = local.environment
  bucket_name = "web-front-${local.environment}"
  s3_access   = "private"
  aliases = ["cors${local.environment}..com"]
  acm_certificate_arn = local.acm_cert
}

module "sqs" {
  source      = "./modules/sqs"
  name        = "${local.environment}-sqs-queue"
  env        = local.environment
}
# module "apigateway" {
#   source      = "./apigateway"
#   for_each    = local.apis
#   name        = each.value.name
#   description = each.value.description
#   routes      = each.value.routes
#   vpc_link    = local.environment == "dev" ? module.nlb.vpc_link_id : data.aws_api_gateway_vpc_link.vpc_link.id
#   alb_dns     = local.environment == "dev" ? module.alb.alb_dns_name : data.aws_lb.load_balancer.dns_name
#   environment = local.environment
# }