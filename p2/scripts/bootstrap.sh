#!/bin/bash

apt-get update
apt-get install curl -y
#
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --node-name mpivet-ps --node-ip 192.168.56.110

