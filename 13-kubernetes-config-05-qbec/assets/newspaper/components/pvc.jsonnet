
local p = import '../params.libsonnet';
local params = p.components.pvc;
local env = std.extVar('qbec.io/env');

[
  {
    "apiVersion": "v1",
    "kind": "PersistentVolumeClaim",
    "metadata": {
      "name": env + "-" + params.claimNameSuffix
    },
    "spec": {
      "storageClassName": "nfs",
      "accessModes": [ "ReadWriteMany" ],
      "resources": {
        "requests": {
          "storage": params.storage
        }
      }
    }
  }
]
