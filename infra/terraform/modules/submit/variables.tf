variable "environment" {
  description = "Entorno del servicio"
  type        = string
}
variable "bucket_name" {
  type        = string
  description = "Nombre del bucket de S3"
}
variable "cloudfrontid" {
    type        = string
    description = "ID de CloudFront"
}