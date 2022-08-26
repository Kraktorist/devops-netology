# Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"
Новые проекты пошли стабильным потоком. Каждый проект требует себе несколько кластеров: под тесты и продуктив. Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

## Задание 1: Подготовить инвентарь kubespray
Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.

**Answer**

[terraform state](assets/terraform/) читает [config](assets/hosts.yml), на его основе создает набор хостов в virtualbox и генерирует ansible inventory ([для примера])(assets/ansible/inventory.yml). Переменные [group_vars](assets/ansible/group_vars/) помещены в ту же папку. После создания хостов клонируем во временную папку репозиторий kubespray и запускаем ansible-playbook. 

```
ssh-add ~/vagrant_key # ключ из репозитория vagrant
cd assets/terraform && terraform apply
tmp=$(mktemp -d)
git clone https://github.com/kubernetes-sigs/kubespray.git ${tmp}
ansible-playbook -i ../ansible/inventory.yml --become ${tmp}/cluster.yml
```

Результат:

```console
(base) user@hmlab01:~assets/terraform$ terraform output
nodes_ips = {
  "control01" = "192.168.0.83"
  "worker01" = "192.168.0.187"
  "worker02" = "192.168.0.168"
  "worker03" = "192.168.0.145"
  "worker04" = "192.168.0.79"
}
(base) user@hmlab01:~assets/terraform$ ssh vagrant@192.168.0.83 sudo cat /root/.kube/config>~/.kube/config
(base) user@hmlab01:~assets/terraform$ kubectl config set-cluster cluster.local --server=https://192.168.0.83:6443/ --insecure-skip-tls-verify=true
(base) user@hmlab01:~assets/terraform$ kubectl get nodes -o wide
NAME        STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
control01   Ready    control-plane   52m   v1.24.2   192.168.0.83    <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.8
worker01    Ready    <none>          51m   v1.24.2   192.168.0.187   <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.8
worker02    Ready    <none>          51m   v1.24.2   192.168.0.168   <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.8
worker03    Ready    <none>          51m   v1.24.2   192.168.0.145   <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.8
worker04    Ready    <none>          51m   v1.24.2   192.168.0.79    <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.8

```

---

## Задание 2 (*): подготовить и проверить инвентарь для кластера в AWS
Часть новых проектов хотят запускать на мощностях AWS. Требования похожи:
* разворачивать 5 нод: 1 мастер и 4 рабочие ноды;
* работать должны на минимально допустимых EC2 — t3.small.

**Answer**

Развертывание производится в yandex cloud. Для развертывания используется тот же terraform state, но в конфиге hosts.yml указывается другой провадер `provider: ychosted`.


```console
(base) user@hmlab01:~assets/terraform$ terraform output
nodes_ips = {
  "control01" = "51.250.105.255"
  "worker01" = "84.201.141.76"
  "worker02" = "84.201.143.242"
  "worker03" = "84.201.154.254"
  "worker04" = "84.252.136.12"
}
(base) user@hmlab01:~assets/terraform$ ssh ubuntu@51.250.105.255 sudo cat /root/.kube/config>~/.kube/config
(base) user@hmlab01:~assets/terraform$ kubectl config set-cluster cluster.local --server=https://51.250.105.255:6443/ --insecure-skip-tls-verify=true
(base) user@hmlab01:~assets/terraform$ kubectl get nodes -o wide
NAME        STATUS   ROLES           AGE     VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
control01   Ready    control-plane   8m21s   v1.24.2   192.168.0.7    <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
worker01    Ready    <none>          6m59s   v1.24.2   192.168.0.27   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
worker02    Ready    <none>          6m58s   v1.24.2   192.168.0.26   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
worker03    Ready    <none>          6m59s   v1.24.2   192.168.0.20   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
worker04    Ready    <none>          6m59s   v1.24.2   192.168.0.30   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
```

---