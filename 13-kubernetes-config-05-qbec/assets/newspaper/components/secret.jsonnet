local env = std.extVar('qbec.io/env');

[
  {
    apiVersion: 'v1',
    kind: 'Secret',
    metadata: {
      name: env+'-secrets',
    },
    type: 'Opaque',
    data: {
      //'dbpassword': std.base64('Why there is no random() function in qbec???')
      'dbpassword': std.base64(std.rstripChars(importstr "/proc/sys/kernel/random/uuid", "\n"))
    },
  },
]
