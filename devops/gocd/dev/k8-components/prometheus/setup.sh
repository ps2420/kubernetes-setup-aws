#!/bin/sh

export PREFIX_DIR=prometheus

#install prometheus
helm install stable/prometheus --version 6.7.4 --name prometheus --namespace prometheus \
--set alertmanager.persistentVolume.size=50Gi \
--set server.persistentVolume.size=50Gi --set adminPassword=$GRAFANA_PASSWORD

sleep 5
#Install grafana
helm install --set adminPassword=temasek123 --name grafana stable/grafana --namespace prometheus -f ./$PREFIX_DIR/values.yaml

#echo "Create ingress rules"
sed -e "s/GRAFANA_DNS/$GRAFANA_DNS/g" ./$PREFIX_DIR/ingress-template.yaml | kubectl apply -f -

sleep 10
export PASSWORD=`kubectl get secret --namespace prometheus grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`
echo "Grafana-password: $PASSWORD"