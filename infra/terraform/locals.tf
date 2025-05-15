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
    dev  = "devopsamaya.com"
    qa   = "" #Pending
    uat  = "" #Pending
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
  account_id = local.account_id_map[terraform.workspace]
  domains    = local.acm_domains_map[terraform.workspace]

  rds-postgres = {
    dev = {
      enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
      instance_class                  = "db.t4g.micro"
      engine                          = "postgres"
      engine_version                  = "16.3"
      allocated_storage               = 20
      max_allocated_storage           = 100
    }
  }
}