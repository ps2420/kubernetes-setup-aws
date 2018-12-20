variable "region" {
  default = "ap-southeast-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "public_subnet_cidr" {
  default = "172.1.0.0/24"
}

variable "allowed_ip" {
  default = "0.0.0.0/0"
}

variable "ami_id" {
  default = "ami-09a85d7a2acba5ba6"
}

variable "bics_key" {
  default = "bics_keypair"
}

variable "prerequisite_s3_bucket" {
  default = "amaris.bics.de.ratio"
}

variable "bics_ec2_notification_topic" {
  default = "BICS_EC2_NOTIFICATION"
}

variable "bics_notification_topic" {
  default = "BICS_NOTIFICATION"
}

variable "bics_error_notification_topic" {
  default = "BICS_ERROR_NOTIFICATION"
}

variable "terraform_state_file" {
  default = "bics-tf-state"
}




variable "TOPIC_OWNER" {
  default = "893078813177"
}

variable "TOPIC_NAME" {
  default = "BICS_NOTIFICATION"
}

variable "TOPIC_ERROR" {
  default = "BICS_ERROR_NOTIFICATION"
}

variable "S3_BUCKET" {
  default = "amaris.bics.de.ratio"
}

variable "INPUT_FILE" {
  default = "2018/20180103 - Temasek BICS Jan 2018 - VE Removed.xlsx"
}

variable "OUTPUT_FILE" {
  default = "all_output.zip"
}
