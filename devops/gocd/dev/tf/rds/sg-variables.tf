variable "cidr_blocks" {
  default     = "0.0.0.0/0"
  description = "CIDR blocks for sonar_postgres_db_instance"
}

variable "sg_name" {
  default     = "sonar_postgres_db_instance"
  description = "Security group for sonar postgres db instance"
}
