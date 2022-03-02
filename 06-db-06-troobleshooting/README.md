# Домашнее задание к занятию "6.6. Troubleshooting"

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её 
нужно прервать. 

Вы как инженер поддержки решили произвести данную операцию:
- напишите список операций, которые вы будете производить для остановки запроса пользователя
- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB

**Answer**

[killOp command example](https://docs.mongodb.com/manual/reference/method/db.killOp/#sharded-cluster)
1. Open mongosh console
2. Run the script which finds and stops slow operations
```javascript
use admin
db.currentOp().inprog.forEach(
  function(op) {
    if(op.secs_running > 180) {
        print(op.opid);
        db.killOp(op.opid);
    }
  }
)
```
---
```javascript
// enabling slow queries profiling
db.getProfilingStatus()
db.setProfilingLevel( 1, { filter: { op: "query", millis: { $gt: 1000 } } } ) 

// search slow queries
db.system.profile.find({ millis: { $gt: 1000 }}).pretty();

// analyze slow queries 
db.myCollections.explain("executionStats") 
  .find( { $where: function() { return sleep(100000) || true }})
  .pretty()

// create index for optimizing requests
db.collection.createIndex( { name: -1 } ) 
// recreate index for refreshing them
db.collection.reIndex() 
```
`mongotop` and `mongostat` - server performance utilities


## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. 
Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса. 

При масштабировании сервиса до N реплик вы увидели, что:
- сначала рост отношения записанных значений к истекшим
- Redis блокирует операции записи

Как вы думаете, в чем может быть проблема?
 
 **Answer**

>The issue is described [here](https://redis.io/topics/latency#:~:text=Latency%20generated%20by%20expires): if the database has many many keys expiring in the same second, and these make up at least 25% of the current population of keys with an expire set, Redis can block in order to get the percentage of keys already expired below 25%.
    
## Задача 3

Перед выполнением задания познакомьтесь с документацией по [Common Mysql errors](https://dev.mysql.com/doc/refman/8.0/en/common-errors.html).

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы,
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?

Какие пути решения данной проблемы вы можете предложить?

**Answer**

>Common errors related to losing connection to MySQL server are described [in this article](https://dev.mysql.com/doc/refman/8.0/en/error-lost-connection.html).
There are three typical cases related to our issue:
>1. Poor network connection.
>2. The queries slower than `net_read_timeout`.
>3. The results are bigger than `max_allowed_packet`.  
>     
>To investigate the issue:
> 1. make sure that the network connection is stable and doesn't have any bottlenecks.
> 2. identify slow queries with `show processlist;` and by logging them to the further analyzing;
> 3. determine response size by replaying real queries;
>
> Depending on the results we could do one of the following:
> - fix the network;
> - increase `net_read_timeout`;
> - increase `max_allowed_packet`;
> - optimize sql queries;
> - refactor the application;


## Задача 4

Перед выполнением задания ознакомтесь со статьей [Common PostgreSQL errors](https://www.percona.com/blog/2020/06/05/10-common-postgresql-errors/) из блога Percona.

Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
большим объемом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

Как вы думаете, что происходит?

Как бы вы решили данную проблему?

**Answer**

    4