terraform {
  backend "s3" {
    bucket = "bics-tf-state"
    key = "dev"
    region = "ap-southeast-1"
  }
}
