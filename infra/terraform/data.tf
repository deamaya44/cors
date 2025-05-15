data "aws_vpc" "control_tower_vpc" {
  filter {
    name   = "tag:Name"
    values = ["cors-vpc"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name = "tag:Name"
    values = [
      "cors-subnet-public1-us-east-1a",
      "cors-subnet-public2-us-east-1b"
    ]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name = "tag:Name"
    values = [
      "cors-subnet-private1-us-east-1a",
      "cors-subnet-private2-us-east-1b"
    ]
  }
}


data "aws_lb" "load_balancer" {
  name = "microservices-alb"
}
data "aws_lb" "load_balancer_public" {
  name = "microservices-public-alb"
}

data "aws_lb_listener" "listener" {
  load_balancer_arn = data.aws_lb.load_balancer.arn
  port              = 80  # Specify the listener port (e.g., 80 for HTTP or 443 for HTTPS)
}
data "aws_lb_listener" "listener_public" {
  load_balancer_arn = data.aws_lb.load_balancer_public.arn
  port              = 80  # Specify the listener port (e.g., 80 for HTTP or 443 for HTTPS)
}

data "aws_api_gateway_vpc_link" "vpc_link" {
  name = "global-vpc-link"
}

data "aws_db_instance" "rds" {
  db_instance_identifier = local.rdsname
}

data "aws_security_group" "rds_sg" {
  id = data.aws_db_instance.rds.vpc_security_groups[0]
}

data "aws_region" "current" {
  name = "us-east-1"
}
# data "aws_security_group" "sg_lambda" {
#   name = "lambda-general"
# }