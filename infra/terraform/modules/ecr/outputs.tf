output "repository_name" {
  value = { for key, value in aws_ecr_repository.repository_cors : key => value }
}