#!/bin/bash

NEWLINE=$'\n'

sudo snap start amazon-ssm-agent

## Installing docker
sudo apt-get update
sudo apt-get install -y --no-install-recommends\
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce=18.06.1~ce~3-0~ubuntu -y --no-install-recommends
echo "Docker Installed: $NEWLINE$(sudo docker version | grep Version)"


## Installing nvidia-docker
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install nvidia-docker2 -y --no-install-recommends
sudo pkill -SIGHUP dockerd
echo "Installed: $NEWLINE$(sudo nvidia-docker version | grep Docker)"

## Installing docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "Installed: $NEWLINE$(docker-compose version | grep version)"


## Installing python

#sudo apt-get update
#sudo add-apt-repository -y ppa:jonathonf/python-3.6
#sudo apt update
#sudo apt install -y --no-install-recommends python3.6 python3.6-dev python3.6-venv python3-distutils
#wget https://bootstrap.pypa.io/get-pip.py
#which python3
#sudo python3.6 get-pip.py
#sudo rm /usr/local/bin/python3
#sudo rm /usr/local/bin/pip3
#sudo ln -s /usr/bin/python3.6 /usr/local/bin/python3
#sudo ln -s /usr/local/bin/pip /usr/local/bin/pip3
#echo "$(python3 -V) Installed"
