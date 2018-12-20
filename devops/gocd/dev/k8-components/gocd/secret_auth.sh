#!/bin/sh

helm install stable/gocd --name gocd --namespace gocd --set server.service.type=ClusterIP
--set server.service.type=ClusterIP \
--set server.resources.requests.memory=1024Mi --set server.resources.limits.memory=1024Mi \
--set agent.resources.limits.memory=1024Mi --set agent.resources.requests.memory=1024Mi

#Create secret keys
kubectl create secret generic git-ssh-key --from-file=id_rsa=./gocd/ssh-key/id_rsa --namespace gocd

#Create secret key gocd-agent-ssh
kubectl create secret generic gocd-agent-ssh --from-file=id_rsa=./gocd/ssh-key/id_rsa \
--from-file=known_hosts=./gocd/ssh-key/known_hosts --namespace=gocd

#Create secret key gocd-server-ssh
kubectl create secret generic gocd-server-ssh --from-file=id_rsa=./gocd/ssh-key/id_rsa \
--from-file=known_hosts=./gocd/ssh-key/known_hosts --namespace=gocd

#Create secret key with docker environment
kubectl create secret docker-registry docker-reg-cred --docker-server=$DOCKER_REGISTRY_HOST \
    --docker-username=$DOCKER_REGISTRY_USERNAME --docker-password=$DOCKER_REGISTRY_PASSWORD \
    --docker-email=$DOCKER_REG_MAIL --namespace gocd

#call helm command to upgarde and set the ssh key enabled = true
helm upgrade gocd stable/gocd --namespace gocd --set server.security.ssh.enabled=true \
--set agent.security.ssh.enabled=true

#Delete existing ingress and create new one
kubectl delete ingresses gocd-server -n gocd
sed -e "s/GOCD_DNS/$GOCD_DNS/g" gocd/ingress-template.yaml | kubectl apply -f -

echo "==> waiting for 20 seconds to let container initialize"
sleep 15

#https://confluence.ti-ra.net/display/BIC/GoCD+Authentication+Setup gocd authentication setup
kubectl cp ./gocd/passwd gocd/$GO_SERVER_POD:/home/go/authentication -n gocd

GO_SERVER_POD=`kubectl get -o name pods -n gocd --selector app=gocd,component=server | sed -e 's:pod/::'`
echo "==> GO_SERVER_POD: $GO_SERVER_POD"
kubectl exec $GO_SERVER_POD mkdir /home/go/.ssh -n gocd

kubectl cp ./gocd/ssh-key/id_rsa gocd/$GO_SERVER_POD:/home/go/.ssh -n gocd
kubectl cp ./gocd/ssh-key/known_hosts gocd/$GO_SERVER_POD:/home/go/.ssh -n gocd

kubectl exec $GO_SERVER_POD -n gocd -- bash -c "chown -R go /home/go/.ssh"
