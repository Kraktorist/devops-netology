# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.  
**Answer**

		$ type cd
		cd is a shell builtin

		Since each executable program runs in a separate process, and working directories are specific to each process, loading cd as an external program would not affect the working directory of the shell that loaded it.

1. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.  
**Answer** 

        grep -c <some_string> <some_file>


1. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?  
**Answer** 

        /usr/lib/systemd/systemd

1. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?  
**Answer**
        
		ls 2>/dev/pts/3

1. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.  
**Answer** 
		
		cat</tmp/in >/tmp/out

1. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?  
**Answer** 
		
		echo '1' > /dev/tty1   # yes it's possible'

1. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?  
**Answer**

		bash 5>&1  
		ls -l /proc/self/fd/5          # this will show that we have opened a file descriptor with id #5 which is redirected to the current PTY  
		echo netology > /proc/$$/fd/5  # this will send 'netology' string to the file with descriptor #5 and as it's linked to the PTY the text will appear in current console  


1. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.  
**Answer**  

		ls /tmp /not_found 3>&1 1>&2 2>&3 | cat>/tmp/out

1. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?  
**Answer** 

		printenv

1. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.  
**Answer**  

       /proc/[pid]/cmdline
              This read-only file holds the complete command line for
              the process, unless the process is a zombie.

       /proc/[pid]/exe
              Under Linux 2.2 and later, this file is a symbolic link
              containing the actual pathname of the executed command.


1. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.  
**Answer**  

		# grep -m 1 sse /proc/cpuinfo
		flags           : ... sse4_2 ...


1. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```
  
	Почитайте, почему так происходит, и как изменить поведение.

    **Answer**


		# ssh doesn't allocate a tty by default. Need to add -t key
		ssh -t localhost

1. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.  
**Answer**

		# session 1
		$ vi test &
		[5] 110210
		[4]   Done                    vi test

		# session 2
		$ reptyr 110210

1. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.  
**Answer**

		The redirection is done by the shell before any command is started. So `sudo` cannot be applied to the redirections.
		The `tee` copies standard input to each FILE, and also to standard output. And as it's started with `sudo` it has required permissions.
