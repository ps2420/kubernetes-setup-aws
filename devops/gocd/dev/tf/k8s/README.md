## Introduction
terraform scripts for kubernetes infra creation

***
## Prerequisites
Follow previous requisistes for gocd/dev infra

***
## Get Started
1. Create AWS Route 53 domain
2. export DNS_NAME=....

***
## Scripts
./gocd/dev/tf/k8s/scripts/kops_installation_k8s.sh

#### Note: Required S3 Bucket will be created internally
* Cluster name is set to DNS name
* Terraform state is saved to s3://$DNS_NAME.tf.state
* KOPS_STATE_STORE is s3://$DNS_NAME.kops.state

#### REFER k8-components/README.md to install kubernetes components
* gocd server
* gocd agent
* prometheus
* docker registry