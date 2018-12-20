#!/bin/sh

 
echo "==> Remove components from kubernetes: ingress-nginx, prometheus, gocd, docker-registry"
echo "==> IGNORE ANY ERROR PRINTED ON CONSOLE, if namespace or any issue was reported"
echo " "

sleep 10
 
./ingress-nginx/destroy.sh 
./prometheus/destroy.sh
./gocd/destroy.sh 
./docker-reg/destroy.sh

echo "==> Waiting for components to be removed.. expected time 2 mins.. " 

sleep 120
echo "     "
echo "****************************************************************************************"
echo "==> Installing kubernetes component "

./ingress-nginx/setup.sh 
./prometheus/setup.sh
./gocd/setup.sh
./docker-reg/setup.sh

echo "==> All components has been setup successfully.."