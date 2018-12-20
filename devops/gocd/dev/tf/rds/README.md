## Introduction
terraform scripts to create database instance for sonar.

***
## Prerequisites
Follow previous requisistes for gocd/dev infra
 

## Get Started
1. Create S3 bucket to store terraform backend state
2. export variables names
```
export BUCKET_NAME=.....
export LOCATION_CONSTRAINT=ap-southeast-1
export SONAR_DB_PASSWORD=... 
```
***

## Scripts
./scripts/install_rds.sh

## Note:
As of now sonar instance is not created through k8-components.
Post DB instance creation user is required to create a DB inside db instance to be used by sonar.