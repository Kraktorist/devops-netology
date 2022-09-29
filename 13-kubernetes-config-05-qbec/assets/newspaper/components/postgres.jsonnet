
local p = import '../params.libsonnet';
local params = p.components.postgres;
local env = std.extVar('qbec.io/env');

[
  {
    "apiVersion": "apps/v1",
    "kind": "StatefulSet",
    "metadata": {
      "name": env+"-postgres"
    },
    "spec": {
      "serviceName": "postgres",
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": env+"-postgres"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": env+"-postgres"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "postgres",
              "image": params.image,
              "ports": [
                {
                  "containerPort": params.port
                }
              ],
              "env": [
                {
                  "name": "POSTGRES_PASSWORD",
                  "valueFrom": {
                    "secretKeyRef": {
                      "name": env+"-secrets",
                      "key": "dbpassword"
                    }
                  }
                },
                {
                  "name": "POSTGRES_USER",
                  "value": params.dbuser
                },
                {
                  "name": "POSTGRES_DB",
                  "value": params.dbname
                }
              ],
              "readinessProbe": {
                "exec": {
                  "command": [
                    "/bin/sh",
                    "-c",
                    "exec pg_isready -U ${POSTGRES_USER} -h 127.0.0.1 -p " + params.port
                  ]
                }
              }
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": env+"-postgres"
    },
    "spec": {
      "selector": {
        "app": env+"-postgres"
      },
      "ports": [
        {
          "protocol": "TCP",
          "port": params.port
        }
      ]
    }
  },
]
