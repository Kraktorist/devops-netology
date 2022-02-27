# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

**Answer**

[ Dockerfile ](./Dockerfile)

---
    
[ Docker image](https://hub.docker.com/r/accesshasbeendenied/krakes)

---

```json
{
  "name" : "3db88979f7b7",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "fSMOCP4HSb-fFpG8FVR9xw",
  "version" : {
    "number" : "8.0.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "1b6a7ece17463df5ff54a3e1302d825889aa1161",
    "build_date" : "2022-02-03T16:47:57.507843096Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

**Answer**

[ Queries ](./assets/queries.sh)

    =========List Indices===============
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   ind-1 r_Ri9TXUQ1a017QdiJvEDg   1   0          0            0       225b           225b
    yellow open   ind-3 9okSNiZySjCYyaAYKQD4SA   4   2          0            0       225b           225b
    yellow open   ind-2 83tH6vUhRF2yNzHgHoATUQ   2   1          0            0       225b           225b

    =======Getting Cluster Health=======
    {
    "cluster_name" : "elasticsearch",
    "status" : "yellow",
    "timed_out" : false,
    "number_of_nodes" : 1,
    "number_of_data_nodes" : 1,
    "active_primary_shards" : 9,
    "active_shards" : 9,
    "relocating_shards" : 0,
    "initializing_shards" : 0,
    "unassigned_shards" : 10,
    "delayed_unassigned_shards" : 0,
    "number_of_pending_tasks" : 0,
    "number_of_in_flight_fetch" : 0,
    "task_max_waiting_in_queue_millis" : 0,
    "active_shards_percent_as_number" : 47.368421052631575
    }

---
    The cluster is in yellow state because it's not fault tolerant due to the only one node is added.
    Some indices are in yellow state because there are no available nodes to allocate all required shards for them.


## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

**Answer**

[ Queries ](./assets/repo.sh)

    =========Create Repository==========
        curl -k -u ${ES_USERNAME}:${ES_PASSWORD} -X PUT "https://localhost:9200/_snapshot/netology_backup?pretty"
            -H "Content-Type: application/json" -d'
            {
            "type": "fs",
            "settings": {
                "location": "'/var/lib/elasticsearch/snapshots'"
            }
            }
            '
    {
    "acknowledged" : true
    }

    sh-4.2$ ls -la /var/lib/elasticsearch/snapshots/
    total 32
    drwxr-xr-x 3 elasticsearch elasticsearch   134 Feb 27 10:44 .
    drwxr-xr-x 1 elasticsearch elasticsearch    61 Feb 27 10:44 ..
    -rw-r--r-- 1 elasticsearch elasticsearch  1094 Feb 27 10:44 index-0
    -rw-r--r-- 1 elasticsearch elasticsearch     8 Feb 27 10:44 index.latest
    drwxr-xr-x 5 elasticsearch elasticsearch    96 Feb 27 10:44 indices
    -rw-r--r-- 1 elasticsearch elasticsearch 17605 Feb 27 10:44 meta-S6r-rDm_RlOKTIaQFx_AuQ.dat
    -rw-r--r-- 1 elasticsearch elasticsearch   384 Feb 27 10:44 snap-S6r-rDm_RlOKTIaQFx_AuQ.dat

    =========List Indices===============
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test  ccMI4NauRZiPd_7vu9ex5g   1   0          0            0       225b           225b

    =========Restore Snapshot============
    curl -k -u ${ES_USERNAME}:${ES_PASSWORD} -X POST "https://localhost:9200/_snapshot/netology_backup/snapshot1/_restore?wait_for_completion=true&pretty"
    {
    "snapshot" : {
        "snapshot" : "snapshot1",
        "indices" : [
        "test"
        ],
        "shards" : {
        "total" : 1,
        "failed" : 0,
        "successful" : 1
        }
    }
    }

    =========List Indices===============
    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test-2 F1XHTH-JSXKwaHju0tckAg   1   0          0            0       225b           225b
    green  open   test   dBq9DCmdTdykWwdCZkbPmA   1   0          0            0       225b           225b
