output "name" {
  value = "${var.name}"
}

output "cluster_name" {
  value = "${var.name}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "state_store" {
  value = "s3://${aws_s3_bucket.state_store.id}"
}

output "public_subnet_ids" {
  value = "${module.subnet_pair.public_subnet_ids}"
}

output "private_subnet_ids" {
  value = "${module.subnet_pair.private_subnet_ids}"
}

output "nat_gateway_ids" {
  value = "${module.subnet_pair.nat_gateway_ids}"
}

output "availability_zones" {
  value = "${module.subnet_pair.availability_zones}"
}
