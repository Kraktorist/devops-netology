# Домашнее задание к занятию "10.01. Зачем и что нужно мониторить"

## Обязательные задания

1. Вас пригласили настроить мониторинг на проект. На онбординге вам рассказали, что проект представляет из себя 
платформу для вычислений с выдачей текстовых отчетов, которые сохраняются на диск. Взаимодействие с платформой 
осуществляется по протоколу http. Также вам отметили, что вычисления загружают ЦПУ. Какой минимальный набор метрик вы
выведите в мониторинг и почему?

**Answer**

- __мониторинг операционной системы__:
  - процессор:
    - load average
  - память:
    - usage
  - диск:
    - объем данных
    - скорость записи/чтения
    - количество inodes
  - сеть:
    - загруженность интерфейсов
- __мониторинг задействованных сервисов (субд, веб-серверов, файловые хранилища)__:
  - доступность
  - загруженность
  - наличие ошибок
  - время отклика
- __мониторинг приложения__:
  - HTTP-запросы:
    - общее количество запросов
    - количество ошибочных запросов
    - время выполнения запросов
  - операции расчета и вывода данных:
    - количество операций
    - статус операций
    - время исполнения операций

---

2. Менеджер продукта посмотрев на ваши метрики сказал, что ему непонятно что такое RAM/inodes/CPUla. Также он сказал, 
что хочет понимать, насколько мы выполняем свои обязанности перед клиентами и какое качество обслуживания. Что вы 
можете ему предложить?

**Answer**

Нужно уточнить, какие обязательства фигурировали в договоре с клиентами, либо же какой уровень обслуживания декларировался. Затем привести собранные метрики к этим задекларированным индикаторам. Для описанной системы такими индикаторами могут быть:

- доступность системы в процентах;
- время выполнения запрошенной клиентом операции (минимальное, среднее и максимальное)
- допустимый процент ошибок

---

3. Вашей DevOps команде в этом году не выделили финансирование на построение системы сбора логов. Разработчики в свою 
очередь хотят видеть все ошибки, которые выдают их приложения. Какое решение вы можете предпринять в этой ситуации, 
чтобы разработчики получали ошибки приложения?

**Answer**

Ни одно серьезное решение не возможно без бюджета...
- сэкономить на системе логирования можно, если переложить эту задачу на бюджет разработки, заставив программистов переделать код так, чтобы он работал с Sentry и выдавал не только ошибку приложения, но и весь необходимый контекст из других связанных сервисов. 
- Можно также предложить систематизировать ошибки приложения, договорившись, чтобы приложение отдавало определенный error code при возникновении той или иной ошибки. Такой код можно превратить в метрику, и по крайней мере отслеживать количество тех или иных ошибок, а также аномалии в этой величине. Это решение подразумевает, что затраты DevOps ограничатся лишь добавлением некоторого количества новых правил в существующую систему сбора метрик, но тем не менее потребуются затраты на рефакторинг подсистемы логирования в приложении. 
- Можно предложить построить урезанную схему сбора логов. Например,
    - собирать только записи с severity:ERROR;
    - собирать ошибки только с минимального количества необходимых приложений;
    - собирать ошибки не со всех реплик запущенного приложения, а только с ограниченного набора;
    - хранить логи минимально необходимый период времени;
    - настроить алертинг и триггеры, которые бы срабатывали во время ошибки и собирали бы дополнительную информацию.
  Эта схема позволит отлавливать определенный процент ошибок, а также позволит масштабировать схему до полноценной, когда на это будут выделены ресурсы.

---

4. Вы, как опытный SRE, сделали мониторинг, куда вывели отображения выполнения SLA=99% по http кодам ответов. 
Вычисляете этот параметр по следующей формуле: summ_2xx_requests/summ_all_requests. Данный параметр не поднимается выше 
70%, но при этом в вашей системе нет кодов ответа 5xx и 4xx. Где у вас ошибка?

**Answer**

Нужно собрать информацию обо всех имеющихся в логах кодах ответов. Вероятнее всего 30% запросов завершаются с кодами 100-199 (informational) или кодами 300-399 (redirectional), в общем случае не являющимися ошибочными. Их нужно либо добавить в числитель выражения, либо вычесть из знаменателя.

---