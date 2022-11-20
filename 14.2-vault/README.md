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

[Manifests](assets/task1/)

```bash
kubectl create namespace vault
kubectl apply -f task1
```

```console
% kubectl -n vault logs fedora -f

. . .

{'request_id': '59aad786-7838-ba5e-bd3b-341455390f34', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-11-17T20:44:11.481530006Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
{'request_id': 'a34160ff-a418-57b4-9e3f-b0ebe35c5180', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-11-17T20:44:11.481530006Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}
```

---

## Задача 2 (*): Работа с секретами внутри модуля

* На основе образа fedora создать модуль;
* Создать секрет, в котором будет указан токен;
* Подключить секрет к модулю;
* Запустить модуль и проверить доступность сервиса Vault.

**Answer**

- [Dockerfile](assets/task2/Dockerfile)

- [secret manifest](assets/task2/vault-secret.yml)

- [pod manifest](assets/task1/client-pod.yml)

```
docker build assets/task2 -t kraktorist/vault-client:1.0
docker push kraktorist/vault-client:1.0
kubectl apply -f assets/task2
```

```console
% kubectl -n vault get pods/client
NAME     READY   STATUS      RESTARTS   AGE
client   0/1     Completed   0          38s

% kubectl -n vault logs client
{'request_id': 'e9ce4545-cdcb-cdaf-4df2-7fe3b81e9d51', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-11-20T17:39:10.024322159Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
{'request_id': 'c8c76c52-5b5b-db8c-905c-0f7c8b04c918', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-11-20T17:39:10.024322159Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}

```


---
