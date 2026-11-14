variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "db_subnet_group_name" {
  description = "DB Subnet Group (null = lido do SSM publicado pelo fiap-officine-kubernets)"
  type        = string
  default     = null
}

variable "rds_security_group_id" {
  description = "Security Group do RDS (null = lido do SSM publicado pelo fiap-officine-kubernets)"
  type        = string
  default     = null
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
  description = "Tipo de instância do RDS (Free Tier: db.t4g.micro ou db.t3.micro)"
  type        = string
  default     = "db.t4g.micro"
}
