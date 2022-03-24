# Домашнее задание к занятию "7.1. Инфраструктура как код"

## Задача 1. Выбор инструментов. 
 
### Легенда
 
Через час совещание на котором менеджер расскажет о новом проекте. Начать работу над которым надо 
будет уже сегодня. 
На данный момент известно, что это будет сервис, который ваша компания будет предоставлять внешним заказчикам.
Первое время, скорее всего, будет один внешний клиент, со временем внешних клиентов станет больше.

Так же по разговорам в компании есть вероятность, что техническое задание еще не четкое, что приведет к большому
количеству небольших релизов, тестирований интеграций, откатов, доработок, то есть скучно не будет.  
   
Вам, как девопс инженеру, будет необходимо принять решение об инструментах для организации инфраструктуры.
На данный момент в вашей компании уже используются следующие инструменты: 
- остатки Сloud Formation, 
- некоторые образы сделаны при помощи Packer,
- год назад начали активно использовать Terraform, 
- разработчики привыкли использовать Docker, 
- уже есть большая база Kubernetes конфигураций, 
- для автоматизации процессов используется Teamcity, 
- также есть совсем немного Ansible скриптов, 
- и ряд bash скриптов для упрощения рутинных задач.  

Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
1. Будет ли центральный сервер для управления инфраструктурой?
1. Будут ли агенты на серверах?
1. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? 
 
В связи с тем, что проект стартует уже сегодня, в рамках совещания надо будет определиться со всеми этими вопросами.

### В результате задачи необходимо

1. Ответить на четыре вопроса представленных в разделе "Легенда". 
1. Какие инструменты из уже используемых вы хотели бы использовать для нового проекта? 
1. Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта? 

Если для ответа на эти вопросы недостаточно информации, то напишите какие моменты уточните на совещании.


---
**Answer**

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или неизменяемый?

> Неизменяемый тип выглядит перспективнее, стабильнее, и уже применяется компанией.

2. Будет ли центральный сервер для управления инфраструктурой?

> Нет, за исключением сервера CI/CD.

3. Будут ли агенты на серверах?

> Не требуются, достаточно ssh/ansible.

4. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? 

> Terraform, Ansible  


>Ответы выше не учитывают особенностей проекта, которые могут выявиться в процессе обсуждения. Например,  
>- могут быть специальные требования к безопасности, не позволяющие использовать те или иные технологии (контейнеризацию, публичные облака итп), или требующие исполнения стандартов, предполагающих особый порядок работы (фаерволы или выделенные сегменты сети для работы с данным пользователей итп);
>- может выясниться, что проект ограничен в ресурсах и бюджете, что может потребовать применять изменяемую (мутабельную) конфигурацию.

> Поскольку в компании есть экспертиза в области контейнеризации, то имеет смысл задействовать ее в полной мере, применив `docker` и `kubernetes`, что позволит ускорить процесс внедрения изменений продукта. Развертывание кластеров можно осуществить с помощью `terraform` и `ansible`. Применение Cloud Kubernetes (AWS EKS или Google Kubernetes Engine) позволит переложить поддержку инфраструктуры Kubernetes кластеров на cloud-провайдера, сконцентрировавшись на поддержке продукта.
> Из дополнительных инструментов стоит рассмотреть `helm` и `terragrunt`.


## Задача 2. Установка терраформ. 

Официальный сайт: https://www.terraform.io/

Установите терраформ при помощи менеджера пакетов используемого в вашей операционной системе.
В виде результата этой задачи приложите вывод команды `terraform --version`.


---
**Answer**

[Vagrantfile with installation script](assets/Vagrantfile)


    vagrant@vagrant:~$ terraform --version
    Terraform v1.1.7
    on linux_amd64


## Задача 3. Поддержка легаси кода. 

В какой-то момент вы обновили терраформ до новой версии, например с 0.12 до 0.13. 
А код одного из проектов настолько устарел, что не может работать с версией 0.13. 
В связи с этим необходимо сделать так, чтобы вы могли одновременно использовать последнюю версию терраформа установленную при помощи
штатного менеджера пакетов и устаревшую версию 0.12. 

В виде результата этой задачи приложите вывод `--version` двух версий терраформа доступных на вашем компьютере 
или виртуальной машине.


---
**Answer**

>Простой вариант:
>1. Скачиваем бинарный файл terraform и помещаем его в систему как `/usr/bin/terraform0.12` (см. [Vagrantfile](assets/Vagrantfile))
>2. Добавляем в shell алиас вида

```bash
alias terraform='terraform"$TERRAFORM_VERSION"'
```

>3. Таким образом мы можем выбирать нужную версию terraform путем установки переменной среды `TERRAFORM_VERSION`

```bash
vagrant@vagrant:~$ terraform -v
Terraform v1.1.7
on linux_amd64
vagrant@vagrant:~$ TERRAFORM_VERSION=0.12
vagrant@vagrant:~$ terraform -v
Terraform v0.12.31

Your version of Terraform is out of date! The latest version
is 1.1.7. You can update by downloading from https://www.terraform.io/downloads.html
vagrant@vagrant:~$ unset TERRAFORM_VERSION
vagrant@vagrant:~$ terraform -v
Terraform v1.1.7
on linux_amd64
```
> В продвинутых вариантах будет проще воспользоваться имеющимися инструментами, работающими по похожему принципу, но управляющими бОльшим набором параметров terraform:  
https://github.com/tfutils/tfenv  
https://github.com/warrensbox/terraform-switcher