locals {


  account_id_map = {
    dev  = "471112970056"
    qa   = "" #Pending
    uat  = "" #Pending
    prod = "" #Pending
  }

  environmentMap = {
    dev  = "dev"
    qa   = "" #Pending
    uat  = "" #Pending
    prod = "" #Pending
  }

  cidr_blockMap = {
    dev  = "172.16.97.0/24"
    qa   = "" #Pending
    uat  = "" #Pending
    prod = "" #Pending
  }

  rds_instance_map = {
    dev  = "db-cors-dev"
    qa   = "" #Pending
    uat  = "" #Pending
    prod = "" #Pending
  }

  acm_domains_map = {
    dev  = "dev.devopsamaya.com"
    qa   = "" #Pending
    uat  = "" #Pending
    prod = "" #Pending
  }
  acm_certificates_map = {
    dev = "arn:aws:acm:us-east-1:975050209148:certificate/7ebca2e5-2b56-4baf-8681-abb851ea70d3"
    qa  = "" #Pending
    uat = "" #Pending
    prod = "" #Pending
  }
  secrets_map = {
    dev  = "micros-dev-envs"
    qa   = "" #Pending
    uat  = "" #Pending
    prod = "" #Pending
  }

  environment = local.environmentMap[terraform.workspace]
  cidr_block  = local.cidr_blockMap[terraform.workspace]
  rdsname     = local.rds_instance_map[terraform.workspace]
  secret      = local.secrets_map[terraform.workspace]
  acm_cert = local.acm_certificates_map[terraform.workspace]
  #AssumeRoleARN Operaciones
  account_id        = local.account_id_map[terraform.workspace]
  domains = local.acm_domains_map[terraform.workspace]
  #Some for each
  # bucles = {
  #   registry = {
  #     ejemplo = module.ecr.repository_name
  #   }
  # }
}