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
**Answer**

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

        # from man
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
**Answer**

        root@vagrant:~# unshare --pid --fork --mount-proc sleep 30m &
        [1] 6906
        root@vagrant:~# nsenter -a -t 6906
        root@vagrant:/# cat /proc/1/cmdline
        sleep30mroot@vagrant:/#

        # the process with pid #1 has 'sleep 30m' cmdline

        # similar example from man unshare
        root@vagrant:~#  unshare --fork --pid --mount-proc readlink /proc/self
        1

7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?  
**Answer**

        # It's a function which forks itself twice on every iteration (fork bomb).
        # Prettier example: 
        vagrant@vagrant:~$ func(){ func |func& };func
        
        # We can run it and count processes
        vagrant@vagrant:~$ func(){ ps | wc -l; func |func& };func
        4
        [1] 80461
        7
        14
        25
        53
        118
        278
        663
        1727
        3627
        ....

        vagrant@vagrant:~$ dmesg | grep fork
        [  102.457632] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope

        # This is a systemd slice mechanism which limits pid creation by 33% of overall tasks in the system

        vagrant@vagrant:~$ systemctl cat user-1000.slice | grep TasksMax=
        TasksMax=33%

        vagrant@vagrant:~$ systemctl status user-1000.slice
        ● user-1000.slice - User Slice of UID 1000
            Loaded: loaded
            Drop-In: /usr/lib/systemd/system/user-.slice.d
                    └─10-defaults.conf
            Active: active since Fri 2021-11-26 17:58:26 UTC; 9min ago
            Docs: man:user@.service(5)
            Tasks: 7 (limit: 10158)
