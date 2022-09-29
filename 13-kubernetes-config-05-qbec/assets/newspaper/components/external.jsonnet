
local p = import '../params.libsonnet';
local ingress = p.components.ingress;
local env = std.extVar('qbec.io/env');

if ingress.externalEndpoint !=true then [] else
[
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": env + "-ext"
    },
    "spec": {
      "type": "ClusterIP",
      "clusterIP": "None",
      "ports": [
        {
          "name": "app",
          "protocol": "TCP",
          "port": 8080,
          "targetPort": 80
        }
      ]
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Endpoints",
    "metadata": {
      "name": env + "-ext"
    },
    "subsets": [
      {
        "addresses": [
          {
            "ip": "92.53.113.218"
          }
        ],
        "ports": [
          {
            "name": "app",
            "port": 80,
            "protocol": "TCP"
          }
        ]
      }
    ]    
  },
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": env + "-ext"
    },
    "spec": {
      "rules": [
        {
          host: ingress.hostname,
          http: {
            paths: [
              {
                path: '/ext',
                pathType: 'Exact',
                backend: {
                  service: {
                    name: env + '-ext',
                    port: {
                      number: 8080
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
