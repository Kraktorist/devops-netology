#!/usr/bin/env bash

minikube addons enable ingress
minikube addons enable dashboard
kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
kubectl expose deployment hello-node --type=LoadBalancer --port=8080
kubectl wait deployment hello-node --for condition=Available=True --timeout=90s