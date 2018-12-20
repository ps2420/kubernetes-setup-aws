## Introduction
Devops repository for bics infrastructure

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
1. Create S3 bucket to store terraform backend state
```
Folder structures:    
  a) <S3_BUCKET>/bics/Archived
  b) <S3_BUCKET>/bics/Input
  c) <S3_BUCKET>/Models
  d) <S3_BUCKET>/Outputs
```

2. SNS Topic to receive the notification:
```
  a) BICS_EC2_NOTIFICATION
  b) BICS_ERROR_NOTIFICATION
  c) BICS_NOTIFICATION  

Note the topic URN from AWS lambda console, change lambda/bics_ect_start, bics_ec2_stop .py scripts
and move it to tf/files in zip format.  
```

4. Update the infra/tf/files/dev.tf.vars files with prerequisite_s3_bucket & TOPIC_OWNER name and respective parameters.

***
## Scripts
```
cd infra/tf
chmod +x ./scripts/install_bics.sh
./scripts/install_bics.sh
```

***
## Remarks
Check for confulence pages for any more update

