resource "null_resource" "build_and_push_image" {
  provisioner "local-exec" {
    command = <<EOT
                        docker build -t ${var.name} ${var.context}
                        docker tag ${var.name}:latest ${var.registry}/${var.name}:latest
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${var.registry}
                        docker push ${var.registry}/${var.name}:latest
                EOT
  }

  triggers = {
    always_run = timestamp() # Esto asegura que siempre se ejecute
  }
}