# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"


## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?  

**Answer**

- **В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?**  
replication type обеспечивает запуск заданного количества реплик, размещая их на доступных нодах кластера, а global type обеспечивает запуск по одной реплике на каждой доступной ноде кластера. Работает это примерно также, как ReplicaSet и DaemonSet в Kubernetes.
- **Какой алгоритм выбора лидера используется в Docker Swarm кластере?**  
Raft Consensus Algorithm. В случае неполучения heartbeat сообщения от текущего лидера фолловеры выжидают 150-300ms (election timeout). Если в указанный промежуток времени фолловер не получает приглашение проголосовать за какого-либо кандидата, то он сам объявляет себя кандидатом и рассылает такое приглашение. В случае получения большинства голосов кандидат объявляет себя лидером и периодически рассылает heartbeat сообщения остальным членам.
- **Что такое Overlay Network?**  
Сеть для обмена трафиком между контейнерами, находящимися на разных нодах кластера. Использует технологию VXLAN - инкапсуляцию L2 фреймы в L4 пакеты, что позволяет создавать виртуальные сети поверх физических.


## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```

**Answer**

  ![docker node ls](assets/docker-ls.png)  

    [centos@node01 ~]$ sudo docker node ls
    ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
    00sndgw2qxrw3q13wqkf63mx4 *   node01.netology.yc   Ready     Active         Leader           20.10.12
    ohslcduwsm8iwiwqe1e8er98a     node02.netology.yc   Ready     Active         Reachable        20.10.12
    dkfgtfqmjjcnmdfvxtmuwl8by     node03.netology.yc   Ready     Active         Reachable        20.10.12
    8b9b37mi476oz21o473u63ben     node04.netology.yc   Ready     Active                          20.10.12
    xdxld59f6e7u6q6u30tgp2yy3     node05.netology.yc   Ready     Active                          20.10.12
    x641f3fcbxa7v108xqa7nxqc0     node06.netology.yc   Ready     Active                          20.10.12


## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

**Answer**

  ![docker node ls](assets/docker-service.png)  

    [root@node01 ansible]# docker service ls
    ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
    jlhgjojuxtro   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
    keo3ogk0cygs   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
    pcjvk4y2q7jx   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
    l150tqel84t4   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
    nxzoheek2i96   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
    3dfc3et0lkcf   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
    jdtlhod4gdqf   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
    jumqm7tdd57q   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0              
