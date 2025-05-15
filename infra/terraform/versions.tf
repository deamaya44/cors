terraform {

  required_version = ">= 1.6.0, < 2.0.0"
  required_providers {
    aws = {
      version = "~> 5.50.0"
      source  = "hashicorp/aws"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.8.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }

  }
}