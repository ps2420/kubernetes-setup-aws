module "vpc" {
  source   = "./modules/vpc"
  name     = "${var.name}" 
  vpc_cidr = "${var.vpc_cidr}"

  tags {
    Infra             = "${var.name}"
    Terraformed       = "true"
    KubernetesCluster = "${var.name}"
  }
}

module "subnet_pair" {
  source              = "./modules/subnet-pair"
  name                = "${var.name}" 
  vpc_id              = "${module.vpc.vpc_id}"
  vpc_cidr            = "${module.vpc.cidr_block}"
  internet_gateway_id = "${module.vpc.internet_gateway_id}"
  availability_zones  = "${var.azs}"

  tags {
    Infra             = "${var.name}" 
    Terraformed       = "true"
    KubernetesCluster = "${var.name}"
  }
}

resource "aws_s3_bucket" "state_store" {
  bucket        = "${var.name}.kops.state"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags {
    Name        = "${var.name}"
    Infra       = "${var.name}"
    Terraformed = "true"
  }
}
