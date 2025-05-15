variable "name" {
  description = "The name of the docker image."
  type        = string
}
variable "context" {
  description = "The context for the docker build."
  type        = string
}
variable "dockerfile" {
  description = "The dockerfile to use for the build."
  type        = string
}
variable "registry" {
  description = "The URI of the docker image."
  type        = string
}