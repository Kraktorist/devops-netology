#!/usr/bin/env bash
set -eo pipefail

# gateway='localhost'
# S3_BUCKET=${Storage_Bucket:-data}
gateway='gateway:8080'
echo -n "Token: "
token=$(curl -s -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://${gateway}/v1/token)
echo $token
echo -n "User status: "
curl -s -X GET -H 'Content-Type: application/json' -H 'Authorization: Bearer ${token}' http://${gateway}/v1/user
cd /tmp
echo "Uploading picture"
curl -sLo picture.jpg https://github.com/girliemac/a-picture-is-worth-a-1000-words/raw/main/git-purr/git-purr.jpg
sha1sum picture.jpg>picture.jpg.sha1
filename=$(curl -s -X POST -H 'Authorization: Bearer ${token}' -H 'Content-Type: octet/stream' --data-binary @picture.jpg http://${gateway}/v1/upload | grep -oE '[A-Za-z0-9-]{36}\.[A-Za-z0-9]{1,4}')
rm -rf picture.jpg
echo "Picture path: ${filename}"
echo "Downloading and checking picture: "
curl -sLo picture.jpg -H 'Authorization: Bearer ${token}' http://${gateway}/v1/images/${filename}
sha1sum -c picture.jpg.sha1
