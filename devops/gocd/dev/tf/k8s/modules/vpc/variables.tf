variable "name" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "tags" {
  type    = "map"
  default = {}
}
