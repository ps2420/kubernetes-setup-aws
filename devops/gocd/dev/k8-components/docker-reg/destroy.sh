#!/bin/sh

helm del --purge docker-registry
kubectl delete namespaces docker-registry
