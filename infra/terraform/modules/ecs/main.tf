resource "aws_ecs_cluster" "ecs_cors_cluster" {
  name = "ECSCluster${var.environment}"
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.ecs_cors_cluster.name
  capacity_providers = ["FARGATE"]
}