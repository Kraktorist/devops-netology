#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install docker.io conntrack -y
sudo usermod -aG docker $USER && newgrp docker
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.23.2/minikube-linux-amd64 && chmod +x minikube
sudo install minikube /usr/local/bin/
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
sudo install kubectl /usr/local/bin/