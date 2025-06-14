locals {
  ### Microservices ###
  microservices = {
    "backend" = {
      docker_context       = "../../backend"
      dockerfile           = "Dockerfile"
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
      image_count_limit    = 11
      cpu                  = "1024"
      memory               = "2048"
      containerPort        = 8080
      desired_count        = 1
      websocket            = false
      ingress = {
        from_port   = 8080
        to_port     = 8080
        cidr_blocks = ["0.0.0.0/0"]
      }
      hc = {
        path    = "/api/items"
        matcher = "404"
      }
    }
  }
}