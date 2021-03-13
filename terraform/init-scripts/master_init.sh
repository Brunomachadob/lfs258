#!/bin/bash

echo "Starting master init script"
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

local_ip=$(hostname -i)
content=$(cat /etc/hosts)
echo -en "$local_ip k8smaster\n$content" > /etc/hosts

cat > ./kubeadm-config.yaml<< EOF
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: 1.19.1
controlPlaneEndpoint: "k8smaster:6443"
networking:
  podSubnet: 192.168.0.0/16
EOF

kubeadm init --config=kubeadm-config.yaml --upload-certs | tee /var/log/kubeadm-init.out

wget https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f calico.yaml

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown $(id -u):$(id -g) "$HOME"/.kube/config

kubectl get nodes

sudo apt-get install bash-completion -y
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> $HOME/.bashrc
