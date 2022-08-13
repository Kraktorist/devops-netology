
# Домашнее задание к занятию "11.04 Микросервисы: масштабирование"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Задача 1: Кластеризация

Предложите решение для обеспечения развертывания, запуска и управления приложениями.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- Поддержка контейнеров;
- Обеспечивать обнаружение сервисов и маршрутизацию запросов;
- Обеспечивать возможность горизонтального масштабирования;
- Обеспечивать возможность автоматического масштабирования;
- Обеспечивать явное разделение ресурсов доступных извне и внутри системы;
- Обеспечивать возможность конфигурировать приложения с помощью переменных среды, в том числе с возможностью безопасного хранения чувствительных данных таких как пароли, ключи доступа, ключи шифрования и т.п.

Обоснуйте свой выбор.

**Answer**

Возможные варианты:

| Name      | Containers |   Service Discovery    |  Horizontal Scaling | Autoscaling | Resource separation | Configs |
| :---:     |  :---:  |     :---:        | :---:  |      :---:  | :--: |        :---:  |
| kubernetes | + | internal DNS | + | + | + | secrets |
| redhat openshift | + | internal DNS | + | + | + | secrets |
| hashicorp nomad | + | native or consul | + | + | + | Vault |
| vmware tanzu | + |  internal DNS | + | + | + | secrets |
| docker swarm | + |  internal DNS | + | + | + | secrets |
| apache mesos | + |  internal DNS | + | + | + | secrets |

Все представленные решения можно условно разделить на две группы: 
- `kubernetes` и продукты на его основе (`openshift`, `tanzu`);
- самостоятельные оркестраторы.

Это сразу дает понимание того, что `kubernetes` является лидирующим продуктом в сфере оркестрации контейнеров. Учитывая поддержку со стороны публичных облачных платформ, выбор `kubernetes` в качестве решения для управления приложениями позволит с минимальными доработками деплоить приложения на родственные платформы и публичные облака.  
Из минусов платформы можно выделить не вполне безопасное хранение  паролей и ключей. Пароли и ключи обычно хранятся в объектах типа secret, которые не шифруются, а только кодируются алгоритмом base64. У пользователя, имеющего доступ к секретам черз API, есть возможность их чтения. Передача данных, содержащих объекты-секреты, по сети должна вестись только с шифрованием трафика. 
Для минимизации подобных недостатков в `nomad` применяется выделенный key management system: Hashicorp Vault. Подобные системы также есть в популярных публичных облаках.  
Также можно отметить, что `kubernetes` за редким исключением управляет только контейнерной инфраструктурой, в то время как `nomad`, `tanzu`, `mesos` позволяют управлять виртуальными машинами, сервисами и/или приложениями.

---

## Задача 2: Распределенный кэш * (необязательная)

<details>

__<summary>Условие задачи</summary>__

Разработчикам вашей компании понадобился распределенный кэш для организации хранения временной информации по сессиям пользователей.
Вам необходимо построить Redis Cluster состоящий из трех шард с тремя репликами.

### Схема:

![11-04-01](https://user-images.githubusercontent.com/1122523/114282923-9b16f900-9a4f-11eb-80aa-61ed09725760.png)

</details>

**Answers**

To build redish hosts using Virtualbox as a platform

```shell
cd assets/terraform
terraform init
terraform apply -var 'host_interface=enp5s1'
```

As an output of the terraform we get ansible inventory with the list of redis hosts ../ansible/hosts.yaml
Now we are ready to provision the hosts using ansible

```shell
cd assets/ansible
ansible-playbook -i hosts.yaml site.yml --become
```

and now we can check the replication

```shell
ansible-galaxy install davidwittman.redis
ansible-playbook -i hosts.yaml site.yml --become --tags test
```

Test ouptup

```console
PLAY [Redis Shards Configuration] *****************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [redis03]
ok: [redis02]
ok: [redis01]

TASK [Check replication status] *******************************************************************************************************
changed: [redis03]
changed: [redis02]
changed: [redis01]

TASK [Show replication parther] *******************************************************************************************************
ok: [redis01] => 
  msg: 'Replication: redis01 (192.168.0.199) -> slave0:ip=192.168.0.197,port=6380,state=online,offset=14,lag=0'
ok: [redis02] => 
  msg: 'Replication: redis02 (192.168.0.26) -> slave0:ip=192.168.0.199,port=6380,state=online,offset=14,lag=1'
ok: [redis03] => 
  msg: 'Replication: redis03 (192.168.0.197) -> slave0:ip=192.168.0.26,port=6380,state=online,offset=14,lag=0'

PLAY RECAP ****************************************************************************************************************************
redis01                    : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
redis02                    : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
redis03                    : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```