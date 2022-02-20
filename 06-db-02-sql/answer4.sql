UPDATE clients SET "заказ"=subquery.id
FROM (SELECT id from orders where orders."наименование" = 'Книга') as subquery
WHERE "фамилия"='Иванов Иван Иванович';

UPDATE clients SET "заказ"=subquery.id
FROM (SELECT id from orders where orders."наименование" = 'Монитор') as subquery
WHERE "фамилия"='Петров Петр Петрович';

UPDATE clients SET "заказ"=subquery.id
FROM (SELECT id from orders where orders."наименование" = 'Гитара') as subquery
WHERE "фамилия"='Иоганн Себастьян Бах';
