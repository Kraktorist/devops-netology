# Домашнее задание к занятию "12.1 Компоненты Kubernetes"

Вы DevOps инженер в крупной компании с большим парком сервисов. Ваша задача — разворачивать эти продукты в корпоративном кластере. 

## Задача 1: Установить Minikube

<details>

__<summary>Условие задачи</summary>__

Для экспериментов и валидации ваших решений вам нужно подготовить тестовую среду для работы с Kubernetes. Оптимальное решение — развернуть на рабочей машине Minikube.

### Как поставить на AWS:
- создать EC2 виртуальную машину (Ubuntu Server 20.04 LTS (HVM), SSD Volume Type) с типом **t3.small**. Для работы потребуется настроить Security Group для доступа по ssh. Не забудьте указать keypair, он потребуется для подключения.
- подключитесь к серверу по ssh (ssh ubuntu@<ipv4_public_ip> -i <keypair>.pem)
- установите миникуб и докер следующими командами:
  - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  - chmod +x ./kubectl
  - sudo mv ./kubectl /usr/local/bin/kubectl
  - sudo apt-get update && sudo apt-get install docker.io conntrack -y
  - curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
- проверить версию можно командой minikube version
- переключаемся на root и запускаем миникуб: minikube start --vm-driver=none
- после запуска стоит проверить статус: minikube status
- запущенные служебные компоненты можно увидеть командой: kubectl get pods --namespace=kube-system

### Для сброса кластера стоит удалить кластер и создать заново:
- minikube delete
- minikube start --vm-driver=none

Возможно, для повторного запуска потребуется выполнить команду: sudo sysctl fs.protected_regular=0

Инструкция по установке Minikube - [ссылка](https://kubernetes.io/ru/docs/tasks/tools/install-minikube/)

**Важно**: t3.small не входит во free tier, следите за бюджетом аккаунта и удаляйте виртуалку.

</details>

**Answer**

- [Vagrantfile](assets/Vagrantfile)  
- [Minikube Prerequisites Provisioner](assets/provisioners/minikube_prerequisites.sh)  
- [Minikube Installation Provisioner](assets/provisioners/minikube_installation.sh)  

---

## Задача 2: Запуск Hello World
После установки Minikube требуется его проверить. Для этого подойдет стандартное приложение hello world. А для доступа к нему потребуется ingress.

- развернуть через Minikube тестовое приложение по [туториалу](https://kubernetes.io/ru/docs/tutorials/hello-minikube/#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BA%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%B0-minikube)
- установить аддоны ingress и dashboard

**Answer**

[Apps Installation Provisioner](assets/provisioners/apps_installation.sh)  

---

## Задача 3: Установить kubectl

Подготовить рабочую машину для управления корпоративным кластером. Установить клиентское приложение kubectl.
- подключиться к minikube 
- проверить работу приложения из задания 2, запустив port-forward до кластера

**Answer**

[Apps Tests Provisioner](assets/provisioners/apps_test.sh)  

Result:

```console
(base) user@workstation:~/repos/devops-netology/12-kubernetes-01-intro/assets$ vagrant up --provision-with Test
Bringing machine 'minikube' up with 'virtualbox' provider...
==> minikube: Running provisioner: Test (shell)...
    minikube: Running: /tmp/vagrant-shell20220819-159533-j7hcv1.sh
    minikube: CLIENT VALUES:
    minikube: client_address=172.17.0.1
    minikube: command=GET
    minikube: real path=/
    minikube: query=nil
    minikube: request_version=1.1
    minikube: request_uri=http://192.168.49.2:8080/
    minikube: 
    minikube: SERVER VALUES:
    minikube: server_version=nginx: 1.10.0 - lua: 10001
    minikube: 
    minikube: HEADERS RECEIVED:
    minikube: accept=*/*
    minikube: host=192.168.49.2:30356
    minikube: user-agent=curl/7.81.0
    minikube: BODY:
    minikube: -no body in request-
```


## Задача 4 (*): собрать через ansible (необязательное)

Профессионалы не делают одну и ту же задачу два раза. Давайте закрепим полученные навыки, автоматизировав выполнение заданий  ansible-скриптами. При выполнении задания обратите внимание на доступные модули для k8s под ansible.
 - собрать роль для установки minikube на aws сервисе (с установкой ingress)
 - собрать роль для запуска в кластере hello world
  
**Answer**

- [minikube-role](assets/ansible/minikube-role/)  
- [hello-app](assets/ansible/hello-app/)