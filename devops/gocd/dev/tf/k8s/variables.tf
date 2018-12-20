variable "name" {
  default = "bics.k8s.local"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "azs" {
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  type    = "list"
}
 
variable "vpc_cidr" {
  default = "10.20.0.0/16"
}
