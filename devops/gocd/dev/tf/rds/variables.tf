variable "aws_region" {
  default = "ap-southeast-1"
}

variable "project" {
  default = "sonar"
}

variable "environment" {
  default = "dev"
}

variable "identifier" {
  default     = "sonar-postgres-rds"
  description = "Identifier for your DB"
}

variable "storage" {
  default     = "50"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "postgres"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"

  default = {
    mysql    = "5.7.21"
    postgres = "9.6.8"
  }
}

variable "instance_class" {
  default     = "db.t2.large"
  description = "Instance class"
}

variable "db_name" {
  default     = "sonar_postgres_db"
  description = "sonar postgres instance"
}

variable "username" {
  default     = "sonar"
  description = "sonar db user name"
}

variable "password" {
  description = "password, provide through your ENV variables"
}

variable "backup_retention_period" {
  default = "30"
}

variable "backup_window" {
  # 12:00AM-12:30AM ET
  default = "04:00-04:30"
}

variable "maintenance_window" {
  # SUN 12:30AM-04:30AM ET
  default = "sun:04:30-sun:09:30"
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "final_snapshot_identifier" {
  default = "terraform-aws-postgresql-rds-snapshot"
}

variable "skip_final_snapshot" {
  default = true
}

variable "copy_tags_to_snapshot" {
  default = false
}

variable "multi_availability_zone" {
  default = false
}

variable "storage_encrypted" {
  default = false
}

variable "monitoring_interval" {
  default = "5"
}