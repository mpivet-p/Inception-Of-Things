#!/bin/bash

apt-get update
apt-get install curl -y
#
curl -sfL https://get.k3s.io | sh -s - --docker --disable traefik --write-kubeconfig-mode 644 --node-name mpivet-ps --node-ip 192.168.56.110

docker build -t mpivet-p/flask_app /vagrant/flask_app/
#docker save mpivet-p/flask_app | k3s ctr images import -
