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

    3

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
 
Подсказк - используйте директиву `UPDATE`.

**Answer**

    4

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

    6