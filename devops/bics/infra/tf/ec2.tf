resource "aws_instance" "bics_instance" {
  ami                   = "${var.ami_id}"
  instance_type         = "${var.instance_type}"
  iam_instance_profile  = "${aws_iam_instance_profile.bics_instance_profile.name}"
  subnet_id             = "${aws_subnet.public.id}"
  security_groups       = ["${aws_security_group.allow_only_ssh.id}"]
  key_name              = "${var.bics_key}"

  root_block_device {
    volume_size = "200"
    volume_type = "standard"
  }


  user_data   = <<-EOF
                #!/bin/sh
                sudo -s
                sudo snap start amazon-ssm-agent
                EOF

  tags {
    Name    = "bics_infra"
    Partner = "Amaris"
  }

  connection {
    type      = "ssh"
    agent     = false
    timeout   = "5m"
    host      = "${aws_instance.bics_instance.public_ip}"
    user      = "ubuntu"
    private_key = "${file("files/sshkeys/amarispartner.pem")}"
  }

  provisioner "file" {
    source      = "files/install_ubuntu_packages.sh"
    destination = "/tmp/install_ubuntu_packages.sh"
  }

  provisioner "file" {
    source      = "files/sshkeys/"
    destination = "/home/ubuntu/.ssh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_ubuntu_packages.sh",
      "chmod 600 /home/ubuntu/.ssh/id_rsa",
      "chmod 600 /home/ubuntu/.ssh/amarispartner.pem",
      "cd /home/ubuntu/ && git clone ssh://git@bitbucket.ti-ra.net:7999/bics/devops-tw.git",
      "cd /home/ubuntu/ && git clone ssh://git@bitbucket.ti-ra.net:7999/bics/bics.git",
      "echo 'TOPIC_OWNER=${var.TOPIC_OWNER}' >> /home/ubuntu/.bashrc",
      "echo 'TOPIC_NAME=${var.TOPIC_NAME}' >> /home/ubuntu/.bashrc",
      "echo 'TOPIC_ERROR=${var.TOPIC_ERROR}' >> /home/ubuntu/.bashrc",
      "echo 'REGION=${var.region}' >> /home/ubuntu/.bashrc",
      "echo 'S3_BUCKET=${var.S3_BUCKET}' >> /home/ubuntu/.bashrc",
      "echo 'INPUT_FILE=${var.INPUT_FILE}' >> /home/ubuntu/.bashrc",
      "echo 'OUTPUT_FILE=${var.OUTPUT_FILE}' >> /home/ubuntu/.bashrc",
      "/tmp/install_ubuntu_packages.sh",
      "ls -lart /home/ubuntu/",
      "cd /home/ubuntu/bics && git checkout development && git pull",
      "sudo -u ubuntu mkdir -p /home/ubuntu/bics/logs",
      "/home/ubuntu/bics/bin/run_image_build.sh > ./logs/lambda_build_image.log",
      "docker swarm init",
      "sudo shutdown -h now",
    ]
  }
}

resource "aws_iam_instance_profile" "bics_instance_profile" {
  name  = "bics_instance_profile"
  role = "${aws_iam_role.bics_instance_role.name}"
}

resource "aws_iam_role" "bics_instance_role" {
  name               = "bics_instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "bics_instance_policy" {
  name        = "bics_instance_policy"
  description = "An instance policy with permission to S3, SNS, SSM and Cloudwatch."
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "cloudwatch:PutMetricData",
          "ds:CreateComputer",
          "ds:DescribeDirectories",
          "ec2:DescribeInstanceStatus",
          "logs:*",
          "ssm:*",
          "ec2messages:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*",
      "Condition": {
          "StringLike": {
              "iam:AWSServiceName": "ssm.amazonaws.com"
          }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
          "iam:DeleteServiceLinkedRole",
          "iam:GetServiceLinkedRoleDeletionStatus"
      ],
      "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*"
    },
    {
      "Action": [
          "sns:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "bics_instance_policy_attach" {
  name       = "bics_instance_policy_attach"
  roles      = ["${aws_iam_role.bics_instance_role.name}"]
  policy_arn = "${aws_iam_policy.bics_instance_policy.arn}"
}

resource "aws_security_group" "allow_only_ssh" {
  name        = "allow_only_ssh"
  description = "Allow only ssh inbound traffic"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
