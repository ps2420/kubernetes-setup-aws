#!/bin/sh

#install homeview
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#install kubernetes-cli

brew update && brew doctor

brew install awscli

brew install kubernetes-cli

kubectl version

brew install kubernetes-helm

brew install kops

brew install terraform
#brew update
#brew upgrade