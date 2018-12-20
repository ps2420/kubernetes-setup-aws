output "db_instance_id" {
  value = "${aws_db_instance.postgres.id}"
}

output "db_instance_address" {
  value = "${aws_db_instance.postgres.address}"
}
