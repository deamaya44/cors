# 🔹 Generar una contraseña aleatoria para la RDS
resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+"
}

# 🔹 Crear un secreto en AWS Secrets Manager
resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "rds_postgres_cors_${var.environment}"
}

# 🔹 Almacenar credenciales en el Secret Manager
resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = "rdscors"
    password = random_password.rds_password.result
  })
}

resource "aws_db_instance" "rds_postgres" {
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  db_name                         = "rdscors"
  identifier                      = "postgres-cors-${var.environment}"
  allocated_storage               = var.allocated_storage
  max_allocated_storage           = var.max_allocated_storage
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids          = [aws_security_group.rds_postgres_sg.id]
  storage_encrypted               = true
  backup_retention_period         = 1
  deletion_protection             = false
  performance_insights_enabled    = false
  monitoring_interval             = 0
  enabled_cloudwatch_logs_exports = ["postgresql"]
  parameter_group_name            = aws_db_parameter_group.postgres16.name
  port                            = 5432
  publicly_accessible             = false # Evita acceso público

  username = jsondecode(aws_secretsmanager_secret_version.rds_credentials_version.secret_string)["username"]
  password = jsondecode(aws_secretsmanager_secret_version.rds_credentials_version.secret_string)["password"]

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_postgres_sg" {
  name        = "cors_${var.environment}_sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group-cors-${var.environment}"
  subnet_ids  = var.private_subnets
  description = "Subnet group for RDS PostgreSQL"
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_db_parameter_group" "postgres16" {
  name   = "postresql-cors-${var.environment}"
  family = "postgres16"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

