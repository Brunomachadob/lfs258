#!/bin/bash

echo "Starting worker init script"
whoami

sudo -i
apt-get update && apt-get upgrade -y
apt-get install -y docker.io

systemctl enable docker.service

echo "deb  http://apt.kubernetes.io/  kubernetes-xenial  main" > /etc/apt/sources.list.d/kubernetes.list

curl -s \
  https://packages.cloud.google.com/apt/doc/apt-key.gpg \
  | apt-key add -

apt-get update

apt-get install -y \
  kubeadm=1.19.1-00 kubelet=1.19.1-00 kubectl=1.19.1-00

apt-mark hold kubelet kubeadm kubectl

master_ip=$(nslookup -type=a lfclass-master | awk 'NR==6' | awk -F: '{print $2}' | xargs)
content=$(cat /etc/hosts)
echo -en "$master_ip k8smaster\n$content" > /etc/hosts
