#!/bin/sh

rm -rf ./route53.tfplan


terraform init -backend-config="bucket=$BUCKET_NAME" -backend-config="key=dev/route53" \
-backend-config="region=$LOCATION_CONSTRAINT" -input=false \
-var gocd_dns_name=$gocd_dns_name -var grafana_dns_name=$grafana_dns_name \
-var docker_reg_dns_name=$docker_reg_dns_name -var aws_elb_name=$aws_elb_name \
-var domain_name=$domain_name

terraform plan  -out=route53.tfplan -input=false \
-var gocd_dns_name=$gocd_dns_name -var grafana_dns_name=$grafana_dns_name \
-var docker_reg_dns_name=$docker_reg_dns_name -var aws_elb_name=$aws_elb_name \
-var domain_name=$domain_name

echo "==> Creating terraform resources now.."
terraform apply -input=false route53.tfplan 

echo "==> RDS instance has been created successfully"