#!/bin/bash

#Create k3d clutser
k3d cluster create

#Create namespaces:
kubectl create ns argocd
kubectl create ns dev

#Setting up Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#Make argocd accessible
kubectl port-forward svc/argocd-server -n argocd 8080:443

#Install argocd CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

#get current password
PASSWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

#login with argocd
argocd --insecure login localhost:8080 --username admin --password $PASSWD
#argocd login cd.argoproj.io --core

#Change admin password
argocd account update-password --account admin --current-password $PASSWD --new-password "admin123"

#Create Argo CD App
argocd app create wil-playground \
	--repo https://github.com/mpivet-p/argocd_mpivet-p \
	--path manifests \
	--dest-server https://kubernetes.default.svc \
	--dest-namespace dev
