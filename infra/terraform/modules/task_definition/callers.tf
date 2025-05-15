
data "aws_secretsmanager_secret" "globals" {
  name = var.secret
}
