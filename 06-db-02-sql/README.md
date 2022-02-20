# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.


**Answer**  

    [docker-compose.yml](docker-compose.yml)

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

**Answer**  

[SQL file](answer2.sql)

    test_db=# \l
                                    List of databases
    Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    -----------+----------+----------+------------+------------+-----------------------
    postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
              |          |          |            |            | postgres=CTc/postgres
    template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
              |          |          |            |            | postgres=CTc/postgres
    test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    (4 rows)

---
    test_db=# \d orders
                                Table "public.orders"
        Column    |  Type   | Collation | Nullable |              Default               
    --------------+---------+-----------+----------+------------------------------------
    id           | integer |           | not null | nextval('orders_id_seq'::regclass)
    наименование | text    |           | not null | 
    цена         | integer |           | not null | 
    Indexes:
        "orders_pkey" PRIMARY KEY, btree (id)
    Referenced by:
        TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

---
    test_db=# \d clients
                                    Table "public.clients"
        Column       |  Type   | Collation | Nullable |               Default               
    -------------------+---------+-----------+----------+-------------------------------------
    id                | integer |           | not null | nextval('clients_id_seq'::regclass)
    фамилия           | text    |           | not null | 
    страна проживания | text    |           |          | 
    заказ             | integer |           |          | 
    Indexes:
        "clients_pkey" PRIMARY KEY, btree (id)
        "country" btree ("страна проживания")
    Foreign-key constraints:
        "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
---
    test_db=# SELECT grantee, table_name, privilege_type
    test_db-# FROM information_schema."role_table_grants"
    test_db-# WHERE "table_name" in ('orders', 'clients');
        grantee      | table_name | privilege_type 
    ------------------+------------+----------------
    postgres         | orders     | INSERT
    postgres         | orders     | SELECT
    postgres         | orders     | UPDATE
    postgres         | orders     | DELETE
    postgres         | orders     | TRUNCATE
    postgres         | orders     | REFERENCES
    postgres         | orders     | TRIGGER
    test-admin-user  | orders     | INSERT
    test-admin-user  | orders     | SELECT
    test-admin-user  | orders     | UPDATE
    test-admin-user  | orders     | DELETE
    test-admin-user  | orders     | TRUNCATE
    test-admin-user  | orders     | REFERENCES
    test-admin-user  | orders     | TRIGGER
    test-simple-user | orders     | INSERT
    test-simple-user | orders     | SELECT
    test-simple-user | orders     | UPDATE
    test-simple-user | orders     | DELETE
    postgres         | clients    | INSERT
    postgres         | clients    | SELECT
    postgres         | clients    | UPDATE
    postgres         | clients    | DELETE
    postgres         | clients    | TRUNCATE
    postgres         | clients    | REFERENCES
    postgres         | clients    | TRIGGER
    test-admin-user  | clients    | INSERT
    test-admin-user  | clients    | SELECT
    test-admin-user  | clients    | UPDATE
    test-admin-user  | clients    | DELETE
    test-admin-user  | clients    | TRUNCATE
    test-admin-user  | clients    | REFERENCES
    test-admin-user  | clients    | TRIGGER
    test-simple-user | clients    | INSERT
    test-simple-user | clients    | SELECT
    test-simple-user | clients    | UPDATE
    test-simple-user | clients    | DELETE
    (36 rows)

---
    test_db=# \dp
                                            Access privileges
    Schema |      Name      |   Type   |         Access privileges          | Column privileges | Policies 
    --------+----------------+----------+------------------------------------+-------------------+----------
    public | clients        | table    | postgres=arwdDxt/postgres         +|                   | 
           |                |          | "test-admin-user"=arwdDxt/postgres+|                   | 
           |                |          | "test-simple-user"=arwd/postgres   |                   | 
    public | clients_id_seq | sequence |                                    |                   | 
    public | orders         | table    | postgres=arwdDxt/postgres         +|                   | 
           |                |          | "test-admin-user"=arwdDxt/postgres+|                   | 
           |                |          | "test-simple-user"=arwd/postgres   |                   | 
    public | orders_id_seq  | sequence |                                    |                   | 
    (4 rows)



## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

**Answer**  

[SQL file](answer3.sql)

---
    test_db=# SELECT count(id) FROM orders;
    count 
    -------
        5
    (1 row)

    test_db=# SELECT count(id) FROM clients;
    count 
    -------
        5
    (1 row)


## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказка - используйте директиву `UPDATE`.

**Answer**

[Update SQL file](answer4.sql)

---
    test_db=# SELECT * FROM clients where "заказ" IS NOT NULL;
    id |       фамилия        | страна проживания | заказ 
    ----+----------------------+-------------------+-------
    1 | Иванов Иван Иванович | USA               |     3
    2 | Петров Петр Петрович | Canada            |     4
    3 | Иоганн Себастьян Бах | Japan             |     5
    (3 rows)
---
    test_db=# 
    test_db=# SELECT * FROM clients
    test_db-# INNER JOIN orders on clients."заказ"=orders.id;
    id |       фамилия        | страна проживания | заказ | id | наименование | цена 
    ----+----------------------+-------------------+-------+----+--------------+------
    1 | Иванов Иван Иванович | USA               |     3 |  3 | Книга        |  500
    2 | Петров Петр Петрович | Canada            |     4 |  4 | Монитор      | 7000
    3 | Иоганн Себастьян Бах | Japan             |     5 |  5 | Гитара       | 4000
    (3 rows)


## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

**Answer**

    5

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

**Answer**

    $ echo 'backuping database'
    $ sudo docker exec -ti 77792eb99a09 bash
    $ pg_dump -U postgres test_db>/postgres_backup/test_db.sql
    $ exit
    $ echo 'creating new container with Postgres'
    $ sudo docker run --rm --name postgres -dt \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres  \
    -v /docker_volumes/postgres_backup:/postgres_backup \
    postgres:12-alpine
    $ sudo docker exec -ti postgres bash
    $ echo 'restoring database'
    $ createdb -U postgres test_db
    $ createuser -U postgres "test-admin-user"
    $ createuser -U postgres "test-simple-user"
    $ psql -U postgres test_db</postgres_backup/test_db.sql