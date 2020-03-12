#!/bin/bash
sudo apt-get update && sudo apt-get install -y apt-transport-https

echo "install Kubectl"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl


echo "install Kops"
sudo apt install snapd
sudo snap install kops

echo "adding the exports"
sudo echo "export  KOPS_CLUSTER_NAME=hantzy.com" >>~/.bashrc
sudo echo "export  KOPS_STATE_STORE=s3://hantz.k8s" >>~/.bashrc

echo "export"

source ~/.bashrc

echo "create keygen without prompt"
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa 2>/dev/null <<< y >/dev/null

echo "create cluster"
kops create cluster \
--state={KOPS_STATE_STORE} \
--node-count=1 \
--master-size=t2.micro \
--kubernetes-version=v1.17.3 \
--node-size=t2.micro \
--zones=us-east-1a,us-east-1b \
--name=${KOPS_CLUSTER_NAME} \
--dns public \
--master-count 1

echo "update cluster"
kops update cluster --yes
