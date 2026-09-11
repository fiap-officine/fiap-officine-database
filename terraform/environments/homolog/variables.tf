variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "sa-east-1"
}

variable "db_subnet_group_name" {
  description = "Nome do DB Subnet Group criado na VPC de homologação"
  type        = string
  default     = "fiap-officine-homolog"
}

variable "rds_security_group_id" {
  description = "ID do Security Group do RDS criado no repositório fiap-officine-kubernets"
  type        = string
  default     = "sg-homolog-rds-placeholder"
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
