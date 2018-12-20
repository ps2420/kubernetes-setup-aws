#!/bin/sh

rm -rf ./rds.tfplan

terraform destroy -var password=$SONAR_DB_PASSWORD