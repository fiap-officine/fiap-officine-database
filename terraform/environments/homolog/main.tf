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

  # State remoto no S3 (configuração parcial). O workflow terraform.yml cria o
  # bucket fiap-officine-tfstate-<account_id> se não existir e passa
  # bucket/key/region no init. Uso local sem AWS: terraform init -backend=false
  backend "s3" {
    encrypt = true
  }
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
  db_subnet_group_name   = local.db_subnet_group_name
  vpc_security_group_ids = [local.rds_security_group_id]

  # Configurações de custo reduzido para homologação
  multi_az                = false # Single-AZ para Free Tier
  skip_final_snapshot     = true
  backup_retention_period = 1

  tags = local.common_tags
}

# ──────────────────────────────────────────────
# Integração via SSM Parameter Store
#   - lê a rede publicada pelo fiap-officine-kubernets
#   - publica endpoint e credenciais master para os pipelines dos
#     microsserviços (Job de bootstrap dos bancos lógicos)
# ──────────────────────────────────────────────
locals {
  ssm_prefix            = "/${local.project}/${local.environment}"
  db_subnet_group_name  = var.db_subnet_group_name != null ? var.db_subnet_group_name : data.aws_ssm_parameter.db_subnet_group_name.value
  rds_security_group_id = var.rds_security_group_id != null ? var.rds_security_group_id : data.aws_ssm_parameter.rds_security_group_id.value
}

data "aws_ssm_parameter" "db_subnet_group_name" {
  name = "${local.ssm_prefix}/rds/db-subnet-group-name"
}

data "aws_ssm_parameter" "rds_security_group_id" {
  name = "${local.ssm_prefix}/rds/security-group-id"
}

resource "aws_ssm_parameter" "rds" {
  for_each = {
    "rds/address"         = module.rds.address
    "rds/port"            = tostring(module.rds.port)
    "rds/database-name"   = module.rds.database_name
    "rds/master-username" = module.rds.master_username
  }

  name  = "${local.ssm_prefix}/${each.key}"
  type  = "String"
  value = each.value
}

resource "aws_ssm_parameter" "rds_master_password" {
  name  = "${local.ssm_prefix}/rds/master-password"
  type  = "SecureString"
  value = module.rds.master_password
}
