#! /usr/bin/env bash

echo "Starting containers: "
docker run --name ubuntu -dt --rm python sh -c "sleep 3600" &
docker run --name fedora -dt --rm fedora sh -c "sleep 3600" &
docker run --name centos7 -dt --rm centos:7 sh -c "sleep 3600" &
wait

ansible-playbook site.yml -i inventory/prod.yml --ask-vault-password

echo "Removed containers: "
for value in centos7 ubuntu fedora
do
    docker container stop ${value} &
done
wait