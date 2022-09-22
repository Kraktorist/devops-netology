# Домашнее задание к занятию "13.3 работа с kubectl"
## Задание 1: проверить работоспособность каждого компонента
Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:
* сделайте запросы к бекенду;
* сделайте запросы к фронту;
* подключитесь к базе данных.

**Answer**

**port-forward**

```console
vagrant@vagrant> kubectl port-forward deployment/frontend 8080:80 &
[1] 17925
vagrant@vagrant> Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80

vagrant@vagrant> curl http://localhost:8080
Handling connection for 8080
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>vagrant@vagrant> 
```

```console
vagrant@vagrant> kubectl port-forward deployment/backend 8080:9000 &
[1] 18678
vagrant@vagrant> Forwarding from 127.0.0.1:8080 -> 9000
Forwarding from [::1]:8080 -> 9000

vagrant@vagrant> curl http://localhost:8080/api/news/1
Handling connection for 8080
{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","description":"0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, 0 some more text, ","preview":"/static/image.png"}vagrant@vagrant> 
```

**exec**

```console
vagrant@vagrant> kubectl exec -ti frontend-b84fb7fbf-h5fqz -- bash
root@frontend-b84fb7fbf-h5fqz:/app# curl http://news-backend:9000
{"detail":"Not Found"}
root@frontend-b84fb7fbf-h5fqz:/app# curl http://news-frontend
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
root@frontend-b84fb7fbf-h5fqz:/app# curl http://news-backend
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
root@frontend-b84fb7fbf-h5fqz:/app# curl http://news-backend:9000
{"detail":"Not Found"}
```

**exec backend**

```console
vagrant@vagrant> kubectl exec -ti backend-7db7844b7c-g9r9f -- bash
root@backend-7db7844b7c-g9r9f:/app# curl http://localhost:9000
{"detail":"Not Found"}
root@backend-7db7844b7c-g9r9f:/app#
```

```
vagrant@vagrant> kubectl exec -t postgres-0 -- psql -U postgres -c '\l'
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 news      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)

vagrant@vagrant> 
```

---

## Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

**Answer**

```console

vagrant@vagrant> kubectl -n newspaper get deployments
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
backend    1/1     1            1           91s
frontend   1/1     1            1           91s
vagrant@vagrant> kubectl -n newspaper scale deployments --replicas=3 --all
deployment.apps/backend scaled
deployment.apps/frontend scaled
vagrant@vagrant> kubectl -n newspaper get deployments
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
backend    3/3     3            3           109s
frontend   3/3     3            3           109s
vagrant@vagrant> kubectl -n newspaper get pods -o wide
NAME                       READY   STATUS    RESTARTS   AGE    IP               NODE       NOMINATED NODE   READINESS GATES
backend-7db7844b7c-4kn2t   1/1     Running   0          115s   10.233.106.184   master01   <none>           <none>
backend-7db7844b7c-8bxk6   1/1     Running   0          13s    10.233.106.130   master01   <none>           <none>
backend-7db7844b7c-zhgtr   1/1     Running   0          13s    10.233.106.135   master01   <none>           <none>
frontend-b84fb7fbf-2t9xb   1/1     Running   0          13s    10.233.106.136   master01   <none>           <none>
frontend-b84fb7fbf-7rw6s   1/1     Running   0          115s   10.233.106.132   master01   <none>           <none>
frontend-b84fb7fbf-n9tg8   1/1     Running   0          13s    10.233.106.131   master01   <none>           <none>
postgres-0                 1/1     Running   0          115s   10.233.106.190   master01   <none>           <none>
vagrant@vagrant> kubectl -n newspaper scale deployments --replicas=1 --all
deployment.apps/backend scaled
deployment.apps/frontend scaled
vagrant@vagrant> kubectl -n newspaper get pods
NAME                       READY   STATUS    RESTARTS   AGE
backend-7db7844b7c-4kn2t   1/1     Running   0          3m8s
frontend-b84fb7fbf-7rw6s   1/1     Running   0          3m8s
postgres-0                 1/1     Running   0          3m8s
vagrant@vagrant> kubectl -n newspaper describe pods/backend-7db7844b7c-4kn2t 
Name:         backend-7db7844b7c-4kn2t
Namespace:    newspaper
Priority:     0
Node:         master01/192.168.0.165
Start Time:   Thu, 22 Sep 2022 20:40:10 +0300
Labels:       app=backend
              pod-template-hash=7db7844b7c
Annotations:  cni.projectcalico.org/containerID: f050719b6afc81006b68605ae4ff10c051576492c83fa3688926ee73192648f3
              cni.projectcalico.org/podIP: 10.233.106.184/32
              cni.projectcalico.org/podIPs: 10.233.106.184/32
Status:       Running
IP:           10.233.106.184
IPs:
  IP:           10.233.106.184
Controlled By:  ReplicaSet/backend-7db7844b7c
Containers:
  news-backend:
    Container ID:   containerd://c55588337b648713e5dbba9bd0d6cdfe6ee40e0465a220ef43545e3ae5119477
    Image:          kraktorist/news-backend:1.0
    Image ID:       docker.io/kraktorist/news-backend@sha256:5bb6a45d0e9f685f28cd28438ecb2e6251d1f9e168553d8651bd0a03020473c7
    Port:           9000/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 22 Sep 2022 20:40:11 +0300
    Ready:          True
    Restart Count:  0
    Environment:
      DATABASE_URL:  postgres://postgres:postgres@postgres:5432/news
    Mounts:
      /static from static (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-92wm4 (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  static:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  static
    ReadOnly:   false
  kube-api-access-92wm4:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  3m24s  default-scheduler  Successfully assigned newspaper/backend-7db7844b7c-4kn2t to master01
  Normal  Pulled     3m23s  kubelet            Container image "kraktorist/news-backend:1.0" already present on machine
  Normal  Created    3m23s  kubelet            Created container news-backend
  Normal  Started    3m23s  kubelet            Started container news-backend
```