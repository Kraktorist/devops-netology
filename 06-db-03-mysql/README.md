# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](./06-db-03-mysql/test_data/test_dump.sql) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

**Answer**

    root@1173904d6d5d:/# mysql --user=root --password mysql

---

    mysql> \s
    --------------
    mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

    Connection id:		14
    Current database:	mysql
    Current user:		root@localhost
    SSL:			Not in use
    Current pager:		stdout
    Using outfile:		''
    Using delimiter:	;
    Server version:		8.0.28 MySQL Community Server - GPL

---

    root@1173904d6d5d:/# mysql --user=root --password test_db</backup/test_dump.sql
    root@1173904d6d5d:/# mysql --user=root --password test_db 

---
    mysql> show tables;
    +-------------------+
    | Tables_in_test_db |
    +-------------------+
    | orders            |
    +-------------------+
    1 row in set (0.00 sec)

    mysql> select count(*) from orders where price>300;
    +----------+
    | count(*) |
    +----------+
    |        1 |
    +----------+
    1 row in set (0.01 sec)


## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привилегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

**Answer**

[CREATING USER SQL](./assets/answer2.sql)

    mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
    +------+------+---------------------------------------+
    | USER | HOST | ATTRIBUTE                             |
    +------+------+---------------------------------------+
    | test | %    | {"fname": "James", "lname": "Pretty"} |
    +------+------+---------------------------------------+
    1 row in set (0.00 sec)



## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

**Answer**

    mysql> SHOW TABLE STATUS;
    +--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
    | Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
    +--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
    | orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-02-23 17:22:10 | 2022-02-23 17:22:10 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
    +--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
    1 row in set (0.01 sec)

---

    mysql> SHOW PROFILES;
    +----------+------------+------------------------------------------------------------------+
    | Query_ID | Duration   | Query                                                            |
    +----------+------------+------------------------------------------------------------------+
    |       58 | 0.00005425 | /*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */                 |
    |       59 | 0.00007100 | /*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */   |
    |       60 | 0.00008900 | /*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */ |
    |       61 | 0.00007275 | /*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */   |
    |       62 | 0.00008425 | /*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */                         |
    |       63 | 0.00095225 | SHOW ENGINE INNODB STATUS                                        |
    |       64 | 0.00014825 | SHOW PROFILE 52                                                  |
    |       65 | 0.00105100 | SELECT * FROM orders                                             |
    |       66 | 0.00216225 | show tables                                                      |
    |       67 | 0.00015425 | show tables orders                                               |
    |       68 | 0.00017325 | show table orders                                                |
    |       69 | 0.01060850 | SHOW TABLE STATUS                                                |
    |       70 | 0.00053800 | select * from orders                                             |
    |       71 | 0.05980525 | alter table orders ENGINE=MyISAM                                 |
    |       72 | 0.00076175 | select * from orders                                             |
    +----------+------------+------------------------------------------------------------------+
    15 rows in set, 1 warning (0.00 sec)

---

    mysql> SHOW PROFILE FOR QUERY 70;
    +--------------------------------+----------+
    | Status                         | Duration |
    +--------------------------------+----------+
    | starting                       | 0.000125 |
    | Executing hook on transaction  | 0.000015 |
    | starting                       | 0.000016 |
    | checking permissions           | 0.000015 |
    | Opening tables                 | 0.000060 |
    | init                           | 0.000016 |
    | System lock                    | 0.000019 |
    | optimizing                     | 0.000013 |
    | statistics                     | 0.000028 |
    | preparing                      | 0.000033 |
    | executing                      | 0.000083 |
    | end                            | 0.000012 |
    | query end                      | 0.000009 |
    | waiting for handler commit     | 0.000018 |
    | closing tables                 | 0.000019 |
    | freeing items                  | 0.000035 |
    | cleaning up                    | 0.000023 |
    +--------------------------------+----------+
    17 rows in set, 1 warning (0.00 sec)

    mysql> SHOW PROFILE FOR QUERY 72;
    +--------------------------------+----------+
    | Status                         | Duration |
    +--------------------------------+----------+
    | starting                       | 0.000162 |
    | Executing hook on transaction  | 0.000018 |
    | starting                       | 0.000023 |
    | checking permissions           | 0.000022 |
    | Opening tables                 | 0.000130 |
    | init                           | 0.000018 |
    | System lock                    | 0.000029 |
    | optimizing                     | 0.000015 |
    | statistics                     | 0.000032 |
    | preparing                      | 0.000042 |
    | executing                      | 0.000149 |
    | end                            | 0.000015 |
    | query end                      | 0.000018 |
    | closing tables                 | 0.000022 |
    | freeing items                  | 0.000042 |
    | cleaning up                    | 0.000027 |
    +--------------------------------+----------+
    16 rows in set, 1 warning (0.00 sec)



## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

**Answer**
    [mysqld]
    pid-file        = /var/run/mysqld/mysqld.pid
    socket          = /var/run/mysqld/mysqld.sock
    datadir         = /var/lib/mysql
    secure-file-priv= NULL

    innodb_flush_log_at_trx_commit = 2      # Скорость IO важнее сохранности данных
    innodb_flush_log_at_trx_commit = 0      # if ACID is not required
    query_cache_size = 0
    innodb_flush_method = O_DSYNC
    innodb_file_per_table = 1               # Нужна компрессия таблиц для экономии места на диске
    innodb_log_buffer_size = 1M             # Размер буфера с незакомиченными транзакциями 1 Мб
    innodb_buffer_pool_size = 1G            # Буфер кеширования 30% от ОЗУ
    innodb_log_file_size = 100M             # Размер файла логов операций 100 Мб
