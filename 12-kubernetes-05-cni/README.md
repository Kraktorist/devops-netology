# Домашнее задание к занятию "12.5 Сетевые решения CNI"
После работы с Flannel появилась необходимость обеспечить безопасность для приложения. Для этого лучше всего подойдет Calico.
## Задание 1: установить в кластер CNI плагин Calico
Для проверки других сетевых решений стоит поставить отличный от Flannel плагин — например, Calico. Требования: 
* установка производится через ansible/kubespray;
* после применения следует настроить политику доступа к hello-world извне. Инструкции [kubernetes.io](https://kubernetes.io/docs/concepts/services-networking/network-policies/), [Calico](https://docs.projectcalico.org/about/about-network-policy)


**Answer**

- [hello-world application deployment](assets/hello-world.yaml)
- [hello-world network policy](assets/external-networkpolicy.yaml)

Политика ограничивает доступ к приложению, разрешая доступ только из подсети 192.168.0.0/16.
Соответственно доступ изнутри кластера не работает.

Деплой приложения:

```console
root@control01:/home/vagrant# kubectl apply -f hello-world.yaml
namespace/hello-world created
deployment.apps/hello-world created
service/hello-world created
root@control01:/home/vagrant# kubectl -n hello-world get service
NAME          TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
hello-world   NodePort   10.233.30.117   <none>        8080:31947/TCP   71s
root@control01:/home/vagrant# kubectl -n hello-world get pods -o wide
NAME                           READY   STATUS    RESTARTS   AGE    IP             NODE       NOMINATED NODE   READINESS GATES
hello-world-68bfd59bd9-mwh6t   1/1     Running   0          100s   10.233.94.68   worker02   <none>           <none>
root@control01:/home/vagrant# kubectl get nodes -o wide
NAME        STATUS   ROLES           AGE    VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
control01   Ready    control-plane   110m   v1.24.2   192.168.0.132   <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.8
worker01    Ready    <none>          109m   v1.24.2   192.168.0.170   <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.8
worker02    Ready    <none>          109m   v1.24.2   192.168.0.121   <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.8
```

Тестирование коннекта до применения политик с помощью тестового контейнера

```
kubectl run test -ti --image=k8s.gcr.io/echoserver:1.4 -- bash
```

Тестируем
- коннект по внешнему адресу ноды

```console
root@test:/# curl http://192.168.0.121:31947/
CLIENT VALUES:
client_address=192.168.0.170
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://192.168.0.121:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=192.168.0.121:31947
user-agent=curl/7.47.0
BODY:
-no body in request-root@test:/# 
```
- коннект по адресу сервиса

```console
root@test:/# curl http://10.233.30.117:8080/
CLIENT VALUES:
client_address=10.233.69.8
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://10.233.30.117:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=10.233.30.117:8080
user-agent=curl/7.47.0
BODY:
-no body in request-root@test:/# 
```

- коннект по адресу пода

```console
root@test:/# curl http://10.233.94.68:8080/
CLIENT VALUES:
client_address=10.233.69.8
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://10.233.94.68:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=10.233.94.68:8080
user-agent=curl/7.47.0
BODY:
-no body in request-root@test:/# 
```

Применяем политики:

```console
root@control01:/home/vagrant# kubectl apply -f external-networkpolicy.yaml
networkpolicy.networking.k8s.io/external-networkpolicy created
```

Тестируем
- коннект по внешнему адресу ноды

```console
root@test:/# curl http://192.168.0.121:31947/
CLIENT VALUES:
client_address=192.168.0.170
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://192.168.0.121:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=192.168.0.121:31947
user-agent=curl/7.47.0
BODY:
-no body in request-root@test:/#
```

- коннект по адресу сервиса

```console
root@test:/# curl -m 5 http://10.233.30.117:8080/
curl: (28) Connection timed out after 5000 milliseconds
```

- коннект по адресу пода

```console
root@test:/# curl -m 5 http://10.233.94.68:8080/
curl: (28) Connection timed out after 5019 milliseconds
```

---

## Задание 2: изучить, что запущено по умолчанию
Самый простой способ — проверить командой calicoctl get <type>. Для проверки стоит получить список нод, ipPool и profile.
Требования: 
* установить утилиту calicoctl;
* получить 3 вышеописанных типа в консоли.

**Answer**



---