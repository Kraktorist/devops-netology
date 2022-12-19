# Домашнее задание к занятию 15.2 "Вычислительные мощности. Балансировщики нагрузки".
Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако, и дополнительной части в AWS (можно выполнить по желанию). Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. Перед началом работ следует настроить доступ до облачных ресурсов из Terraform, используя материалы прошлых лекций и ДЗ.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать bucket Object Storage и разместить там файл с картинкой:
- Создать bucket в Object Storage с произвольным именем (например, _имя_студента_дата_);
- Положить в bucket файл с картинкой;
- Сделать файл доступным из Интернет.
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и web-страничкой, содержащей ссылку на картинку из bucket:
- Создать Instance Group с 3 ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`;
- Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata);
- Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из bucket;
- Настроить проверку состояния ВМ.
3. Подключить группу к сетевому балансировщику:
- Создать сетевой балансировщик;
- Проверить работоспособность, удалив одну или несколько ВМ.
4. *Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Документация
- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group)
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer)
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer)
---

**Answer**

Для удобства дальнейшей работы создание ресурсов разбито на terraform модули.

- [alb](assets/modules/alb/) для настройки Application LoadBalancer
- [nlb](assets/modules/nlb/) для настройки Network LoadBalancer
- [buckets](assets/modules/buckets/) для создания бакета и статического сайта
- [instance-groups](assets/modules/instance-groups/) для создания и настройки Instance Groups
- [networks](assets/modules/networks/) для создания сетей и подсетей

Вызов модулей производится из файла [main.tf](assets/main.tf). 

```console
% terraform state list
data.yandex_iam_service_account.lamp
module.alb[0].yandex_alb_backend_group.lamp-group
module.alb[0].yandex_alb_http_router.router
module.alb[0].yandex_alb_load_balancer.lamp-balancer
module.alb[0].yandex_alb_virtual_host.lamp-virtual-host
module.buckets.yandex_storage_bucket.hosting
module.buckets.yandex_storage_object.picture
module.instance-groups.yandex_compute_instance_group.lamp_group
module.networks.yandex_vpc_network.network
module.networks.yandex_vpc_subnet.public
```

Выбор типа балансера (`alb` или `nlb`) производится с помощью переменной `balancer` из файла [variables.tf](assets/variables.tf).

```console
% export TF_VAR_balancer=nlb
% terraform apply
% terraform state list
data.yandex_iam_service_account.lamp
module.buckets.yandex_storage_bucket.hosting
module.buckets.yandex_storage_object.picture
module.instance-groups.yandex_compute_instance_group.lamp_group
module.networks.yandex_vpc_network.network
module.networks.yandex_vpc_subnet.public
module.nlb[0].yandex_lb_network_load_balancer.lamp
```

---

<details>
<summary>Задание 2*. AWS (необязательное к выполнению)</summary>
## Задание 2*. AWS (необязательное к выполнению)

Используя конфигурации, выполненные в рамках ДЗ на предыдущем занятии, добавить к Production like сети Autoscaling group из 3 EC2-инстансов с  автоматической установкой web-сервера в private домен.

1. Создать bucket S3 и разместить там файл с картинкой:
- Создать bucket в S3 с произвольным именем (например, _имя_студента_дата_);
- Положить в bucket файл с картинкой;
- Сделать доступным из Интернета.
2. Сделать Launch configurations с использованием bootstrap скрипта с созданием веб-странички на которой будет ссылка на картинку в S3. 
3. Загрузить 3 ЕС2-инстанса и настроить LB с помощью Autoscaling Group.

Resource terraform
- [S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template)
- [Autoscaling group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
- [Launch configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration)

Пример bootstrap-скрипта:
```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
```

</details>