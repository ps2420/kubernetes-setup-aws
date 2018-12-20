#!/bin/sh

echo "==> Initializing terraform init for bics deployment"
terraform init

terraform workspace select dev
#Optional -> terraform plan -var-file=dev.tfvars

#terraform apply -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars -auto-approve

echo ""
echo "==> Applying terraform plan for infra creation.."