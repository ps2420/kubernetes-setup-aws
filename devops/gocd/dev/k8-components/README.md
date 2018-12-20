## Introduction
Shell scripts in place to create to create kubernetes components on cluster

***
## Prerequisites
Run terraform sripts tf/k8s to have the public private subnet infra created before in hand.

***
## Get Started
1. Create DNS Name on aws route 53
2. Create ssl certificate on AWS ACM. (Required for load balancer)
3. Export AWS variables to setup grafana, gocd, docker-registry, aws certificates

```
export DNS_NAME=
export AWS_ARN_CERT=
export DOCKER_REGISTRY_PASSWORD=
export GRAFANA_PASSWORD=
export GOCD_PASSWORD=

export S3_ACCESS_KEY=
export S3_SECRET_KEY= 
```

***
## Scripts
./scripts/comp-install.sh

***
## Post-installation steps

#### Post installation password encryption for gocd yaml yaml file
```
1. Run command to generate docker_registry_password
curl 'https://<dns-name>/go/api/admin/encrypt' -u '<userid>:<password>'  -H 'Accept: application/vnd.go.cd.v1+json' -H 'Content-Type: application/json' -X POST -d '{"value": "badger"}' -k

update the respective passwords in ci.gocd.yaml file in repo
```

#### GO-CD Authentication Setup from UI (authentication & material setup)
```
1. Admin --> Security --> Authorization configuration (provide path to /home/go/authentication) as per setup.sh

2. Admin --> config-xml add below lines just above pipelines: (takes time to reflect on console)
 
 <config-repos>
    <config-repo pluginId="yaml.config.plugin" id="amaris_repo">
      <git url="ssh://git@bitbucket.ti-ra.net:7999/bics/bics.git" branch="development" />
    </config-repo>
  </config-repos>

```

#### elastic agent setup for bics
```
1. Admin --> elastic-agent-profiles (add elastic agent with name docker-agent and choose yaml configuration)
2. Enter Following configurations from the screen

apiVersion: v1
kind: Pod
metadata:
  name: k8s-{{ POD_POSTFIX }}
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
```

#### Post installation sonar setup
```
1. Acees components by DNS name by using userid/password
2. Login to sonar instance with admin/admin and change the password or create different account
```

#### Post installation prometheus setup
```
1. Login to Grafana dashboard (Get the password from: https://confluence.ti-ra.net/pages/viewpage.action?pageId=5181212)
2. Import the dashboard from components/prometheus/dashboards/system_and_docker_monitoring.json from console
3. More dashboards are available on grafana website..
```