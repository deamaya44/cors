variable "environment" {
  type        = string
  description = "The environment for the ECR repository"
}
variable "name" {
  type        = string
  description = "The name of the ECR repository"
}
variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the ECR repository"
}
variable "scan_on_push" {
  type        = bool
  description = "Whether to scan images on push"
}