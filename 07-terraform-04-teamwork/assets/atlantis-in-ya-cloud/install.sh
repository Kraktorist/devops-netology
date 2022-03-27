#!/usr/bin/env bash
rm -rf .temp declaration.yaml
TOKEN=$(yc iam create-token --no-user-output)
echo $TOKEN | sudo docker login --username iam --password-stdin cr.yandex
IMAGE="ghcr.io/runatlantis/atlantis"
sudo docker pull $IMAGE
IMAGE_ID=`sudo docker images | grep $IMAGE | awk {'print $3'}`
REPO_NAME="devops-netology"
REPO_ID=`(yc container registry get ${REPO_NAME} || yc container registry create ${REPO_NAME}) | grep -E ^id: | awk {'print $2'}`
IMAGE_URI=cr.yandex/${REPO_ID}/atlantis
sudo docker tag $IMAGE_ID $IMAGE_URI
sudo docker push $IMAGE_URI
rm -rf .temp
( echo "cat <<EOF >declaration.yaml";
  cat template.yaml;
  echo "";
  echo EOF;
) >.temp
source .temp
rm -rf .temp
terraform apply 