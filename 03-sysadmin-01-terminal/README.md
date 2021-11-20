# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"


5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?

```
>>$ sudo vboxmanage list runningvms
"03-sysadmin-01-terminal_default_1637399944149_77178" {ed40b6ea-ab1f-4bf2-a657-550f60debe2b}
kraktorist@hmlab01:~/devops-netology/03-sysadmin-01-terminal$ sudo VBoxManage showvminfo {ed40b6ea-ab1f-4bf2-a657-550f60debe2b} | grep -E "CPUs|Memory|SATA|NIC"
Memory size                  1024MB
Number of CPUs:              2
Storage Controller Name (1):            SATA Controller
SATA Controller (0, 0): /root/VirtualBox VMs/03-sysadmin-01-terminal_default_1637399944149_77178/ubuntu-20.04-amd64-disk001.vmdk (UUID: c4985591-e84b-4e4b-b7a3-4099c7978395)
NIC 1:                       MAC: 0800277360CF, Attachment: NAT, Cable connected: on, Trace: off (file: none), Type: 82540EM, Reported speed: 0 Mbps, Boot priority: 0, Promisc Policy: deny, Bandwidth group: none
NIC 1 Settings:  MTU: 0, Socket (send: 64, receive: 64), TCP Window (send:64, receive: 64)
NIC 1 Rule(0):   name = ssh, protocol = tcp, host ip = 127.0.0.1, host port = 2222, guest ip = , guest port = 22
NIC 2:                       disabled
NIC 3:                       disabled
NIC 4:                       disabled
NIC 5:                       disabled
NIC 6:                       disabled
NIC 7:                       disabled
NIC 8:                       disabled

>>$ sudo VBoxManage list hdds
UUID:           c4985591-e84b-4e4b-b7a3-4099c7978395
Parent UUID:    base
State:          locked write
Type:           normal (base)
Location:       /root/VirtualBox VMs/03-sysadmin-01-terminal_default_1637399944149_77178/ubuntu-20.04-amd64-disk001.vmdk
Storage format: VMDK
Capacity:       65536 MBytes
Encryption:     disabled

```

6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: [документация](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html). Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

```
Vagrant.configure("2") do |config|
  config.vm.define 'default' do |h|
    h.vm.box = "bento/ubuntu-20.04"
    config.vm.provider "virtualbox" do |vb|
      vb.cpus = "2"
      vb.memory = "4096"
    end
    # requires VAGRANT_EXPERIMENTAL="disks"
    h.vm.disk :disk, size: "37GB", primary: true
    h.vm.disk :disk, size: "10GB", name: "extra_storage"
  end
end
```

8. Ознакомиться с разделами `man bash`, почитать о настройках самого bash:
    * какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?
    ```
    vagrant@vagrant:~$ man bash | grep -m1 -A 4 -n HISTFILESIZE
    698:       HISTFILESIZE
    699-              The maximum number of lines contained in the history file.  When this variable is assigned a value, the history file is truncated, if  necessary,  to
    700-              contain  no  more  than that number of lines by removing the oldest entries.  The history file is also truncated to this size after writing it when a
    701-              shell exits.  If the value is 0, the history file is truncated to zero size.  Non-numeric values and numeric values less than  zero  inhibit  trunca‐
    702-              tion.  The shell sets the default value to the value of HISTSIZE after reading any startup files.
    ```

    * что делает директива `ignoreboth` в bash?
    ```
    vagrant@vagrant:~$ man bash | grep -m1 -B 3 -n ignoreboth
    688-       HISTCONTROL
    689-              A colon-separated list of values controlling how commands are saved on the history list.  If the list of values includes ignorespace, lines which be‐
    690-              gin  with  a  space  character  are  not saved in the history list.  A value of ignoredups causes lines matching the previous history entry to not be
    691:              saved.  A value of ignoreboth is shorthand for ignorespace and ignoredups.  A value of erasedups causes all previous lines matching the current  line
    ```
9.  В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?

```
man bash | grep -m 1 -n "Compound Commands"
```

```
man bash | grep -m 1 -n "Brace Expansion"
```

```
man bash | grep -m 1 -n "Parameter Expansion"
```

10.  С учётом ответа на предыдущий вопрос, как создать однократным вызовом `touch` 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?

```
touch {1..100000}.txt
```

```
vagrant@vagrant:~$ touch {1..300000}.txt
-bash: /usr/bin/touch: Argument list too long
```
> bash expands the list into a long string. This string is limited by the length specified in `getconf ARG_MAX`


11. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`

```
CONDITIONAL EXPRESSIONS
       Conditional  expressions  are  used by the [[ compound command and the test and [ builtin commands to test file attributes and perform string and arithmetic comparisons. 
       
       ...

       -d file
              True if file exists and is a directory.

```

> This command tests if the folder `/tmp` exists
```
[[ -d /tmp ]] && echo "It's a directory"
```

12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

	```bash
	bash is /tmp/new_path_directory/bash
	bash is /usr/local/bin/bash
	bash is /bin/bash
	```

	(прочие строки могут отличаться содержимым и порядком)
    В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.

```
PATH="/tmp/new_path_directory:/usr/local/bin:/bin"
mkdir /tmp/new_path_directory
touch /tmp/new_path_directory/bash
chmod +x /tmp/new_path_directory/bash
sudo touch /usr/local/bin/bash
sudo chmod +x /usr/local/bin/bash
```

13. Чем отличается планирование команд с помощью `batch` и `at`?

> actually batch is an alias for `at -b`
 
```
vagrant@vagrant:~$ cat /usr/bin/batch

#! /bin/sh -e
if [ "$#" -gt 0 ]; then
        echo batch accepts no parameters
        exit 1
fi
prefix=/usr
exec_prefix=${prefix}
exec ${exec_prefix}/bin/at -qb now
```
```
batch executes commands when system load levels permit; in other words,when the load average drops below 1.5, or the value specified in the invocation of atd.
```


14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.

```
poweroff
```
