# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:  
  
    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.  
  
**Answer**  
  
        root@vagrant:/etc/systemd/system# systemctl cat node_exporter.service
        # /etc/systemd/system/node_exporter.service
        [Unit]
        Description=node_exporter daemon

        [Service]
        EnvironmentFile=-/etc/default/node_exporter
        ExecStart=/usr/sbin/node_exporter $EXTRA_OPTS

        [Install]
        WantedBy=multi-user.target
        root@vagrant:/etc/systemd/system# systemctl status node_exporter
        ● node_exporter.service - node_exporter daemon
            Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
            Active: active (running) since Thu 2021-11-25 17:54:37 UTC; 4min 5s ago
        Main PID: 1390 (node_exporter)
            Tasks: 4 (limit: 4617)
            Memory: 5.2M
            CGroup: /system.slice/node_exporter.service
                    └─1390 /usr/sbin/node_exporter

        Nov 25 17:54:37 vagrant node_exporter[1390]: ts=2021-11-25T17:54:37.791Z caller=node_exporter.go:115 level=info collector=thermal_zone
        Nov 25 17:54:37 vagrant node_exporter[1390]: ts=2021-11-25T17:54:37.791Z caller=node_exporter.go:115 level=info collector=time
        Nov 25 17:54:37 vagrant node_exporter[1390]: ts=2021-11-25T17:54:37.791Z caller=node_exporter.go:115 level=info collector=timex
        Nov 25 17:54:37 vagrant node_exporter[1390]: ts=2021-11-25T17:54:37.791Z caller=node_exporter.go:115 level=info collector=udp_queues
        .......
        root@vagrant:/etc/systemd/system# curl http://localhost:9100/metrics
        # HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
        # TYPE go_gc_duration_seconds summary
        go_gc_duration_seconds{quantile="0"} 0
        go_gc_duration_seconds{quantile="0.25"} 0
        go_gc_duration_seconds{quantile="0.5"} 0
        go_gc_duration_seconds{quantile="0.75"} 0
        go_gc_duration_seconds{quantile="1"} 0
  
2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.  
**Answer**

        root@vagrant:/etc/systemd/system# cat /etc/default/node_exporter
        EXTRA_OPTS="--collector.disable-defaults \
                    --collector.cpu \
                    --collector.diskstats \
                    --collector.filesystem \
                    --collector.loadavg \
                    --collector.meminfo \
                    --collector.netstat \
                    --collector.netdev"



3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?  
**Answer**  

        # Yes.
        vagrant@vagrant:~$ dmesg | grep virt
        [    0.001143] CPU MTRRs all blank - virtualized system.
        [    0.069898] Booting paravirtualized kernel on KVM
        [    2.422920] systemd[1]: Detected virtualization oracle.


5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?  
**Answer**

        vagrant@vagrant:~$ sysctl fs.nr_open
        fs.nr_open = 1048576


        # nr_open:
        # 
        # This denotes the maximum number of file-handles a process can
        # allocate. Default value is 1024*1024 (1048576) which should be
        # enough for most machines. Actual limit depends on RLIMIT_NOFILE
        # resource limit.

        vagrant@vagrant:~$ ulimit -n
        1024
        vagrant@vagrant:~$ cat /proc/self/limits | grep -E 'Limit|open files'
        Limit                     Soft Limit           Hard Limit           Units
        Max open files            1024                 1048576              files



6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.



7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

 
 ---

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Также вы можете выполнить задание в [Google Docs](https://docs.google.com/document/u/0/?tgif=d) и отправить в личном кабинете на проверку ссылку на ваш документ.
Название файла Google Docs должно содержать номер лекции и фамилию студента. Пример названия: "1.1. Введение в DevOps — Сусанна Алиева".

Если необходимо прикрепить дополнительные ссылки, просто добавьте их в свой Google Docs.

Перед тем как выслать ссылку, убедитесь, что ее содержимое не является приватным (открыто на комментирование всем, у кого есть ссылка), иначе преподаватель не сможет проверить работу. Чтобы это проверить, откройте ссылку в браузере в режиме инкогнито.

[Как предоставить доступ к файлам и папкам на Google Диске](https://support.google.com/docs/answer/2494822?hl=ru&co=GENIE.Platform%3DDesktop)

[Как запустить chrome в режиме инкогнито ](https://support.google.com/chrome/answer/95464?co=GENIE.Platform%3DDesktop&hl=ru)

[Как запустить  Safari в режиме инкогнито ](https://support.apple.com/ru-ru/guide/safari/ibrw1069/mac)

Любые вопросы по решению задач задавайте в чате Slack.

---
