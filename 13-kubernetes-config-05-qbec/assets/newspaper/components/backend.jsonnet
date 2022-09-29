
local p = import '../params.libsonnet';
local params = p.components.backend;
local postgres = p.components.postgres;
local pvc = p.components.pvc;
local ingress = p.components.ingress;
local env = std.extVar('qbec.io/env');

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      name: env + "-backend",
      labels: {
        app: env + '-backend'
      }
    },
    "spec": {
      "replicas": params.replicas,
      "selector": {
        "matchLabels": {
          "app": env + "-backend"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": env + "-backend"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "news-backend",
              "image": params.image,
              "ports": [
                {
                  "containerPort": 9000
                }
              ],
              "env": [
                {
                  "name": "POSTGRES_PASSWORD",
                  "valueFrom": {
                    "secretKeyRef": {
                      "name": env + "-secrets",
                      "key": "dbpassword"
                    }
                  }
                },
                {
                  "name": "DATABASE_URL",
                  "value": 'postgres://' + postgres.dbuser + ':$(POSTGRES_PASSWORD)@' + env + '-postgres:' + postgres.port + '/' + postgres.dbname
                },
              ],
              volumeMounts: [
                {
                  name: 'static',
                  mountPath: '/static'
                },
              ],
              "readinessProbe": {
                initialDelaySeconds: 10,
                periodSeconds: 5,
                exec: {
                  command: [
                    "/bin/sh",
                    "-c",
                    'echo \\>/dev/tcp/'+ env + '-postgres/' + postgres.port
                  ]
                }
              }
            }
          ],
          volumes: [
            {
              name: "static",
              persistentVolumeClaim: {
                claimName: env + '-' + pvc.claimNameSuffix
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
      "name": env + "-news-backend"
    },
    "spec": {
      "selector": {
        "app": env + "-backend"
      },
      "ports": [
        {
          "protocol": "TCP",
          "port": 9000
        }
      ]
    }
  },
] + if ingress.enabled != true then [] else
[
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": env + "-newspaper-backend"
    },
    "spec": {
      "rules": [
        {
          host: ingress.hostname,
          http: {
            paths: [
              {
                path: '/api',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: env + '-news-backend',
                    port: {
                      number: 9000
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  },
]