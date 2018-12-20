#!/bin/sh

export NAME=$DNS_NAME
export TF_BUCKET=$NAME.tf.state
export LOCATION_CONSTRAINT=ap-southeast-1

if aws s3 ls "s3://$TF_BUCKET" 2>&1 | grep -q 'NoSuchBucket'
then
   echo "==> Specified bucket $TF_BUCKET doesnot existing creating bucket $TF_BUCKET"
   aws s3api create-bucket --bucket $TF_BUCKET --create-bucket-configuration LocationConstraint=$LOCATION_CONSTRAINT
   aws s3api put-bucket-versioning --bucket $TF_BUCKET --versioning-configuration Status=Enabled
   aws s3api put-bucket-encryption --bucket $TF_BUCKET --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
fi

rm -rf ./k8s.tfplan

terraform init -backend-config="bucket=$TF_BUCKET" -backend-config="key=dev/kops" \
-backend-config="region=$LOCATION_CONSTRAINT" -var name=$NAME -input=false 

terraform plan -var name=$NAME -out=k8s.tfplan -input=false

#echo apply terraform plan
echo "==> Creating terraform resources now.."
terraform apply -input=false k8s.tfplan 

export NAME=$(terraform output cluster_name)
export KOPS_STATE_STORE=$(terraform output state_store)
export ZONES=$(terraform output -json availability_zones | jq -r '.value|join(",")')
export VPC_ID=$(terraform output vpc_id)

echo "==> CLUSTER-NAME: $NAME, KOPS_STATE_STORE: $KOPS_STATE_STORE, TERRAFORM_S3_BUCKET: $TF_BUCKET"
echo "==> VPC_ID: $VPC_ID"

sleep 5
echo "==> Creating kubernetes cluster now... "
sleep 10

PRIVATE_SUBNET=`terraform output private_subnet_ids`
PUBLIC_SUBNET=`terraform output public_subnet_ids`

PRIVATE_SUBNET_IDS=$(echo $PRIVATE_SUBNET | tr -d ' ')
PUBLIC_SUBNET_IDS=$(echo $PUBLIC_SUBNET | tr -d ' ')

echo "==> VPC :$VPC_ID"
echo "==> PRIVATE_SUBNET :$PRIVATE_SUBNET_IDS "
echo "==> PUBLIC_SUBNET  :$PUBLIC_SUBNET_IDS "
 
sleep 10
echo " "

kops create cluster --node-count=2 --node-size=t2.large --zones $ZONES --master-size t2.medium \
--name $NAME --master-volume-size 200 --node-volume-size 200 \
--networking calico --topology private --vpc $VPC_ID \
--subnets=$PRIVATE_SUBNET_IDS --utility-subnets=$PUBLIC_SUBNET_IDS --yes

echo ""
echo "==> Waiting for cluster to initialize.." 
sleep 600 

kops validate cluster


echo "==> Deploy dashboard on kubernetes cluster"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f ./dashboard/dashboard-full-access.yaml

#export metrics end point
kubectl apply -f ./dashboard/services.yaml
 
echo "  "
echo "====================================================================="
echo "Access Dashboard Via, Username: admin"
echo "Password: `kops get secrets kube --type secret -oplaintext`"

sleep 2
echo ""
echo "==> Secret token :"
kubectl --insecure-skip-tls-verify  describe secrets kubernetes-dashboard-token -n kube-system
echo 'https://api.'"$NAME"'/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login'

echo " "
echo " Refer k8s-components/README.md file for component installation.."

sleep 5
echo "==> CLUSTER-NAME: $NAME, KOPS_STATE_STORE: $KOPS_STATE_STORE, TERRAFORM_S3_BUCKET: $TF_BUCKET"

echo "==> All components has been installed successfully.."