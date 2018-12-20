#!/bin/sh

helm del --purge sonarqube
kubectl delete namespaces sonarqube
