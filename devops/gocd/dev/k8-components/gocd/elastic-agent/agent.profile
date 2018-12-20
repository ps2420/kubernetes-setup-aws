apiVersion: v1
kind: Pod
metadata:
  name: pod-name-prefix-{{ POD_POSTFIX }}
  labels:
    app: web
spec:
  volumes:
    - name: ssh-secrets
      secret:
        secretName: gocd-server-ssh
  containers:
    - name: gocd-agent-container-{{ CONTAINER_POSTFIX }}
      image: gocd/gocd-agent-docker-dind:v18.10.0
      securityContext:
        privileged: true
      volumeMounts:
        - name: ssh-secrets
          readOnly: true
          mountPath: /home/go/.ssh


#add this line <config-repo> just before pipelines..
<config-repo pluginId="yaml.config.plugin" id="amaris_repo">
  <git url="https://ps2420:Missn2013@github.com/AmarisAI/document-upload.git" branch="tm_automation" />
</config-repo>

#get the docker-password
curl 'https://cicd.amarispartner.com/go/api/admin/encrypt' -u 'userid:password'  -H 'Accept: application/vnd.go.cd.v1+json' -H 'Content-Type: application/json' -X POST -d '{"value": "badger"}'

#update the password like this
AES:zdZEDcX9z1x7zeld6JcryA==:lJOfLv5hXp96U6tK5Le6Dg==