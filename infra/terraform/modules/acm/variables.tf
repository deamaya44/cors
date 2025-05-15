variable "environment" {
  description = "Entorno del servicio"
  type        = string
}
variable "domain_name" {
  description = "Nombre de dominio para el servicio"
  type        = string
}
variable "zone_id" {
  description = "ID de la zona de Route53"
  type        = string
}