#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Folder name is not defined"
  echo "Example: ./create_hw_template.sh '13-kubernetes-config-01-objects' '13-01 Kubernetes Objects'"
  exit 1
fi

mkdir $1
touch $1/README.md
mkdir $1/assets
touch $1/assets/.gitkeep

if [ -z "$2" ]; then
  echo "Topic name is not defined"
else
  # echo "- [ ${2} ](${1}/README.md)">>README.md
  sed -i "/^.*END_OF_TOC.*/i - [ ${2} ](${1}/README.md)\n" README.md
fi