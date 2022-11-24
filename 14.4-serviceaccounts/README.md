# Домашнее задание к занятию "14.4 Сервис-аккаунты"

<details>
<summary>Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube</summary>

## Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать сервис-аккаунт?

```
kubectl create serviceaccount netology
```

### Как просмотреть список сервис-акаунтов?

```
kubectl get serviceaccounts
kubectl get serviceaccount
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
```

### Как выгрузить сервис-акаунты и сохранить его в файл?

```
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
```

### Как удалить сервис-акаунт?

```
kubectl delete serviceaccount netology
```

### Как загрузить сервис-акаунт из файла?

```
kubectl apply -f netology.yml
```

</details>

## Задача 2 (*): Работа с сервис-акаунтами внутри модуля

Выбрать любимый образ контейнера, подключить сервис-акаунты и проверить
доступность API Kubernetes

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```

Просмотреть переменные среды

```
env | grep KUBE
```

Получить значения переменных

```
K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
SADIR=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat $SADIR/token)
CACERT=$SADIR/ca.crt
NAMESPACE=$(cat $SADIR/namespace)
```

Подключаемся к API

```
curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
```

В случае с minikube может быть другой адрес и порт, который можно взять здесь

```
cat ~/.kube/config
```

или здесь

```
kubectl cluster-info
```

**Answer**

[pod specification](assets/pod.yml)

```console
vagrant@vagrant:~/$ kubectl apply -f pod.yml 
pod/fedora created
vagrant@vagrant:~/$ kubectl logs fedora
{
  "major": "1",
  "minor": "24",
  "gitVersion": "v1.24.2",
  "gitCommit": "f66044f4361b9f1f96f0053dd46cb7dce5e990a8",
  "gitTreeState": "clean",
  "buildDate": "2022-06-15T14:15:38Z",
  "goVersion": "go1.18.3",
  "compiler": "gc",
  "platform": "linux/amd64"
}{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "pods is forbidden: User \"system:serviceaccount:default:default\" cannot list resource \"pods\" in API group \"\" at the cluster scope",
  "reason": "Forbidden",
  "details": {
    "kind": "pods"
  },
  "code": 403
}
```
