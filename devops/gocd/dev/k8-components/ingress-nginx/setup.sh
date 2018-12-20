#!/bin/sh

export PREFIX_DIR=ingress-nginx

#http setup, https://github.com/kubernetes/kops/tree/master/addons/ingress-nginx
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/ingress-nginx/v1.6.0.yaml

kubectl apply -f ./$PREFIX_DIR/controller.yaml

sleep 5

sed -e "s|AWS_ARN_CERT|$AWS_ARN_CERT|g" ./$PREFIX_DIR/service.yaml | kubectl apply -f -

sleep 10

kubectl get svc -n ingress-nginx -o wide