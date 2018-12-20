#!/bin/sh

helm del --purge gocd
kubectl delete namespaces gocd
