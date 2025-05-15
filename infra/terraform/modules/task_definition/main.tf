resource "aws_ecs_task_definition" "microservices" {
  family                   = "${var.name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.role

  container_definitions = jsonencode([
    {
      name      = var.name
      image     = var.image
      essential = true
      portMappings = [
        {
          containerPort = var.containerPort
          hostPort      = var.containerPort
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.environment}/${var.name}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [
        {
          name  = "ENV"
          value = var.environment
        },
        {
          name = "MICRO"
          value = join("-", slice(split("-", var.name), 1, length(split("-", var.name))))
        },
        {
          name      = "APP_PORT"
            value = tostring(var.containerPort)
        }
      ]
      secrets = [
        {
          name      = "RDS_HOSTNAME"
          valueFrom = "${data.aws_secretsmanager_secret.globals.arn}:RDS_HOSTNAME::"
        },
        {
          name      = "RDS_USERNAME"
          valueFrom = "${data.aws_secretsmanager_secret.globals.arn}:RDS_USERNAME::"
        },
        {
          name      = "RDS_PASSWORD"
          valueFrom = "${data.aws_secretsmanager_secret.globals.arn}:RDS_PASSWORD::"
        },
        {
          name      = "RDS_PORT"
          valueFrom = "${data.aws_secretsmanager_secret.globals.arn}:RDS_PORT::"
        },
        # {
        #   name      = "APP_PORT"
        #   valueFrom = "${data.aws_secretsmanager_secret.globals.arn}:APP_PORT::"
        # },
        {
          name      = "JWT_EXPIRES_IN_MINUTES"
          valueFrom = "${data.aws_secretsmanager_secret.globals.arn}:JWT_EXPIRES_IN_MINUTES::"
        },
        {
          name      = "JWT_EXPIRES_IN_MINUTES_REFRESH"
          valueFrom = "${data.aws_secretsmanager_secret.globals.arn}:JWT_EXPIRES_IN_MINUTES_REFRESH::"
        },
        {
          name      = "JWT_SECRET"
          valueFrom = "${data.aws_secretsmanager_secret.globals.arn}:JWT_SECRET::"
        },
        {
          name      = "JWT_SECRET_KEY"
          valueFrom = "${data.aws_secretsmanager_secret.globals.arn}:JWT_SECRET_KEY::"
        }
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.environment}/${var.name}"
  retention_in_days = 7
}

resource "aws_security_group" "cors_service_sg" {
  name        = "${var.name}_service_sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    prevent_destroy = false
  }
}
resource "aws_security_group_rule" "allow_ecs_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = var.rds_sg
  source_security_group_id = aws_security_group.cors_service_sg.id
  depends_on               = [aws_security_group.cors_service_sg]
}

resource "aws_lb_target_group" "cors_tg" {
  name        = "${var.name}-tg"
  port        = var.containerPort
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  lifecycle {
    prevent_destroy = false
  }

  health_check {
    path                = var.path
    interval            = 45
    timeout             = 15
    healthy_threshold   = 5
    unhealthy_threshold = 5
    matcher             = var.matcher
  }
}
resource "aws_lb_target_group" "websocket_tg" {
  count       = var.websocket ? 1 : 0
  name        = "${var.name}-ws-tg"
  port        = var.containerPort
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  lifecycle {
    prevent_destroy = false
  }

  health_check {
    path                = var.path
    interval            = 45
    timeout             = 15
    healthy_threshold   = 5
    unhealthy_threshold = 5
    matcher             = var.matcher
  }
}

resource "aws_lb_listener_rule" "cors_rules" {
  listener_arn = var.listener_alb_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.cors_tg.arn
      }
      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }

  condition {
    path_pattern {
      values = ["/${var.environment}/${join("-", slice(split("-", var.name), 1, length(split("-", var.name))))}*"]
      # values = ["/"]
    }
  }

  depends_on = [aws_lb_target_group.cors_tg]
}

resource "aws_lb_listener_rule" "websocket_rules" {
  count       = var.websocket ? 1 : 0
  listener_arn = var.listener_alb2_arn
  action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.websocket_tg[0].arn
      }
      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }

  condition {
    path_pattern {
      values = ["/${var.environment}/${join("-", slice(split("-", var.name), 1, length(split("-", var.name))))}*"]
      # values = ["/"]
    }
  }

  depends_on = [aws_lb_target_group.websocket_tg]
}
resource "aws_ecs_service" "cors_service" {
  name                               = "${var.name}-service"
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.microservices.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.cors_service_sg.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.cors_tg.arn
    container_name   = var.name
    container_port   = var.containerPort
  }

  dynamic "load_balancer" {
    for_each = var.websocket ? [aws_lb_target_group.websocket_tg[0]] : []
    content {
      target_group_arn = load_balancer.value.arn
      container_name   = var.name
      container_port   = var.containerPort
    }
  }

  depends_on = [
    aws_lb_target_group.cors_tg,
    aws_lb_listener_rule.cors_rules,
    aws_lb_listener_rule.websocket_rules,
    aws_security_group.cors_service_sg
  ]
}
