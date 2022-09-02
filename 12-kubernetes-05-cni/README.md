# Домашнее задание к занятию "12.5 Сетевые решения CNI"
После работы с Flannel появилась необходимость обеспечить безопасность для приложения. Для этого лучше всего подойдет Calico.
## Задание 1: установить в кластер CNI плагин Calico
Для проверки других сетевых решений стоит поставить отличный от Flannel плагин — например, Calico. Требования: 
* установка производится через ansible/kubespray;
* после применения следует настроить политику доступа к hello-world извне. Инструкции [kubernetes.io](https://kubernetes.io/docs/concepts/services-networking/network-policies/), [Calico](https://docs.projectcalico.org/about/about-network-policy)


**Answer**

- [hello-world application deployment](assets/hello-world.yaml)
- [hello-world network policy](assets/external-networkpolicy.yaml)

Политика ограничивает доступ к приложению, разрешая трафик только из подсети 192.168.0.0/16.
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

Установка утилиты

```console
root@control01:/home/vagrant# kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/calicoctl.yaml
serviceaccount/calicoctl created
pod/calicoctl created
clusterrole.rbac.authorization.k8s.io/calicoctl created
clusterrolebinding.rbac.authorization.k8s.io/calicoctl created
```

- nodes

```console
root@control01:/home/vagrant# kubectl exec -ti -n kube-system calicoctl -- /calicoctl --allow-version-mismatch get nodes -o wide
NAME        ASN       IPV4               IPV6   
control01   (64512)   192.168.0.132/24          
worker01    (64512)   192.168.0.170/24          
worker02    (64512)   192.168.0.121/24     
```

- ipPool

```console
root@control01:/home/vagrant# kubectl exec -ti -n kube-system calicoctl -- /calicoctl --allow-version-mismatch get ipPool -o wide
NAME           CIDR             NAT    IPIPMODE   VXLANMODE   DISABLED   DISABLEBGPEXPORT   SELECTOR   
default-pool   10.233.64.0/18   true   Never      Always      false      false              all()
```

- profile
  
```console
root@control01:/home/vagrant# kubectl exec -ti -n kube-system calicoctl -- /calicoctl --allow-version-mismatch get profiles -o wide
NAME                                                 LABELS                                                                                                                             
projectcalico-default-allow                                                                                                                                                             
kns.default                                          pcns.kubernetes.io/metadata.name=default,pcns.projectcalico.org/name=default                                                       
kns.hello-world                                      pcns.kubernetes.io/metadata.name=hello-world,pcns.projectcalico.org/name=hello-world                                               
kns.ingress-nginx                                    pcns.kubernetes.io/metadata.name=ingress-nginx,pcns.name=ingress-nginx,pcns.projectcalico.org/name=ingress-nginx                   
kns.kube-node-lease                                  pcns.kubernetes.io/metadata.name=kube-node-lease,pcns.projectcalico.org/name=kube-node-lease                                       
kns.kube-public                                      pcns.kubernetes.io/metadata.name=kube-public,pcns.projectcalico.org/name=kube-public                                               
kns.kube-system                                      pcns.kubernetes.io/metadata.name=kube-system,pcns.projectcalico.org/name=kube-system                                               
ksa.default.default                                  pcsa.projectcalico.org/name=default                                                                                                
ksa.hello-world.default                              pcsa.projectcalico.org/name=default                                                                                                
ksa.ingress-nginx.default                            pcsa.projectcalico.org/name=default                                                                                                
ksa.ingress-nginx.ingress-nginx                      pcsa.app.kubernetes.io/name=ingress-nginx,pcsa.app.kubernetes.io/part-of=ingress-nginx,pcsa.projectcalico.org/name=ingress-nginx   
ksa.kube-node-lease.default                          pcsa.projectcalico.org/name=default                                                                                                
ksa.kube-public.default                              pcsa.projectcalico.org/name=default                                                                                                
ksa.kube-system.attachdetach-controller              pcsa.projectcalico.org/name=attachdetach-controller                                                                                
ksa.kube-system.bootstrap-signer                     pcsa.projectcalico.org/name=bootstrap-signer                                                                                       
ksa.kube-system.calico-node                          pcsa.projectcalico.org/name=calico-node                                                                                            
ksa.kube-system.calicoctl                            pcsa.projectcalico.org/name=calicoctl                                                                                              
ksa.kube-system.certificate-controller               pcsa.projectcalico.org/name=certificate-controller                                                                                 
ksa.kube-system.clusterrole-aggregation-controller   pcsa.projectcalico.org/name=clusterrole-aggregation-controller                                                                     
ksa.kube-system.coredns                              pcsa.addonmanager.kubernetes.io/mode=Reconcile,pcsa.projectcalico.org/name=coredns                                                 
ksa.kube-system.cronjob-controller                   pcsa.projectcalico.org/name=cronjob-controller                                                                                     
ksa.kube-system.daemon-set-controller                pcsa.projectcalico.org/name=daemon-set-controller                                                                                  
ksa.kube-system.default                              pcsa.projectcalico.org/name=default                                                                                                
ksa.kube-system.deployment-controller                pcsa.projectcalico.org/name=deployment-controller                                                                                  
ksa.kube-system.disruption-controller                pcsa.projectcalico.org/name=disruption-controller                                                                                  
ksa.kube-system.dns-autoscaler                       pcsa.addonmanager.kubernetes.io/mode=Reconcile,pcsa.projectcalico.org/name=dns-autoscaler                                          
ksa.kube-system.endpoint-controller                  pcsa.projectcalico.org/name=endpoint-controller                                                                                    
ksa.kube-system.endpointslice-controller             pcsa.projectcalico.org/name=endpointslice-controller                                                                               
ksa.kube-system.endpointslicemirroring-controller    pcsa.projectcalico.org/name=endpointslicemirroring-controller                                                                      
ksa.kube-system.ephemeral-volume-controller          pcsa.projectcalico.org/name=ephemeral-volume-controller                                                                            
ksa.kube-system.expand-controller                    pcsa.projectcalico.org/name=expand-controller                                                                                      
ksa.kube-system.generic-garbage-collector            pcsa.projectcalico.org/name=generic-garbage-collector                                                                              
ksa.kube-system.horizontal-pod-autoscaler            pcsa.projectcalico.org/name=horizontal-pod-autoscaler                                                                              
ksa.kube-system.job-controller                       pcsa.projectcalico.org/name=job-controller                                                                                         
ksa.kube-system.kube-proxy                           pcsa.projectcalico.org/name=kube-proxy                                                                                             
ksa.kube-system.metrics-server                       pcsa.addonmanager.kubernetes.io/mode=Reconcile,pcsa.projectcalico.org/name=metrics-server                                          
ksa.kube-system.namespace-controller                 pcsa.projectcalico.org/name=namespace-controller                                                                                   
ksa.kube-system.node-controller                      pcsa.projectcalico.org/name=node-controller                                                                                        
ksa.kube-system.nodelocaldns                         pcsa.addonmanager.kubernetes.io/mode=Reconcile,pcsa.projectcalico.org/name=nodelocaldns                                            
ksa.kube-system.persistent-volume-binder             pcsa.projectcalico.org/name=persistent-volume-binder                                                                               
ksa.kube-system.pod-garbage-collector                pcsa.projectcalico.org/name=pod-garbage-collector                                                                                  
ksa.kube-system.pv-protection-controller             pcsa.projectcalico.org/name=pv-protection-controller                                                                               
ksa.kube-system.pvc-protection-controller            pcsa.projectcalico.org/name=pvc-protection-controller                                                                              
ksa.kube-system.replicaset-controller                pcsa.projectcalico.org/name=replicaset-controller                                                                                  
ksa.kube-system.replication-controller               pcsa.projectcalico.org/name=replication-controller                                                                                 
ksa.kube-system.resourcequota-controller             pcsa.projectcalico.org/name=resourcequota-controller                                                                               
ksa.kube-system.root-ca-cert-publisher               pcsa.projectcalico.org/name=root-ca-cert-publisher                                                                                 
ksa.kube-system.service-account-controller           pcsa.projectcalico.org/name=service-account-controller                                                                             
ksa.kube-system.service-controller                   pcsa.projectcalico.org/name=service-controller                                                                                     
ksa.kube-system.statefulset-controller               pcsa.projectcalico.org/name=statefulset-controller                                                                                 
ksa.kube-system.token-cleaner                        pcsa.projectcalico.org/name=token-cleaner                                                                                          
ksa.kube-system.ttl-after-finished-controller        pcsa.projectcalico.org/name=ttl-after-finished-controller                                                                          
ksa.kube-system.ttl-controller                       pcsa.projectcalico.org/name=ttl-controller      
```
---