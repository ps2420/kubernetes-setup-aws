
data "aws_elb" "elb" {
  name = "${var.aws_elb_name}"
}

data "aws_route53_zone" "selected" {
  name = "${var.domain_name}"
}

resource "aws_route53_record" "cicd" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.gocd_dns_name}"
  type    = "A"

  alias {
    name    = "${data.aws_elb.elb.dns_name}"
    evaluate_target_health = "${var.evaluate_target_health}"
    zone_id = "${data.aws_elb.elb.zone_id}"
  }
}

resource "aws_route53_record" "grafana" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.grafana_dns_name}"
  type    = "A"

  alias {
    name    = "${data.aws_elb.elb.dns_name}"
    evaluate_target_health = "${var.evaluate_target_health}"
    zone_id = "${data.aws_elb.elb.zone_id}"
  }
}

resource "aws_route53_record" "docker_reg" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.docker_reg_dns_name}"
  type    = "A"

  alias {
    name    = "${data.aws_elb.elb.dns_name}"
    evaluate_target_health = "${var.evaluate_target_health}"
    zone_id = "${data.aws_elb.elb.zone_id}"
  }

}
