#!/bin/sh

echo "==> Installing helm and configuring repository for components"
sleep 5
helm init
helm repo add stable https://kubernetes-charts.storage.googleapis.com

echo "==> Create Service account tiller..."
kubectl create serviceaccount -n kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin \
--serviceaccount=kube-system:tiller

kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'