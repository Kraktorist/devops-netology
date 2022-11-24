# Домашнее задание к занятию "14.5 SecurityContext, NetworkPolicies"

## Задача 1: Рассмотрите пример 14.5/example-security-context.yml

Создайте модуль

```
kubectl apply -f 14.5/example-security-context.yml
```

Проверьте установленные настройки внутри контейнера

```
kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```

**Answer**

```console
vagrant@vagrant:~/$ kubectl apply -f example-security-context.yml 
pod/security-context-demo created
vagrant@vagrant:~/$ kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```

---

## Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру
и ко второму контейнеру. Для второго модуля разрешите связь только с
первым контейнером. Проверьте корректность настроек.

**Answer**

[NetworkPolicy manifest](assets/networkpolicy.yml)

```console
vagrant@vagrant:~/$ kubectl get pods -o wide
NAME                                  READY   STATUS             RESTARTS         AGE    IP               NODE       NOMINATED NODE   READINESS GATES
module1                               1/1     Running            0                24m    10.233.106.175   master01   <none>           <none>
module2                               1/1     Running            0                24m    10.233.106.160   master01   <none>           <none>
nfs-server-nfs-server-provisioner-0   1/1     Running            1 (3d7h ago)     7d3h   10.233.106.148   master01   <none>           <none>
security-context-demo                 0/1     CrashLoopBackOff   24 (4m15s ago)   102m   10.233.106.187   master01   <none>           <none>
vagrant@vagrant:~/$ kubectl exec -ti module1 bash
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
[root@module1 /]# ping 10-233-106-148.default.pod.cluster.local
PING 10-233-106-148.default.pod.cluster.local (10.233.106.148) 56(84) bytes of data.
^C
--- 10-233-106-148.default.pod.cluster.local ping statistics ---
6 packets transmitted, 0 received, 100% packet loss, time 5102ms

[root@module1 /]# ping 10-233-106-160.default.pod.cluster.local
PING 10-233-106-160.default.pod.cluster.local (10.233.106.160) 56(84) bytes of data.
64 bytes from 10.233.106.160 (10.233.106.160): icmp_seq=1 ttl=63 time=0.108 ms
64 bytes from 10.233.106.160 (10.233.106.160): icmp_seq=2 ttl=63 time=0.081 ms
^C
--- 10-233-106-160.default.pod.cluster.local ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.081/0.094/0.108/0.016 ms
[root@module1 /]# ping www.google.com
PING www.google.com (173.194.222.105) 56(84) bytes of data.
64 bytes from lo-in-f105.1e100.net (173.194.222.105): icmp_seq=1 ttl=57 time=17.3 ms
64 bytes from lo-in-f105.1e100.net (173.194.222.105): icmp_seq=2 ttl=57 time=16.9 ms
^C
--- www.google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 16.984/17.149/17.315/0.211 ms
```

---