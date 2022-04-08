# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   
1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    * Какая максимальная длина имени? 
    * Какому регулярному выражению должно подчиняться имя? 

---
**Answer**

1. [ Resources ](https://github.com/hashicorp/terraform-provider-aws/blob/341ef9448ff56250ca3ed9d6b69600d42f4251b6/internal/provider/provider.go#L867-L1984)  
[Datasources](https://github.com/hashicorp/terraform-provider-aws/blob/341ef9448ff56250ca3ed9d6b69600d42f4251b6/internal/provider/provider.go#L412-L865) 
1. 
   * `name` конфликтует с `name_prefix` ([source](https://github.com/hashicorp/terraform-provider-aws/blob/6e6e4bed78f29b0addd5b33fd733b67f85bb4dc3/internal/service/sqs/queue.go#L87))  
   * Максимальная длина имени очереди равна 80 символам. Имя представляет из себя комбинацию `name_prefix`, `name`, к которым может быть добавлен суффикс ".fifo" ([source](https://github.com/hashicorp/terraform-provider-aws/blob/6e6e4bed78f29b0addd5b33fd733b67f85bb4dc3/internal/service/sqs/queue.go#L424-L432))
   * Вид регулярного выражения зависит от значения атрибута `fifo_queue`. Если этот параметр имеет значение "true", то для проверки используется регулярное выражение:  
        ```golang
        `^[a-zA-Z0-9_-]{1,75}\.fifo$`
        ```  
     в ином случае:   
        ```golang
        `^[a-zA-Z0-9_-]{1,80}$`
        ```  

## Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   

---
**Answer**

1. \---
2. [Cloned repo](https://github.com/Kraktorist/terraform-provider-hashicups)
3. ![answer2](img/answer2.png)