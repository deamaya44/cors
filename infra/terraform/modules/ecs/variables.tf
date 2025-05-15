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
  default     = ""
  description = "description"
}