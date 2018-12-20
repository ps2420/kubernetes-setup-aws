#!/bin/sh

echo "  "
echo "==> Installation is configured in following steps.."
echo "==> Step 1: Installing helm"
echo "==> Step 2: Encrypting Passwords"
echo "==> Step 3: Create S3 bucket for docker registry with name: $NAME.kops.docker.reg"
echo "==> Step 4: Destroy all kubernetes components, grafana, prometheus, gocd, ingress-controllers"
echo "  "
sleep 5
 
echo "==> Installing helm"
./scripts//helm_install.sh

source ./scripts/env-local.sh
#source ./scripts/env-var.sh

echo "==> Encrypt Passwords.."
rm ./gocd/passwd
htpasswd -nb -B  admin $GOCD_PASSWORD >> ./gocd/passwd
 
rm ./docker-reg/htpasswd
docker run --entrypoint htpasswd registry:2 -Bbn admin $DOCKER_REGISTRY_PASSWORD > ./docker-reg/htpasswd

export DOCKER_REG_HTTP_PASSWD=$(cat ./docker-reg/htpasswd)
sleep 5

if aws s3 ls "s3://$DOCKER_S3_BUCKET" 2>&1 | grep -q 'NoSuchBucket'
then
   echo "==> Specified bucket $DOCKER_S3_BUCKET doesnot existing creating bucket $DOCKER_S3_BUCKET"
   aws s3api create-bucket --bucket $DOCKER_S3_BUCKET --create-bucket-configuration LocationConstraint=$S3_REGION
   aws s3api put-bucket-versioning --bucket $DOCKER_S3_BUCKET --versioning-configuration Status=Enabled
   aws s3api put-bucket-encryption --bucket $DOCKER_S3_BUCKET --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
   aws s3 cp ./../README.md s3://$DOCKER_S3_BUCKET
fi

source ./scripts/comp-setup.sh

echo " "
echo "***************************************************************************"
sleep 5
SVC_ENDPOINT=`kubectl describe svc -n ingress-nginx | grep 'LoadBalancer Ingress'`
PREFIX='LoadBalancer Ingress: '
LOAD_BALANCER=${SVC_ENDPOINT#"$PREFIX"}

ELB_URL=$(echo $LOAD_BALANCER | tr -d ' ')

echo " "
echo " ==> LOAD_BALANCER_URL for route 53:[$ELB_URL]" 
echo " "
