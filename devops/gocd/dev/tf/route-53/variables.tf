variable "aws_region" {
  default = "ap-southeast-1"
}

variable "domain_name" {
  default   = ""
}

variable "aws_elb_name" {
  default   = "" 
}

variable "gocd_dns_name" {
  default    = ""
}

variable "grafana_dns_name" {
  default   = ""
}

variable "docker_reg_dns_name" {
  default   = ""
}
 
variable "evaluate_target_health" {
  default     = "true"
  description = "Set to true if you want Route 53 to determine whether to respond to DNS queries"
}
