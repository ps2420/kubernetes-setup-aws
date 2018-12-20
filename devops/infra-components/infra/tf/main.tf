provider "aws" {
  region = "ap-southeast-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = ["${data.aws_vpc.default.id}"]
  }
}

/* Public subnet */
resource "aws_subnet" "public" {
  vpc_id            = "${data.aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet_cidr}"
  map_public_ip_on_launch = true
  depends_on = ["data.aws_internet_gateway.default"]
  tags {
    Name = "public"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${data.aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${data.aws_internet_gateway.default.id}"
  }
}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}
