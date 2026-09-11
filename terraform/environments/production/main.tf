terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # backend "s3" {
  #   bucket         = "fiap-officine-terraform-state"
  #   key            = "database/production/terraform.tfstate"
  #   region         = "sa-east-1"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

locals {
  environment = "production"
  project     = "fiap-officine"

  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "terraform"
    Repository  = "fiap-officine-database"
  }
}

# ──────────────────────────────────────────────
# Banco de Dados Gerenciado: AWS RDS PostgreSQL (Produção - Multi-AZ)
# ──────────────────────────────────────────────
module "rds" {
  source = "../../modules/rds"

  name            = "${local.project}-${local.environment}"
  database_name   = var.database_name
  master_username = var.master_username

  instance_class        = var.instance_class
  allocated_storage     = 50
  max_allocated_storage = 200

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.rds_security_group_id]

  # Produção: Alta Disponibilidade Multi-AZ e Retenção de Backup
  multi_az                = true
  skip_final_snapshot     = false
  backup_retention_period = 7
  deletion_protection     = true

  tags = local.common_tags
}
