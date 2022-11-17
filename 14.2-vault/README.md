# Домашнее задание к занятию "14.2 Синхронизация секретов с внешними сервисами. Vault"

## Задача 1: Работа с модулем Vault

Запустить модуль Vault конфигураций через утилиту kubectl в установленном minikube

```
kubectl apply -f 14.2/vault-pod.yml
```

Получить значение внутреннего IP пода

```
kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
```

Примечание: jq - утилита для работы с JSON в командной строке

Запустить второй модуль для использования в качестве клиента

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```

Установить дополнительные пакеты

```
dnf -y install pip
pip install hvac
```

Запустить интепретатор Python и выполнить следующий код, предварительно
поменяв IP и токен

```
import hvac
client = hvac.Client(
    url='http://10.10.133.71:8200',
    token='aiphohTaa0eeHei'
)
client.is_authenticated()

# Пишем секрет
client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)

# Читаем секрет
client.secrets.kv.v2.read_secret_version(
    path='hvac',
)
```

**Answer**

```bash
kubectl create namespace vault
kubectl apply -f task1
```

```console
% kubectl -n vault logs fedora -f
Fedora 37 - x86_64                              5.6 MB/s |  64 MB     00:11    
Fedora 37 openh264 (From Cisco) - x86_64        786  B/s | 2.5 kB     00:03    
Fedora Modular 37 - x86_64                      2.8 MB/s | 3.0 MB     00:01    
Fedora 37 - x86_64 - Updates                    5.2 MB/s |  14 MB     00:02    
Fedora Modular 37 - x86_64 - Updates            4.3 MB/s | 3.7 MB     00:00    
Last metadata expiration check: 0:00:01 ago on Thu Nov 17 20:43:54 2022.
Dependencies resolved.
================================================================================
 Package                  Architecture Version               Repository    Size
================================================================================
Installing:
 python3-pip              noarch       22.2.2-2.fc37         fedora       3.1 M
Installing weak dependencies:
 libxcrypt-compat         x86_64       4.4.28-3.fc37         fedora        89 k
 python3-setuptools       noarch       62.6.0-2.fc37         fedora       1.6 M

Transaction Summary
================================================================================
Install  3 Packages

Total download size: 4.8 M
Installed size: 23 M
Downloading Packages:
(1/3): libxcrypt-compat-4.4.28-3.fc37.x86_64.rp 2.8 MB/s |  89 kB     00:00    
(2/3): python3-setuptools-62.6.0-2.fc37.noarch. 3.6 MB/s | 1.6 MB     00:00    
(3/3): python3-pip-22.2.2-2.fc37.noarch.rpm     6.0 MB/s | 3.1 MB     00:00    
--------------------------------------------------------------------------------
Total                                           6.4 MB/s | 4.8 MB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1 
  Installing       : python3-setuptools-62.6.0-2.fc37.noarch                1/3 
  Installing       : libxcrypt-compat-4.4.28-3.fc37.x86_64                  2/3 
  Installing       : python3-pip-22.2.2-2.fc37.noarch                       3/3 
  Running scriptlet: python3-pip-22.2.2-2.fc37.noarch                       3/3 
  Verifying        : libxcrypt-compat-4.4.28-3.fc37.x86_64                  1/3 
  Verifying        : python3-pip-22.2.2-2.fc37.noarch                       2/3 
  Verifying        : python3-setuptools-62.6.0-2.fc37.noarch                3/3 

Installed:
  libxcrypt-compat-4.4.28-3.fc37.x86_64      python3-pip-22.2.2-2.fc37.noarch   
  python3-setuptools-62.6.0-2.fc37.noarch   

Complete!
Collecting hvac
  Downloading hvac-1.0.2-py3-none-any.whl (143 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 143.5/143.5 kB 995.3 kB/s eta 0:00:00
Collecting pyhcl<0.5.0,>=0.4.4
  Downloading pyhcl-0.4.4.tar.gz (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.1/61.1 kB 1.5 MB/s eta 0:00:00
  Installing build dependencies: started
  Installing build dependencies: finished with status 'done'
  Getting requirements to build wheel: started
  Getting requirements to build wheel: finished with status 'done'
  Preparing metadata (pyproject.toml): started
  Preparing metadata (pyproject.toml): finished with status 'done'
Collecting requests<3.0.0,>=2.27.1
  Downloading requests-2.28.1-py3-none-any.whl (62 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.8/62.8 kB 1.3 MB/s eta 0:00:00
Collecting charset-normalizer<3,>=2
  Downloading charset_normalizer-2.1.1-py3-none-any.whl (39 kB)
Collecting idna<4,>=2.5
  Downloading idna-3.4-py3-none-any.whl (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.5/61.5 kB 1.3 MB/s eta 0:00:00
Collecting urllib3<1.27,>=1.21.1
  Downloading urllib3-1.26.12-py2.py3-none-any.whl (140 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 140.4/140.4 kB 1.3 MB/s eta 0:00:00
Collecting certifi>=2017.4.17
  Downloading certifi-2022.9.24-py3-none-any.whl (161 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 161.1/161.1 kB 1.1 MB/s eta 0:00:00
Building wheels for collected packages: pyhcl
  Building wheel for pyhcl (pyproject.toml): started
  Building wheel for pyhcl (pyproject.toml): finished with status 'done'
  Created wheel for pyhcl: filename=pyhcl-0.4.4-py3-none-any.whl size=50127 sha256=5b4af84865e3ab1785814b555b5522835deaeeb961edaa43d8e6bcec38735f11
  Stored in directory: /root/.cache/pip/wheels/e4/f4/3a/691e55b36281820a2e2676ffd693a7f7a068fab60d89353d74
Successfully built pyhcl
Installing collected packages: pyhcl, urllib3, idna, charset-normalizer, certifi, requests, hvac
Successfully installed certifi-2022.9.24 charset-normalizer-2.1.1 hvac-1.0.2 idna-3.4 pyhcl-0.4.4 requests-2.28.1 urllib3-1.26.12
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
{'request_id': '59aad786-7838-ba5e-bd3b-341455390f34', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-11-17T20:44:11.481530006Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
{'request_id': 'a34160ff-a418-57b4-9e3f-b0ebe35c5180', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-11-17T20:44:11.481530006Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}
```

## Задача 2 (*): Работа с секретами внутри модуля

* На основе образа fedora создать модуль;
* Создать секрет, в котором будет указан токен;
* Подключить секрет к модулю;
* Запустить модуль и проверить доступность сервиса Vault.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---