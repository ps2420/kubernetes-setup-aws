
output "aws_load_balancer_zone_id" {
  value = "${data.aws_elb.elb.zone_id}"
}

output "aws_load_balancer_zone_dns_name" {
  value = "${data.aws_elb.elb.dns_name}"
}

output "aws_route53_zone_id" {
  value = "${data.aws_route53_zone.selected.zone_id}"
}

output "aws_route53_zone_name" {
  value = "${data.aws_route53_zone.selected.name}"
}

output "aws_route53_record_cicd" {
  value = "${aws_route53_record.cicd.name}"
}

output "aws_route53_record_grafana" {
  value = "${aws_route53_record.grafana.name}"
}

output "aws_route53_record_docker" {
  value = "${aws_route53_record.docker_reg.name}"
}