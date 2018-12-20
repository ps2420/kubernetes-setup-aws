#!/bin/sh

#Install prometheus and grafana
helm del --purge prometheus
helm del --purge grafana

#delete workspace
kubectl delete namespaces prometheus
