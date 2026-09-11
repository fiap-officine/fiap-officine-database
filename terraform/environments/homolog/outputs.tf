output "rds_instance_id" {
  description = "ID da instância RDS PostgreSQL"
  value       = module.rds.instance_id
}

output "rds_endpoint" {
  description = "Endpoint de conexão do banco de dados (host:port)"
  value       = module.rds.endpoint
}

output "rds_address" {
  description = "Hostname do RDS"
  value       = module.rds.address
}

output "rds_port" {
  description = "Porta de conexão do PostgreSQL"
  value       = module.rds.port
}

output "database_name" {
  description = "Nome do banco de dados"
  value       = module.rds.database_name
}

output "master_username" {
  description = "Usuário administrador"
  value       = module.rds.master_username
}

output "secret_arn" {
  description = "ARN do segredo no AWS Secrets Manager"
  value       = module.rds.secret_arn
}

output "secret_name" {
  description = "Nome do segredo no AWS Secrets Manager"
  value       = module.rds.secret_name
}
