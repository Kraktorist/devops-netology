# Домашнее задание к занятию "8.4 Работа с Roles"

## Подготовка к выполнению
1. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
2. Добавьте публичную часть своего ключа к своему профилю в github.

<details>
<summary>Задание</summary>

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачать себе эту роль.
3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Описать в `README.md` обе роли и их параметры.
7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.
</details>

**Answers**

[vector-role](https://github.com/Kraktorist/devops-netology/tree/vector-role)
[lighthouse-role](https://github.com/Kraktorist/devops-netology/tree/lighthouse-role)
[playbook](./assets/site.yml)

[vagrant infrastructure](./assets/Vagrantfile)
[yandex.cloud infrastructure](./assets/terraform/)

Инфраструктура состоит из трех хостов:
- clickhouse-01
- vector-01
- lighthouse-01

развернутых либо с помощью vagrant, либо с помощью terraform. В последнем случае terraform манифест создает также файл инвентаризации для ansible.

Ansible разворачивает на хостах приложения:
- `clickhouse`
  Разворачивается с помощью одноименной роли `clickhouse` из публичного репозитория [ansible-clickhouse](https://github.com/AlexeySetevoi/ansible-clickhouse.git) 
- `vector`
  разворачивается с помощью роли `vector-role` из ветки vector-role этого же репозитория
- `lighthouse`
  разворачивается с помощью роли `lighthouse-role` из ветки lighthouse-role этого же репозитория. В качестве зависимости `lighthouse-role` использует роль `geerlingguy.nginx` для установки nginx и настройки vhost.