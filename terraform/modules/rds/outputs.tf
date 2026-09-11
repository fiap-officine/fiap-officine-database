output "instance_id" {
  description = "ID da instância RDS"
  value       = aws_db_instance.main.id
}

output "endpoint" {
  description = "Endpoint de conexão do RDS (host:port)"
  value       = aws_db_instance.main.endpoint
}

output "address" {
  description = "Hostname/Endereço do RDS"
  value       = aws_db_instance.main.address
}

output "port" {
  description = "Porta do PostgreSQL"
  value       = aws_db_instance.main.port
}

output "database_name" {
  description = "Nome do banco de dados"
  value       = aws_db_instance.main.db_name
}

output "master_username" {
  description = "Usuário administrador do banco de dados"
  value       = aws_db_instance.main.username
}

output "secret_arn" {
  description = "ARN do segredo no AWS Secrets Manager contendo as credenciais completas"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "secret_name" {
  description = "Nome do segredo no AWS Secrets Manager"
  value       = aws_secretsmanager_secret.db_credentials.name
}
