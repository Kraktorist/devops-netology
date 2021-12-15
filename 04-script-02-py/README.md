# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | TypeError exception  |
| Как получить для переменной `c` значение 12?  | `str(a)+b`  |
| Как получить для переменной `c` значение 3?  | `a+int(b)`  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

'''
#!/bin/bash
"cd ~/netology/sysadm-homeworks"
curdir=`pwd`
git status -s | cut -c4- | xargs -L1 -I {} echo $curdir/{}
'''

bash_command = ["cd ~/netology/sysadm-homeworks", "pwd", "git status -s"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
base_dir = result_os.split('\n')[0]
for result in result_os.split('\n')[1:]:
    output = result.split(' ')
    if len(output) > 1:
        subpath = output[-1]
        status = output[-2]
        print(f'{status} {base_dir}/{subpath}')
        # or
        # print(f'{base_dir}/{subpath}')
```

### Вывод скрипта при запуске при тестировании:
```
M /home/vagrant/netology/03-sysadmin-01-terminal/Vagrantfile
AM /home/vagrant/netology/04-script-02-py/README.md
?? /home/vagrant/netology/.vagrant/
?? /home/vagrant/netology/03-sysadmin-01-terminal/.vagrant/
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import argparse
import os

parser = argparse.ArgumentParser(description='git status')
parser.add_argument('--repo', default=os.getcwd(), help='repo path')
args = parser.parse_args()

bash_command = [f"cd {args.repo}", "pwd", "git status -s"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
base_dir = result_os.split('\n')[0]
for result in result_os.split('\n')[1:]:
    output = result.split(' ')
    if len(output) > 1:
        subpath = output[-1]
        status = output[-2]
        print(f'{status} {base_dir}/{subpath}')
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ ./git.py --repo /home/vagrant/netology
M /home/vagrant/netology/04-script-02-py/README.md
vagrant@vagrant:~$ ./git.py --repo /home/vagrant/not_exist
/bin/sh: 1: cd: can't cd to /home/vagrant/not_exist
vagrant@vagrant:~$ ./git.py --repo /home/vagrant/
fatal: not a git repository (or any of the parent directories): .git
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import json
import os
import socket

services = [
    'drive.google.com', 
    'mail.google.com', 
    'google.com'
]

'''
loading cached values from file
'''
cache_file = '.ping_cache'
cached_data = dict()
if os.path.exists(cache_file):
    with open(cache_file) as cache:
        try:
            cached_data = json.load(cache)
        except:
            print("Can't load cache as json")


'''
pinging
'''
for service in services:
    try:
        ip = socket.gethostbyname(service)
    except:
        print(f'An error happened during name resolution for service {service}')
    if cached_data.get(service) in (None, ip):
        print(f'{service} - {ip}')
    else:
        print(f'[ERROR] {service} IP mismatch: {cached_data.get(service)} {ip}')
    cached_data[service] = ip


'''
saving results to cache file
'''
with open(cache_file, 'w') as cache:
    json.dump(cached_data, cache)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ rm -rf .ping_cache 
vagrant@vagrant:~$ ./ping.py 
drive.google.com - 142.251.1.194
mail.google.com - 209.85.233.19
google.com - 209.85.233.100
vagrant@vagrant:~$ ./ping.py 
drive.google.com - 142.251.1.194
mail.google.com - 209.85.233.19
[ERROR] google.com IP mismatch: 209.85.233.100 209.85.233.138
vagrant@vagrant:~$ ./ping.py 
drive.google.com - 142.251.1.194
mail.google.com - 209.85.233.19
google.com - 209.85.233.138
vagrant@vagrant:~$ ^C
vagrant@vagrant:~$ ./ping.py 
drive.google.com - 142.251.1.194
[ERROR] mail.google.com IP mismatch: 209.85.233.19 74.125.131.19
google.com - 209.85.233.138
```
