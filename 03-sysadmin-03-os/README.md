# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.  
**Answer** 

        vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep tmp
        execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffc8cfcfb10 /* 24 vars */) = 0
        stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
        chdir("/tmp")                           = 0

        vagrant@vagrant:~$ strace -e trace=chdir /bin/bash -c 'cd /tmp'
        chdir("/tmp")                           = 0
        +++ exited with 0 +++



1. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.  
**Answer**

        # we need to get all openat() calls used by file

        vagrant@vagrant:~$ strace -e trace=openat file /dev/tty
        ...
        openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
        openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
        openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
        openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
        /dev/tty: character special (5/0)
        +++ exited with 0 +++

        # So the command tried to open three files
        # /etc/magic.mgc    (doesn't exist)
        # /etc/magic
        # /usr/share/misc/magic.mgc

1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
**Answer**

        root@vagrant:~# ping -D 127.0.0.1>>/tmp/result &
        [1] 13545
        root@vagrant:~# rm -rf /tmp/result
        root@vagrant:~# lsof | grep deleted
        ping      13545                            root    1w      REG              253,0     1678    3670028 /tmp/result (deleted)
        root@vagrant:~# ls -l /proc/13545/fd
        total 0
        lrwx------ 1 root root 64 Nov 22 21:37 0 -> /dev/pts/0
        l-wx------ 1 root root 64 Nov 22 21:37 1 -> '/tmp/result (deleted)'
        lrwx------ 1 root root 64 Nov 22 21:37 2 -> /dev/pts/0
        lrwx------ 1 root root 64 Nov 22 21:37 3 -> 'socket:[52107]'
        lrwx------ 1 root root 64 Nov 22 21:37 4 -> 'socket:[52108]'
        root@vagrant:~# >/proc/13545/fd/1
        root@vagrant:~# lsof | grep deleted
        ping      13545                            root    1w      REG              253,0      234    3670028 /tmp/result (deleted)
    or  
  
        root@vagrant:~# find /proc/*/fd -ls 2> /dev/null | grep '(deleted)'
            52131      0 l-wx------   1 root     root           64 Nov 22 21:37 /proc/13545/fd/1 -> /tmp/result\ (deleted)
        root@vagrant:~# >/proc/13545/fd/1
  
1. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?  
**Answer**  

        The only resource they occupy is the process table entry. Zombie process is a process which has completed execution but still exists because it has child processes.

        vagrant@vagrant:~$ (echo $$ & exec /bin/sleep 3600)
        12795
        ^Z
        [1]+  Stopped                 ( echo $$ & exec /bin/sleep 3600 )
        vagrant@vagrant:~$ ps -o ppid,pid,stat,cmd -g 12795 --forest
        PPID     PID STAT CMD
        12794   12795 Ss   -bash
        12795   12931 T     \_ /bin/sleep 3600
        12931   12932 Z     |   \_ [bash] <defunct>
        12795   13014 R+    \_ ps -o ppid,pid,stat,cmd -g 12795 --forest



1. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
2. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
3. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
4. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
5.  Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).