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

  # Backend remoto — descomente para persistir no S3
  # backend "s3" {
  #   bucket         = "fiap-officine-terraform-state"
  #   key            = "database/homolog/terraform.tfstate"
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
  environment = "homolog"
  project     = "fiap-officine"

  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "terraform"
    Repository  = "fiap-officine-database"
  }
}

# ──────────────────────────────────────────────
# Banco de Dados Gerenciado: AWS RDS PostgreSQL (Free Tier)
# ──────────────────────────────────────────────
module "rds" {
  source = "../../modules/rds"

  name            = "${local.project}-${local.environment}"
  database_name   = var.database_name
  master_username = var.master_username

  # Free Tier: db.t4g.micro (ARM Graviton2) ou db.t3.micro (x86_64)
  instance_class        = var.instance_class
  allocated_storage     = 20 # 20 GiB gp3 (Limite gratuito da AWS)
  max_allocated_storage = 20

  # Integração com a VPC criada no repo fiap-officine-kubernets
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.rds_security_group_id]

  # Configurações de custo reduzido para homologação
  multi_az                = false # Single-AZ para Free Tier
  skip_final_snapshot     = true
  backup_retention_period = 1

  tags = local.common_tags
}
