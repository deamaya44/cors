output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}