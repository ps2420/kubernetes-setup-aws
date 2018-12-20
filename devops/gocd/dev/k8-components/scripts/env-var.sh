#!/bin/sh

#https://github.com/helm/charts/tree/master/stable/sonarqube

#ingress-nginx controller
#export AWS_ARN_CERT=

#SONAR SETUP
#export POSTGRE_SERVER=sonardb.c2namut11jtm.ap-southeast-1.rds.amazonaws.com
#export POSTGRE_USER=sonar
#export POSTGRE_DB=sonardb
#export SONAR_DNS=sonar.bics.ti-ra.net

export NAME=$DNS_NAME
export DOCKER_REG_S3_BUCKET=$NAME.kops.docker.reg

#GO-CD SETUP
export DOCKER_REGISTRY_HOST=dockerreg.bics.ti-ra.net
export DOCKER_REGISTRY_USERNAME=admin
export DOCKER_REG_MAIL=sharlenewong@temasek.com.sg
export DOCKER_DNS=$DOCKER_REGISTRY_HOST
export S3_REGION=ap-southeast-1
export DOCKER_S3_BUCKET=$DOCKER_REG_S3_BUCKET

#PROMETHEUS-grafana
export GOCD_DNS=gocd.bics.ti-ra.net
export GRAFANA_DNS=dev.grafana.bics.ti-ra.net

#SONAR SETUP
#export POSTGRE_SERVER=.....
#export POSTGRE_PWD=$
#export SONAR_DNS=sonar.amarispartner.com
export POSTGRE_USER=sonar
export POSTGRE_DB=sonardb