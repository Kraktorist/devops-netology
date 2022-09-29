
local p = import '../params.libsonnet';
local params = p.components.frontend;
local pvc = p.components.pvc;
local ingress = p.components.ingress;
local env = std.extVar('qbec.io/env');

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      name: env + "-frontend",
      labels: {
        app: env + '-frontend'
      }
    },
    "spec": {
      "replicas": params.replicas,
      "selector": {
        "matchLabels": {
          "app": env + "-frontend"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": env + "-frontend"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "news-frontend",
              "image": params.image,
              "ports": [
                {
                  "containerPort": 9000
                }
              ],
              volumeMounts: [
                {
                  name: 'static',
                  mountPath: '/static'
                }
              ]
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
      "name": env + "-news-frontend"
    },
    "spec": {
      "selector": {
        "app": env + "-frontend"
      },
      "ports": [
        {
          "protocol": "TCP",
          "port": 80
        }
      ]
    }
  },
] + if ingress.enabled !=true then [] else
[
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": env + "-newspaper-frontend"
    },
    "spec": {
      "rules": [
        {
          host: ingress.hostname,
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: env + '-news-frontend',
                    port: {
                      number: 80
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
