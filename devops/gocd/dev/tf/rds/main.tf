

resource "aws_db_instance" "postgres" {
  depends_on             = ["aws_security_group.default"]
  identifier             = "${var.identifier}"
  allocated_storage      = "${var.storage}"
  engine                 = "${var.engine}"
  engine_version         = "${lookup(var.engine_version, var.engine)}"
  instance_class         = "${var.instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  
  backup_retention_period    = "${var.backup_retention_period}"
  backup_window              = "${var.backup_window}"
  maintenance_window         = "${var.maintenance_window}"
  
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  final_snapshot_identifier  = "${var.final_snapshot_identifier}"
  skip_final_snapshot        = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot      = "${var.copy_tags_to_snapshot}"
  multi_az                   = "${var.multi_availability_zone}"
  name                       = "sonarbicsinstance01"
  publicly_accessible        = "true"
  deletion_protection        = "true"
  multi_az                   = "true" 
  
  
  tags {
    Name        = "sonar-db-instance"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}
