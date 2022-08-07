#!/usr/bin/env bash
set -eo pipefail

# gateway='localhost'
# S3_BUCKET=${Storage_Bucket:-data}
echo "## Checking main scenario"
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
url="http://${gateway}/v1/images/${filename}"
echo "Uploaded picture: ${url}"
echo "Downloading picture: "
curl -sLo picture.jpg -H 'Authorization: Bearer ${token}' $url
echo -n "Checksum validation: "
sha1sum -c picture.jpg.sha1
echo ''
echo -n "## Checking invalid credentials: "
curl -w "HTTP Code: %{http_code}\n" -s -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"wrong password"}' http://${gateway}/v1/token
echo ''
echo -n "## Checking invalid file format: "
curl -w "HTTP Code: %{http_code}\n"  -s -X POST -H 'Authorization: Bearer ${token}' -H 'Content-Type: octet/stream' --data-binary @/bin/bash http://${gateway}/v1/upload
echo ''
echo -n "## Checking upload without authentication: "
curl -w "HTTP Code: %{http_code}\n"  -s -X POST -H 'Content-Type: octet/stream' --data-binary @/bin/bash http://${gateway}/v1/upload
echo ''
echo "## Checking Downloading withouth authentication: "
curl -w "HTTP Code: %{http_code}\n" -sLo picture.jpg $url
