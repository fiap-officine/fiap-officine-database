# ──────────────────────────────────────────────
# Senha Aleatória do Administrador
# ──────────────────────────────────────────────
resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# ──────────────────────────────────────────────
# Instância AWS RDS PostgreSQL (Free Tier)
# ──────────────────────────────────────────────
resource "aws_db_instance" "main" {
  identifier = "${var.name}-rds"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type

  db_name  = var.database_name
  username = var.master_username
  password = random_password.master_password.result
  port     = 5432

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  publicly_accessible         = false
  multi_az                    = var.multi_az
  backup_retention_period     = var.backup_retention_period
  skip_final_snapshot         = var.skip_final_snapshot
  deletion_protection         = var.deletion_protection
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  tags = merge(var.tags, {
    Name = "${var.name}-rds"
  })

  lifecycle {
    ignore_changes = [
      password
    ]
  }
}

# ──────────────────────────────────────────────
# AWS Secrets Manager: Armazenamento Seguro de Credenciais
# ──────────────────────────────────────────────
resource "aws_secretsmanager_secret" "db_credentials" {
  name_prefix             = "${var.name}-db-credentials-"
  description             = "Database credentials for ${var.name} RDS PostgreSQL"
  recovery_window_in_days = 0

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    engine   = "postgres"
    host     = aws_db_instance.main.address
    port     = aws_db_instance.main.port
    dbname   = var.database_name
    username = var.master_username
    password = random_password.master_password.result
    url      = "postgresql://${var.master_username}:${random_password.master_password.result}@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${var.database_name}"
  })
}
