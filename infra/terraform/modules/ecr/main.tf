resource "aws_ecr_repository" "repository_cors" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  tags = {
    Environment = var.environment
  }
}
