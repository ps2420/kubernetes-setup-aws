#!/bin/sh

export PREFIX_DIR=docker-reg

helm install stable/docker-registry --name docker-registry --namespace docker-registry \
--set secrets.s3.accessKey=$S3_ACCESS_KEY --set secrets.s3.secretKey=$S3_SECRET_KEY \
--set s3.region=$S3_REGION --set s3.bucket=$DOCKER_S3_BUCKET --set storage=s3 \
--set s3.encrypt=true --set s3.secure=true --set replicaCount=2 \
--set secrets.htpasswd=$DOCKER_REG_HTTP_PASSWD

#echo "Create ingress rules"
sed -e "s/DOCKER_DNS/$DOCKER_DNS/g" ./$PREFIX_DIR/ingress-template.yaml | kubectl apply -f -


#helm install stable/docker-registry --name docker-registry --namespace docker-registry --set secrets.htpasswd=$HTTP_PASSWD