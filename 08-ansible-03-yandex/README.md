# Домашнее задание к занятию "08.03 Использование Yandex Cloud"

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

<details>
<summary>Задание</summary>

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
4. Приготовьте свой собственный inventory файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.
</details>


**Answers**


**[playbook location](assets/playbook/)**

## Infrastructure

![Infrastructure](assets/infrastructure.png "Infrastructure")

Инфраструктура состоит из трех хостов, развернутых в Яндекс облаке с помощью [terraform манифеста](assets/main.tf). Указанный манифест не только создает машины, но также формирует inventory-файл для ansible.

1. Сервер `clickhouse-01` для сбора логов.
2. Сервер `vector-01`, генерирующий и обрабатывающий логи.
3. Сервер `lighthouse-01` - веб-интерфейс для `clickhouse-01`

## Playbook

Playbook производит развертывание необходимых приложений на указанные сервера. Для простоты деплоя все хосты сделаны доступными через интернет. 

- ### Clickhouse

  - установка `clickhouse`
  - настройка удаленных подключений к приложению
  - создание базы данных и таблицы в ней


- ### Vector

  - установка `vector`
  - изменение конфига приложения для отправки логов на сервер `clickhouse-01`

- ### Lighthouse

  - установка `lighthouse`
  - настройка `nginx`

## Variables

Через group_vars можно задать следующие параметры:
- `clickhouse_version`, `vector_installer_url`, `lighthouse_distrib` - версии устанавливаемых приложений;
- `clickhouse_database_name` - имя базы данных для хранения логов;
- `clickhouse_create_table` - структуру таблицы для хранения логов;
- `vector_config` - содержимое конфигурационного файла для приложения `vector`;
- блок конфигурации `nginx` для работы с `lighthouse`;

## Tags

- `clickhouse` производит полную конфигурацию сервера `clickhouse-01`;
- `clickhouse_db` производит конфигурацию базы данных и таблицы;
- `vector` производит полную конфигурацию сервера `vector-01`;
- `vector_config` производит изменение в конфиге приложения `vector`;
- `lighthouse` производит установку `lighthouse`.
- `drop_clickhouse_database_logs` удаляет базу данных (по умолчанию не выполняется);