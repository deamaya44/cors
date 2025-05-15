variable "vpc_id" {
  type        = string
  description = "VPC ID donde desplegar el cluster"
}

variable "private_subnets" {
  type        = list(string)
  description = "Lista de subnets privadas para el cluster"
}

variable "environment" {
  type        = string
  description = "Ambiente donde se desplegará el cluster"
}

variable "engine" {
  type        = string
  description = "Database engine to use for the RDS instance"
}

variable "engine_version" {
  type        = string
  description = "Version of the database engine"
}

variable "instance_class" {
  type        = string
  description = "Instance class for the RDS instance"
}

variable "allocated_storage" {
  type        = number
  description = "The amount of storage (in gigabytes) to allocate initially for the RDS instance"
}

variable "max_allocated_storage" {
  type        = number
  description = "The maximum amount of storage (in gigabytes) to allocate for the RDS instance"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to export to CloudWatch"
}