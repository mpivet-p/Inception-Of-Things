#!/bin/bash

apt-get update
apt-get install \
	openssh-server \
	git \
	curl \
    ca-certificates \
    gnupg \
    lsb-release -y

#Setup docker repo:
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Install docker packages
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod 755 kubectl
mv kubectl /usr/local/bin/

#Install k3d
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

#Create k3d clutser with port forwarding
k3d cluster create -p "8080:443@loadbalancer" -p "8888:8888@loadbalancer"

#Create namespaces:
kubectl create ns argocd
kubectl create ns dev

#Setting up Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#Enable loadbalance for argocd-server service
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

#Waiting for argocd-server
echo -e "\033[1;1mWaiting for deployments/argocd-server status==Ready...\033[0m"
kubectl wait deployment argocd-server -n argocd --for=condition=Available=True --timeout=600s

#Install argocd CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

#get current password
PASSWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

#Write password in file
touch argo_pass.txt
chmod 0600 argo_pass.txt
echo $PASSWD > /root/argo_pass.txt

#Create the app in argocd
kubectl apply -f ../confs/app.yaml -n argocd

##login with argocd
#argocd --insecure login localhost:8080 --username admin --password $PASSWD
#argocd login cd.argoproj.io --core

##Change admin password
#argocd account update-password --account admin --current-password $PASSWD --new-password "admin123"

##Create Argo CD App
#argocd app create wil-playground \
#	--repo https://github.com/mpivet-p/argocd_mpivet-p \
#	--path manifests \
#	--dest-server https://kubernetes.default.svc \
#	--dest-namespace dew222222222222222222222
