variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "database_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = "officine_db"
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "16.3"
}

variable "instance_class" {
  description = "RDS instance class (db.t4g.micro or db.t3.micro for Free Tier)"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Allocated storage size in GiB (Free Tier allows up to 20 GiB)"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Upper limit for storage autoscaling (0 to disable autoscaling)"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type (gp3 recommended)"
  type        = string
  default     = "gp3"
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group (from fiap-officine-kubernets VPC)"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate with RDS"
  type        = list(string)
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ (false for Free Tier)"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before deleting instance"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Days to retain automated backups (1 for Free Tier)"
  type        = number
  default     = 1
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
