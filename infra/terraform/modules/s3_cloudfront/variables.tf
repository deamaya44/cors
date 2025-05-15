variable "bucket_name" {
  type        = string
  description = "Nombre del ALB"
}

variable "environment" {
  type        = string
  default     = ""
  description = "description"
}

variable "s3_access" {
  description = "The AWS region to deploy resources in"
  type        = string
}
variable "aliases" {
  description = "The aliases for cloudfront"
  type        = list(string)
}
variable "acm_certificate_arn" {
  description = "The ACM certificate ARN"
  type        = string
}