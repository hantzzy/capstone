# Deployed Kubenete on AWS using Kops
Udacity capstone - Jenkin was deployed on it's onw AWS instance with docker install and the kubenernete deployed with kops.
Jenkin workflow deploy the static html page into NGINX behind an ELB as a rolling deployment 

### 1- Create Ubuntu instance and attach I am role to the instance
- Needs permission to the following: EC2, S3,  VPC and Route 53

### 2- Install Kops on EC2
```
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
```
### 3- Install Kubectl
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

```
### 4- Make S3 bucket in AWS as required by kops to store cluster state
```
aws s3 mb s3://hantz.k8s --region us-east-1
```
### 5- I used my own domain to create an hosted Zone in AWS(hantzy.com)

### 6- Configure environment variables

Edit the .bashrc file using nano
```
sudo nano ~/.bashrc
```
Add the following lines, using the same bucket name in step 4 and smae hosted Zone name in step 5

```
export  KOPS_CLUSTER_NAME="hantzy.com"
export KOPS_STATE_STORE="s3://hantz.k8s"

```
or using echo

```
sudo echo "export  KOPS_CLUSTER_NAME=hantzy.com" >>~/.bashrc
sudo echo "export  KOPS_STATE_STORE=s3://hantz.k8s" >>~/.bashrc

```
### 7- Create the necessary key pair using ssh-Keygen or AWS CLI to ssh into Kubernetes cluster
ssh-Keygen
```
ssh-keygen
```
AWS CLI

```
aws ec2 create-key-pair --key-name "key-name" --query 'KeyMaterial' --output text > ~/.ssh/key-name.pem 
chmod 600 ~/.ssh/key-name.pem 
```

### 8- Deploy K8s Cluster
```

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
```
```
kops update cluster --yes
```
- Validation cluster might fail at first, it might require up to 15 min.
To connect to the api
```
ssh admin@api.hantzy.com
```
To destroy:
```
kops delete cluster  --yes
```
### Alternatively both kubectl and kops can be deployed with:
deploy_kubectl_Kops.sh script

```
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

```
This can also be deployed using cloudformation, which copy the script above at boot from an open s3 bucket and run it. 
```
Cluster_deployment.yaml
```
