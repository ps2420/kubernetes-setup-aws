#!/bin/sh

export PREFIX_DIR=sonar

helm install stable/sonarqube --name sonarqube --namespace sonarqube \
--set service.type=ClusterIP --set persistence.enabled=false --set postgresql.enabled=false \
--set postgresql.postgresServer=$POSTGRE_SERVER --set postgresql.postgresUser=$POSTGRE_USER  \
--set postgresql.postgresPassword=$POSTGRE_PWD  --set postgresql.postgresDatabase=$POSTGRE_DB

sleep 5

#echo "Create ingress rules"
sed -e "s/SONAR_DNS/$SONAR_DNS/g" ./$PREFIX_DIR/ingress-template.yaml | kubectl apply -f -