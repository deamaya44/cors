variable "vpc_link" {
  type        = string
  description = "value of the vpc link"
}
variable "alb_dns" {
  type        = string
  description = "value of the alb dns"
}
variable "environment" {
  type        = string
  description = "value of the environment"
}
variable "name" {
  type        = string
  description = "value of the name"
}
variable "description" {
  type        = string
  description = "value of the description"
}
# variable "path" {
#   type        = string
#   description = "value of the path"
# }

variable "routes" {
  type = map(object({
    path    = string
    methods = map(any)
    path2 = optional(map(object({
      path    = optional(string)
      methods = optional(map(any))
    }))) # Define un valor por defecto como mapa vacío
  }))
}
# variable "routes" {
#   type = map(object({
#     path    = string
#     methods = map(any)
#   }))
# }
