#!/bin/bash

apt-get update
apt-get install curl -y

#Setting up everything needed by k3s and run the Server Node
curl -sfL https://get.k3s.io | sh -s - agent --node-name mpivet-psw --node-ip 192.168.56.111 --server https://192.168.56.110:6443 --token $(cat /vagrant/node-token)

rm /vagrant/node-token
