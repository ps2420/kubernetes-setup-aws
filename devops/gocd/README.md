## Introduction
Devops repository for gocd infrastrucures - kubernetes cluster.

tf folder contains scripts for creating kubernetes infra by terraform script
k8-components contains shell script to deploy kubernetes components for ex: prometheys, gocd, sonar..

***
## Prerequisites

#### Command line tools to be installed
* aws-cli
* kubernetes-cli
* kubernetes-helm
* kops
* terraform 
#### Note: For MAC user run script (./install_mac_softwares.sh)

#### AWS IAM user in place with following access
* ec2FullAccess
* s3FullAccess
* vpcFullAccess
* route53FullAccess
* IAmFullAccess.
* RDS Full Access

***
## Get Started

#### Setup AWS Credentials
1. aws configure
2. export AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY

### Navigate to dev/tf/k8s folder and follow instructions