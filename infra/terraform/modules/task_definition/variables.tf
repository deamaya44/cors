variable "image" {
  type        = string
  description = "Nombre de la imagen a desplegar"
}
variable "name" {
  type        = string
  description = "Nombre del servicio"
}
variable "environment" {
  type        = string
  description = "Entorno del servicio"
}
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}
variable "role" {
  type        = string
  description = "Nombre del rol de ECS"
}
variable "cluster_id" {
  description = "The arn of the ECS cluster"
  type        = string
}

variable "private_subnets" {
  type        = list(string)
  description = "Lista de subnets privadas para el cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID donde desplegar el cluster"
}
variable "listener_alb_arn" {
  description = "ARN del Listener del ALB"
  type        = string
}
variable "cpu" {
  type        = number
  description = "Cantidad de CPU para la tarea"
}

variable "memory" {
  type        = number
  description = "Cantidad de memoria para la tarea"
}
variable "containerPort" {
  type        = number
  description = "Puerto en el que el contenedor escucha"
}
variable "from_port" {
  type        = number
  description = "Puerto de origen"
}

variable "to_port" {
  type        = number
  description = "Puerto de destino"
}
variable "cidr_blocks" {
  type        = list(string)
  description = "Lista de CIDR blocks para el ingreso"
}
variable "path" {
  type        = string
  description = "Ruta para la verificación de salud del servicio"
}

variable "matcher" {
  type        = string
  description = "Matcher para la verificación de salud del servicio"
}
variable "desired_count" {
  type        = number
  description = "Número de tareas deseadas"

}
variable "secret" {
  type        = string
  description = "Nombre del secreto de ECS"
}
variable "rds_sg" {
  type        = string
  description = "ID del security group de RDS"
}
variable "rds_name" {
  type        = string
  description = "Nombre del host de la base de datos RDS"
}
variable "dbname" {
  type        = string
  description = "Nombre de la base de datos"
}
variable "domain_name" {
  type        = string
  description = "Nombre de dominio"
}