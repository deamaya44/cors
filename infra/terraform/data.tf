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



data "aws_region" "current" {
  name = "us-east-1"
}

data "aws_route53_zone" "dns_zone" {
  name         = "devopsamaya.com."
  private_zone = false
}
# data "aws_security_group" "sg_lambda" {
#   name = "lambda-general"
# }