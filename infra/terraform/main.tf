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
  depends_on = [ module.ecr, module.task_definition ]
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

module "rds" {
  source                          = "./modules/rds"
  for_each                        = { for k, v in local.rds-postgres : k => v }
  environment                     = each.key
  vpc_id                          = data.aws_vpc.control_tower_vpc.id
  private_subnets                 = data.aws_subnets.private_subnets.ids
  engine                          = each.value.engine
  engine_version                  = each.value.engine_version
  instance_class                  = each.value.instance_class
  allocated_storage               = each.value.allocated_storage
  max_allocated_storage           = each.value.max_allocated_storage
  enabled_cloudwatch_logs_exports = each.value.enabled_cloudwatch_logs_exports
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
  listener_alb_arn = module.alb.alb_listener
  cpu              = each.value.cpu
  memory           = each.value.memory
  containerPort    = each.value.containerPort
  desired_count    = each.value.desired_count
  from_port        = each.value.ingress.from_port
  to_port          = each.value.ingress.to_port
  cidr_blocks      = each.value.ingress.cidr_blocks
  path             = each.value.hc.path
  matcher          = each.value.hc.matcher
  secret           = module.rds[local.environment].secret_arn
  rds_sg           = module.rds[local.environment].rds_sg
  rds_name = module.rds[local.environment].rds_name
  dbname           = module.rds[local.environment].dbname
  depends_on       = [ module.rds ]

}

module "acm" {
  source      = "./modules/acm"
  environment = local.environment
  domain_name = local.domains
  zone_id    = data.aws_route53_zone.dns_zone.id
}
module "cloudfront" {
  source              = "./modules/s3_cloudfront"
  environment         = local.environment
  bucket_name         = "web-cors-${local.environment}"
  s3_access           = "private"
  aliases             = ["${local.environment}.${local.domains}"]
  acm_certificate_arn = module.acm.acm_cert
  zone_id            = data.aws_route53_zone.dns_zone.id
  domain_name         = local.domains
  depends_on          = [ module.acm ]
}

module "submit" {
  source      = "./modules/submit"
  environment = local.environment
  bucket_name = "web-cors-${local.environment}"
  cloudfrontid = module.cloudfront.cloudfront_id
  depends_on  = [ module.cloudfront ]
}

module "apigateway" {
  source      = "./modules/apigateway"
  name      = "backend"
  environment = local.environment
  domain_name = local.domains
  zone_id    = data.aws_route53_zone.dns_zone.id
  alb_dns = module.alb.alb_dns_name
  vpclink_id = module.nlb.vpc_link_id
  depends_on  = [ module.nlb ]
}