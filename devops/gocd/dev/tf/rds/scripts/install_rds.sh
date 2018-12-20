#!/bin/sh

rm -rf ./rds.tfplan


terraform init -backend-config="bucket=$BUCKET_NAME" -backend-config="key=dev/rds" \
-backend-config="region=$LOCATION_CONSTRAINT" -var password=$SONAR_DB_PASSWORD -input=false 

terraform plan -var password=$SONAR_DB_PASSWORD -out=rds.tfplan -input=false

echo "==> Creating terraform resources now.."
terraform apply -input=false rds.tfplan 

echo "==> RDS instance has been created successfully"

rm -rf ./rds.tfplan