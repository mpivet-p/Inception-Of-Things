#!/bin/bash

#Create k3d clutser
k3d cluster create

#Create namespaces:
kubectl create ns argocd
kubectl create ns dev

#Setting up Argo CD
kubectl apply -n argocd -f https://github.com/argoproj/argo-workflows/releases/download/v3.4.5/install.yaml
