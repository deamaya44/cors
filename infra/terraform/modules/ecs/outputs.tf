output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cors_cluster.name
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cors_cluster.id
}

# output "task_definition_arn" {
#   value       = module.ecs.task_definition_arn
#   description = "ARN de la definición de tarea"
# }

# output "task_role_arn" {
#   value       = module.ecs.task_role_arn
#   description = "The Amazon Resource Name (ARN) specifying the ECS service role."
# }

# output "task_sg_id" {
#   description = "The Amazon Resource Name (ARN) that identifies the service security group."
#   value       = module.ecs.service_sg_id
# }

# output "task_execution_role_arn" {
#   value       = module.ecs.execution_role_arn
#   description = "The Amazon Resource Name (ARN) specifying the ECS execution role."
# }