# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

**Answer**

    \l          # вывода списка БД
    \c          # подключения к БД
    \dt *.*     # вывода списка таблиц
    \d *.*      # вывода описания содержимого таблиц
    \q          # выхода из psql

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

**Answer**

    test_database=# SELECT attname from pg_catalog.pg_stats
    test_database-# WHERE tablename = 'orders' 
    test_database-# ORDER BY avg_width desc 
    test_database-# LIMIT 1;
    attname 
    ---------
    title
    (1 row)


## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

**Answer**

    ```sql
    BEGIN;

        CREATE TABLE public.orders_2 (
            CHECK(price<=499)
        ) INHERITS(orders);

        CREATE TABLE public.orders_1 (
            CHECK(price>499)
        ) INHERITS(orders);

        INSERT INTO public.orders_2 
        SELECT * FROM public.orders 
        WHERE price<=499;
        DELETE FROM ONLY public.orders
        WHERE price<=499;

        INSERT INTO public.orders_1 
        SELECT * FROM public.orders 
        WHERE price>499;
        DELETE FROM ONLY public.orders
        WHERE price>499;

        CREATE RULE orders_insert_less_or_equal_499 AS ON INSERT TO public.orders
        WHERE (price<=499)
        DO INSTEAD INSERT INTO public.orders_2 VALUES (NEW.*);

        CREATE RULE orders_insert_bigger_499 AS ON INSERT TO public.orders
        WHERE (price>499)
        DO INSTEAD INSERT INTO public.orders_1 VALUES (NEW.*);

        ALTER TABLE public.orders_1 OWNER TO postgres;
        ALTER TABLE public.orders_2 OWNER TO postgres;
    END;
    ```
---

    Да, можно было изначально заложить шардинг теми же запросами.


## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

**Answer**

    ```sql
    CREATE TABLE public.orders (
        id integer NOT NULL,
        title character varying(80) NOT NULL UNIQUE,
        price integer DEFAULT 0
    );
    ```