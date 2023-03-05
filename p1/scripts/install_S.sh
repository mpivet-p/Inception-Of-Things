#!/bin/bash

apt-get update
apt-get install curl -y

#Setting up everything needed by k3s and run the Server Node
curl -sfL https://get.k3s.io | sh -s - --disable traefik --write-kubeconfig-mode 644 --node-name mpivet-ps --node-ip 192.168.56.110


#Copy node-token for latter use by the Server Worker Node.
cp /var/lib/rancher/k3s/server/node-token /vagrant/
