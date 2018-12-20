data "aws_vpc" "default" {
  default = true
}

/*
data "aws_subnet" "default" {
  vpc_id            = "${data.aws_vpc.default.id}"
  default_for_az    = true
  availability_zone = "${var.availability_zone}"
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.vpc.id}"
}
*/

resource "aws_security_group" "default" {
  name        = "sonar_rds_postgres_sg"
  description = "Allow all inbound traffic"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "sonar-db-instance"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}
