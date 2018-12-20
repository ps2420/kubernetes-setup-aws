## Introduction
terraform scripts to update route-53 records of AWS load balancer.

***
## Prerequisites
Follow previous requisistes for gocd/dev infra
To run this repository k8-components repository to be run before to get load balancer name


## Get Started
1. export DNS_NAME=..
2. export KOPS_STATE_STORE=s3://$DNS_NAME.kops.state
3. Run below commands to get load balancer end point
4. Create S3 bucket or use s3 existing bucket to store terraform backend state
```
SVC_ENDPOINT=`kubectl describe svc -n ingress-nginx | grep 'LoadBalancer Ingress'`
PREFIX='LoadBalancer Ingress: '
LOAD_BALANCER=${SVC_ENDPOINT#"$PREFIX"}
ELB_URL=$(echo $LOAD_BALANCER | tr -d ' ')
echo " ==> LOAD_BALANCER_URL for route 53:[$ELB_URL]" 
``` 

***
## Scripts
```
export BUCKET_NAME=.....
export gocd_dns_name=...
export grafana_dns_name=...
export docker_reg_dns_name=...
export aws_elb_name=...
export domain_name=...
./scripts/create_route53.sh
```