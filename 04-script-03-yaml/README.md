# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис  
**Answer**

```json
    {
        "info": "Sample JSON output from our service\t",
        "elements": [
            {
                "name": "first",
                "type": "server",
                "ip": 7175
            },
            {
                "name": "second",
                "type": "proxy",
                "ip": "71.78.22.43"
            }
        ]
    }
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import argparse
import json
import os
import socket
import yaml

services = [
    'drive.google.com', 
    'mail.google.com', 
    'google.com'
]

parser = argparse.ArgumentParser(description='ping services')
parser.add_argument('--output', 
                    default='json', 
                    choices=['yaml', 'json'],
                    help='Save output as yaml or json')
parser.add_argument('--cache-file', 
                    default='.ping_cache',
                    help='Output file path')
args = parser.parse_args()

if args.output == 'yaml':
    load = yaml.safe_load
    dump = yaml.dump
else:
    load = json.load
    dump = json.dump

'''
loading cached values from file
'''
cache_file = args.cache_file
cached_data = dict()
output_data = list()
if os.path.exists(cache_file):
    with open(cache_file) as cache:
        try:
            cached_data = load(cache)
        except:
            print(f"Can't load cache as {args.output}")

'''
pinging
'''
for service in services:
    try:
        ip = socket.gethostbyname(service)
    except:
        print(f'An error happened during name resolution for service {service}')
    result = [item[service] for item in cached_data if service in item.keys()]
    previous_ip = None
    if result:
        previous_ip, = result
    if previous_ip == ip:
        print(f'{service} - {ip}')
    else:
        print(f'[ERROR] {service} IP mismatch: {previous_ip} {ip}')
    output_data.append({service: ip})

'''
saving results to cache file
'''
with open(cache_file, 'w') as cache:
    dump(output_data, cache)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ ./ping.py --output yaml
drive.google.com - 173.194.221.194
mail.google.com - 64.233.164.83
google.com - 173.194.222.100
vagrant@vagrant:~$ systemd-resolve --flush-caches
vagrant@vagrant:~$ ./ping.py --output yaml
drive.google.com - 173.194.221.194
mail.google.com - 64.233.164.83
[ERROR] google.com IP mismatch: 173.194.222.100 209.85.233.139
vagrant@vagrant:~$ ./ping.py --output json
Can't load cache as json
[ERROR] drive.google.com IP mismatch: None 173.194.221.194
[ERROR] mail.google.com IP mismatch: None 64.233.164.83
[ERROR] google.com IP mismatch: None 209.85.233.102

```

### json-файл(ы), который(е) записал ваш скрипт:
```json
[{"drive.google.com": "173.194.221.194"}, {"mail.google.com": "74.125.131.83"}, {"google.com": "209.85.233.139"}]
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
- drive.google.com: 173.194.221.194
- mail.google.com: 74.125.131.17
- google.com: 209.85.233.100
```
