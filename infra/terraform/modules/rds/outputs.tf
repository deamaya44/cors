output "rds_sg" {
    value = aws_security_group.rds_postgres_sg.id
}
output "secret_arn" {
    value = aws_secretsmanager_secret.rds_credentials.arn
}
output "rds_name" {
    value = aws_db_instance.rds_postgres.endpoint
}
output "dbname" {
    value = aws_db_instance.rds_postgres.db_name
  
}