
# Домашнее задание к занятию "11.02 Микросервисы: принципы"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- Маршрутизация запросов к нужному сервису на основе конфигурации
- Возможность проверки аутентификационной информации в запросах
- Обеспечение терминации HTTPS

Обоснуйте свой выбор.

**Answer**

Некоторый исходный список ПО, реализующего функционал API Gateways, можно получить со страницы [CNCF Landscape](https://landscape.cncf.io/guide#orchestration-management--api-gateway).
Помимо указанных self-hosted решений существует множество SaaS продуктов, предлагаемых в составе публичных облаков или отдельных сервисов. Например, подобные есть в AWS, Azure, Alibaba Cloud, Oracle Cloud, F5 Network итд. 


| Name      | Routing on config |   Auth    |  HTTPS Termination |
| :---:     |    :---:          |     :---: | :---:              |
| [emissary-ingress](https://github.com/emissary-ingress/emissary) | + | +<sup>[1]</sup> | +<sup>[1]</sup>  |
| [apache/apisix](https://github.com/apache/apisix) | + | + | + |
| [megaease/easegress](https://github.com/megaease/easegress) | + | + | + |
| [solo-io/gloo](https://github.com/solo-io/gloo) | + | + | + |
| [kong](https://github.com/Kong/kong) | + | + | + |
| [krakend](https://github.com/luraproject/lura) | + | + | + |
| [reactive-interaction-gateway](https://github.com/accenture/reactive-interaction-gateway) | + | + | + |
| [tyk](https://github.com/TykTechnologies/tyk) | + | + | + |
| [wso2](https://github.com/wso2/product-microgateway) | + | + | + |
| [gravitee](https://github.com/gravitee-io/gravitee-api-management) | + | + | + |

<sup>[1]</sup>: с использованием дополнительного микросервиса, реализующего требуемый функционал.

Опираясь на собранные данные можно рассмотреть выбор из `gravitee` (по широкому набору критерием из [этой статьи](https://habr.com/ru/post/665558/)), `kong` (наибольшее сообщество), `Apache Apisix` (проект под крылом известной компании), `tyk`. С использованием выбранных продуктов можно провести PoC, по результатам которого и выбрать необходимое решение.

---

## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- Поддержка кластеризации для обеспечения надежности
- Хранение сообщений на диске в процессе доставки
- Высокая скорость работы
- Поддержка различных форматов сообщений
- Разделение прав доступа к различным потокам сообщений
- Простота эксплуатации

Обоснуйте свой выбор.

**Answer**

Пользуясь тем же подходом, воспользуемся списком из [этой статьи CNCF](https://landscape.cncf.io/guide#app-definition-and-development--streaming-messaging).

| Name      | Cluster |   Persistance    |  Speed | Multiformat | ACLs | Adm. overhead |
| :---:     |  :---:  |     :---:        | :---:  |      :---:  | :--: |        :---:  |
| [nats](https://github.com/nats-io/nats-server) | + | + | fast | custom | + | + |
| [Apache RocketMQ](https://github.com/apache/rocketmq) | + | + | average | TCP, JMS, OpenMessaging | + | + |
| [EMQX](https://github.com/emqx/emqx) | + | + | average | MQTT | + | + |
| [Apache kafka](https://github.com/apache/kafka) | + | + | fast | custom | + | - |
| [kubemq](https://github.com/kubemq-io/kubemq-community) | + | + | fast | custom | + | + |
| [Apache pulsar](https://github.com/apache/pulsar) | + | + | average | custom | + | + |
| [rabbitmq](https://github.com/rabbitmq/rabbitmq-server) | + | + | average | STOMP, AMQP, MQTT | + | + |
| [Apache ActiveMQ](https://github.com/apache/activemq) | + | + | average | OpenWire, STOMP, AMQP, MQTT, JMS | + | + |
| [redis](https://github.com/redis/redis) | + | + | average | custom | + | + |

При выборе решения придется балансировать между производительностью и функциональностью. Наилучшие результаты в бенчмарках показывают брокеры, использующие собственные протоколы. Среди наиболее производительных можно выделить `kafka` (наиболее популярен) и `nats`.  Однако оба этих проекта используют собственные протоколы. Следует отметить, что `kafka` сложнее в эксплуатации, поскольку для работы использует `zookeeper`.  
Среди мультипротокольных решений можно выделить `activemq`, `rocketmq`, `rabbitmq`. В зависимости от архитектуры, требующихся функций и выбранного формата сообщений каждый из них может показать хорошие результаты. 

Дополнительная информация:
- https://ultimate-comparisons.github.io/ultimate-message-broker-comparison/
- https://digitalscholarship.unlv.edu/cgi/viewcontent.cgi?article=4749&context=thesesdissertations

---

<details>

## Задача 3: API Gateway * (необязательная)

__<summary>Условие задачи</summary>__

### Есть три сервиса:

**minio**
- Хранит загруженные файлы в бакете images
- S3 протокол

**uploader**
- Принимает файл, если он картинка сжимает и загружает его в minio
- POST /v1/upload

**security**
- Регистрация пользователя POST /v1/user
- Получение информации о пользователе GET /v1/user
- Логин пользователя POST /v1/token
- Проверка токена GET /v1/token/validation

### Необходимо воспользоваться любым балансировщиком и сделать API Gateway:

**POST /v1/register**
- Анонимный доступ.
- Запрос направляется в сервис security POST /v1/user

**POST /v1/token**
- Анонимный доступ.
- Запрос направляется в сервис security POST /v1/token

**GET /v1/user**
- Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
- Запрос направляется в сервис security GET /v1/user

**POST /v1/upload**
- Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
- Запрос направляется в сервис uploader POST /v1/upload

**GET /v1/user/{image}**
- Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
- Запрос направляется в сервис minio  GET /images/{image}

### Ожидаемый результат

Результатом выполнения задачи должен быть docker compose файл запустив который можно локально выполнить следующие команды с успешным результатом.
Предполагается что для реализации API Gateway будет написан конфиг для NGinx или другого балансировщика нагрузки который будет запущен как сервис через docker-compose и будет обеспечивать балансировку и проверку аутентификации входящих запросов.
Авторизация
curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/token

**Загрузка файла**

curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @yourfilename.jpg http://localhost/upload

**Получение файла**
curl -X GET http://localhost/images/4e6df220-295e-4231-82bc-45e4b1484430.jpg

---

#### [Дополнительные материалы: как запускать, как тестировать, как проверить](https://github.com/netology-code/devkub-homeworks/tree/main/11-microservices-02-principles)

</details>

___  

**Answers**

[docker-compose](assets/docker-compose.yaml)

[conf.d/nginx.conf](assets/gateway/nginx.conf)

[autotest](assets/tests/entrypoint.sh) запускается в контейнере testresult

```console
user@host:~/repos/$ docker-compose up --build
...
assets-security-1       | 172.28.0.4 - - [07/Aug/2022 17:18:03] "POST /v1/token HTTP/1.0" 200 -
assets-testresult-1     | Token: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I
assets-security-1       | 172.28.0.4 - - [07/Aug/2022 17:18:03] "GET /v1/token/validation HTTP/1.0" 200 -
assets-security-1       | 172.28.0.4 - - [07/Aug/2022 17:18:03] "GET /v1/user HTTP/1.0" 200 -
assets-testresult-1     | User status: {"user":"Authorized"}
assets-testresult-1     | Uploading picture
assets-security-1       | 172.28.0.4 - - [07/Aug/2022 17:18:04] "GET /v1/token/validation HTTP/1.0" 200 -
assets-uploader-1       | Detected file type: image/jpeg
assets-uploader-1       | Saved file: 5d6b48b0-aef0-48c6-bc7b-1fb4bd39b432.jpg
assets-testresult-1     | Picture path: 5d6b48b0-aef0-48c6-bc7b-1fb4bd39b432.jpg
assets-testresult-1     | Downloading and checking picture: 
assets-security-1       | 172.28.0.4 - - [07/Aug/2022 17:18:04] "GET /v1/token/validation HTTP/1.0" 200 -
assets-testresult-1     | picture.jpg: OK
assets-testresult-1 exited with code 0
```