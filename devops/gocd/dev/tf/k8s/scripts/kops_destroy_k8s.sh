#!/bin/sh

#EXPORT
#EXPORT
export NAME=$DNS_NAME
export TF_BUCKET=$NAME.tf.state
export LOCATION_CONSTRAINT=ap-southeast-1

export BUCKET_NAME=$NAME.kops.state

export KOPS_STATE_STORE=s3://$BUCKET_NAME
export S3_BUCKET=$KOPS_STATE_STORE
export LOCATION_CONSTRAINT=ap-southeast-1
export AVAIL_ZONE=ap-southeast-1a,ap-southeast-1b,ap-southeast-1c

echo "==>. destroy kubernetes cluster: kops delete cluster --name=$NAME --yes"
echo "==>. destroy terraform : terraform destroy -var name=$NAME"

echo ""
sleep 5
echo "==> Destroying kubernetes cluster..."

kops delete cluster --name=$NAME --yes
sleep 10

echo "==> Destroying terraform state.."
terraform destroy -var name=$NAME
rm -rf ./k8s.tfplan