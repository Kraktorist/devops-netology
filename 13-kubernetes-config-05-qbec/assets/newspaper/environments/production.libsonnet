
// this file has the param overrides for the default environment
local base = import './base.libsonnet';

base {
  components +: {
    ingress +: {
      hostname: "beta",
      enabled: true,
      externalEndpoint: true,
    },
    backend +: {
      replicas: 3
    },
    frontend +: {
      replicas: 3
    }
  }
}
