#!/usr/bin/env bash

url=$(minikube service hello-node | grep -oE "http://[0-9.:]{1,}$")
curl -s $url