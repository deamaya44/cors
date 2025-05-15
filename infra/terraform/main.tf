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
module "upload" {
  source     = "./modules/upload"
  for_each   = local.microservices
  name       = "${local.environment}-ms-${each.key}"
  context    = each.value.docker_context
  dockerfile = each.value.dockerfile
  registry   = "${local.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com"
  depends_on = [ module.ecr ]
}
module "alb" {
  source          = "./modules/alb"
  name            = "microservices"
  environment     = local.environment
  vpc_id          = data.aws_vpc.control_tower_vpc.id
  private_subnets = data.aws_subnets.private_subnets.ids
  internal        = true

}

module "nlb" {
  source          = "./modules/nlb"
  name            = "microservices"
  environment     = local.environment
  vpc_id          = data.aws_vpc.control_tower_vpc.id
  private_subnets = data.aws_subnets.private_subnets.ids
  alb_arn         = module.alb.alb_arn
  depends_on = [ module.alb ]
}
# module "roles" {
#   source      = "./modules/roles"
#   environment = local.environment
#   globals_arn = distinct(concat([for td in module.task_definition : td.globals_arn]))
# }
# module "task_definition" {
#   source           = "./modules/task_definition"
#   environment      = local.environment
#   for_each         = local.microservices
#   name             = "${local.environment}-${each.key}"
#   image            = "${local.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.environment}-ms-${each.key}:latest"
#   region           = data.aws_region.current.name
#   role             = module.roles.role_arn
#   cluster_id       = module.ecs.ecs_cluster_id
#   private_subnets  = data.aws_subnets.private_subnets.ids
#   vpc_id           = data.aws_vpc.control_tower_vpc.id
#   listener_alb_arn = module.alb.alb_listener
#   cpu              = each.value.cpu
#   memory           = each.value.memory
#   containerPort    = each.value.containerPort
#   desired_count    = each.value.desired_count
#   from_port        = each.value.ingress.from_port
#   to_port          = each.value.ingress.to_port
#   cidr_blocks      = each.value.ingress.cidr_blocks
#   path             = each.value.hc.path
#   matcher          = each.value.hc.matcher
#   secret           = local.secret
#   rds_sg           = data.aws_security_group.rds_sg.id
# }
# module "cloudfront" {
#   source              = "./modules/s3_cloudfront"
#   environment         = local.environment
#   bucket_name         = "web-front-${local.environment}"
#   s3_access           = "private"
#   aliases             = ["cors${local.environment}..com"]
#   acm_certificate_arn = local.acm_cert
# }