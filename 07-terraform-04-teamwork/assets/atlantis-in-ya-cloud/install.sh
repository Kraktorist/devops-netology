#!/usr/bin/env bash
IMAGE="ghcr.io/runatlantis/atlantis"
REPO_NAME="devops-netology"
SSH_USER=yc-user
rm -rf .temp declaration.yaml
TOKEN=$(yc iam create-token --no-user-output)
echo $TOKEN | sudo docker login --username iam --password-stdin cr.yandex
sudo docker pull $IMAGE
IMAGE_ID=`sudo docker images | grep $IMAGE | awk {'print $3'}`
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
EXTERNAL_IP=`terraform output -raw external_ip`
scp server.yaml $SSH_USER@$EXTERNAL_IP:/tmp/
ssh $SSH_USER@$EXTERNAL_IP << EOF 
  sudo mkdir -p /etc/atlantis/
  sudo mv /tmp/server.yaml /etc/atlantis/
  sudo docker container rm -f atlantis &>>/dev/null
  sudo docker run --name atlantis -dt -p 80:4141 -v /etc/atlantis/server.yaml:/etc/atlantis/server.yaml ghcr.io/runatlantis/atlantis \
      server \
      --atlantis-url="http://${EXTERNAL_IP}/" \
      --gh-user=$GH_USER \
      --gh-token=$GH_TOKEN \
      --gh-webhook-secret=$GH_WEBHOOK_SECRET \
      --repo-allowlist='github.com/kraktorist/devops-netology' \
      --repo-config=/etc/atlantis/server.yaml
  echo "http://${EXTERNAL_IP}/"
EOF
