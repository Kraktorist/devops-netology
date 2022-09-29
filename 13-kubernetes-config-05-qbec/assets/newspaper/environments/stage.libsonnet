
// this file has the param overrides for the default environment
local base = import './base.libsonnet';

base {
  components +: {
    ingress +: {
      hostname: "alpha",
      enabled: false,
      externalEndpoint: false,
    }
  }
}
