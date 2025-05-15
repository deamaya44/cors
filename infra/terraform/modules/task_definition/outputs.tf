output "listerne_rule" {
  value = { for key, value in aws_lb_listener_rule.cors_rules : key => value }
}
output "globals_arn" {
  value = data.aws_secretsmanager_secret.globals.arn
}