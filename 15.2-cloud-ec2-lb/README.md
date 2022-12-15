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

- [bucket.tf](assets/bucket.tf)
- [instance group](assets/nlb-instance-group.tf)
- [network load balancer](assets/nlb.tf)
- [application load balancer](assets/alb.tf)

```console
% terraform graph -draw-cycles -type=plan
digraph {
        compound = "true"
        newrank = "true"
        subgraph "root" {
                "[root] data.yandex_iam_service_account.lamp (expand)" [label = "data.yandex_iam_service_account.lamp", shape = "box"]
                "[root] provider[\"registry.terraform.io/yandex-cloud/yandex\"]" [label = "provider[\"registry.terraform.io/yandex-cloud/yandex\"]", shape = "diamond"]
                "[root] var.hosting_bucket" [label = "var.hosting_bucket", shape = "note"]
                "[root] var.lamp" [label = "var.lamp", shape = "note"]
                "[root] var.network_name" [label = "var.network_name", shape = "note"]
                "[root] var.picture_path" [label = "var.picture_path", shape = "note"]
                "[root] var.public_network" [label = "var.public_network", shape = "note"]
                "[root] var.service_account_id" [label = "var.service_account_id", shape = "note"]
                "[root] var.user_data" [label = "var.user_data", shape = "note"]
                "[root] yandex_alb_backend_group.lamp-group (expand)" [label = "yandex_alb_backend_group.lamp-group", shape = "box"]
                "[root] yandex_alb_http_router.router (expand)" [label = "yandex_alb_http_router.router", shape = "box"]
                "[root] yandex_alb_load_balancer.lamp-balancer (expand)" [label = "yandex_alb_load_balancer.lamp-balancer", shape = "box"]
                "[root] yandex_alb_virtual_host.lamp-virtual-host (expand)" [label = "yandex_alb_virtual_host.lamp-virtual-host", shape = "box"]
                "[root] yandex_compute_instance_group.alb_lamp_group (expand)" [label = "yandex_compute_instance_group.alb_lamp_group", shape = "box"]
                "[root] yandex_compute_instance_group.nlb_lamp_group (expand)" [label = "yandex_compute_instance_group.nlb_lamp_group", shape = "box"]
                "[root] yandex_lb_network_load_balancer.lamp (expand)" [label = "yandex_lb_network_load_balancer.lamp", shape = "box"]
                "[root] yandex_storage_bucket.hosting (expand)" [label = "yandex_storage_bucket.hosting", shape = "box"]
                "[root] yandex_storage_object.picture (expand)" [label = "yandex_storage_object.picture", shape = "box"]
                "[root] yandex_vpc_network.network (expand)" [label = "yandex_vpc_network.network", shape = "box"]
                "[root] yandex_vpc_subnet.public (expand)" [label = "yandex_vpc_subnet.public", shape = "box"]
                "[root] data.yandex_iam_service_account.lamp (expand)" -> "[root] provider[\"registry.terraform.io/yandex-cloud/yandex\"]"
                "[root] data.yandex_iam_service_account.lamp (expand)" -> "[root] var.service_account_id"
                "[root] provider[\"registry.terraform.io/yandex-cloud/yandex\"] (close)" -> "[root] yandex_alb_load_balancer.lamp-balancer (expand)"
                "[root] provider[\"registry.terraform.io/yandex-cloud/yandex\"] (close)" -> "[root] yandex_alb_virtual_host.lamp-virtual-host (expand)"
                "[root] provider[\"registry.terraform.io/yandex-cloud/yandex\"] (close)" -> "[root] yandex_lb_network_load_balancer.lamp (expand)"
                "[root] provider[\"registry.terraform.io/yandex-cloud/yandex\"] (close)" -> "[root] yandex_storage_object.picture (expand)"
                "[root] root" -> "[root] provider[\"registry.terraform.io/yandex-cloud/yandex\"] (close)"
                "[root] yandex_alb_backend_group.lamp-group (expand)" -> "[root] yandex_compute_instance_group.alb_lamp_group (expand)"
                "[root] yandex_alb_http_router.router (expand)" -> "[root] provider[\"registry.terraform.io/yandex-cloud/yandex\"]"
                "[root] yandex_alb_load_balancer.lamp-balancer (expand)" -> "[root] yandex_alb_http_router.router (expand)"
                "[root] yandex_alb_load_balancer.lamp-balancer (expand)" -> "[root] yandex_vpc_subnet.public (expand)"
                "[root] yandex_alb_virtual_host.lamp-virtual-host (expand)" -> "[root] yandex_alb_backend_group.lamp-group (expand)"
                "[root] yandex_alb_virtual_host.lamp-virtual-host (expand)" -> "[root] yandex_alb_http_router.router (expand)"
                "[root] yandex_compute_instance_group.alb_lamp_group (expand)" -> "[root] data.yandex_iam_service_account.lamp (expand)"
                "[root] yandex_compute_instance_group.alb_lamp_group (expand)" -> "[root] var.lamp"
                "[root] yandex_compute_instance_group.alb_lamp_group (expand)" -> "[root] var.user_data"
                "[root] yandex_compute_instance_group.alb_lamp_group (expand)" -> "[root] yandex_vpc_subnet.public (expand)"
                "[root] yandex_compute_instance_group.nlb_lamp_group (expand)" -> "[root] data.yandex_iam_service_account.lamp (expand)"
                "[root] yandex_compute_instance_group.nlb_lamp_group (expand)" -> "[root] var.lamp"
                "[root] yandex_compute_instance_group.nlb_lamp_group (expand)" -> "[root] var.user_data"
                "[root] yandex_compute_instance_group.nlb_lamp_group (expand)" -> "[root] yandex_vpc_subnet.public (expand)"
                "[root] yandex_lb_network_load_balancer.lamp (expand)" -> "[root] yandex_compute_instance_group.nlb_lamp_group (expand)"
                "[root] yandex_storage_bucket.hosting (expand)" -> "[root] provider[\"registry.terraform.io/yandex-cloud/yandex\"]"
                "[root] yandex_storage_bucket.hosting (expand)" -> "[root] var.hosting_bucket"
                "[root] yandex_storage_object.picture (expand)" -> "[root] var.picture_path"
                "[root] yandex_storage_object.picture (expand)" -> "[root] yandex_storage_bucket.hosting (expand)"
                "[root] yandex_vpc_network.network (expand)" -> "[root] provider[\"registry.terraform.io/yandex-cloud/yandex\"]"
                "[root] yandex_vpc_network.network (expand)" -> "[root] var.network_name"
                "[root] yandex_vpc_subnet.public (expand)" -> "[root] var.public_network"
                "[root] yandex_vpc_subnet.public (expand)" -> "[root] yandex_vpc_network.network (expand)"
        }
}
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