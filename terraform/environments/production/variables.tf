variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "sa-east-1"
}

variable "db_subnet_group_name" {
  description = "Nome do DB Subnet Group criado na VPC de produção"
  type        = string
  default     = "fiap-officine-production"
}

variable "rds_security_group_id" {
  description = "ID do Security Group do RDS criado no repositório fiap-officine-kubernets"
  type        = string
}

variable "database_name" {
  description = "Nome do banco de dados inicial"
  type        = string
  default     = "officine_db"
}

variable "master_username" {
  description = "Nome do usuário administrador"
  type        = string
  default     = "dbadmin"
}

variable "instance_class" {
  description = "Tipo de instância do RDS para produção"
  type        = string
  default     = "db.t4g.small"
}
