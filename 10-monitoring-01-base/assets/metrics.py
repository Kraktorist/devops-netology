from datetime import datetime
import json

log={}

sources = ["loadavg", "swaps", "uptime", "meminfo"]

log["timestamp"] = int(datetime.utcnow().timestamp())

for source in sources:
    with open(f"/proc/{source}", "r") as f:
      log[source] = f.read()

print(json.dumps(log))
