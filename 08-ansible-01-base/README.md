# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

    **Answer**
    ```console
    vagrant@vagrant$ ansible-playbook site.yml -i inventory/test.yml 

    PLAY [Print os facts] *****************************************************************************************************************

    TASK [Gathering Facts] ****************************************************************************************************************
    ok: [localhost]

    TASK [Print OS] ***********************************************************************************************************************
    ok: [localhost] => 
      msg: Ubuntu

    TASK [Print fact] *********************************************************************************************************************
    ok: [localhost] => 
      msg: 12

    PLAY RECAP ****************************************************************************************************************************
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

    ```
    ---

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

    **Answer**
    ```console
    vagrant@vagrant$ ansible-playbook site.yml -i inventory/test.yml 

    PLAY [Print os facts] *****************************************************************************************************************

    TASK [Gathering Facts] ****************************************************************************************************************
    ok: [localhost]

    TASK [Print OS] ***********************************************************************************************************************
    ok: [localhost] => 
      msg: Ubuntu

    TASK [Print fact] *********************************************************************************************************************
    ok: [localhost] => 
      msg: all default fact

    PLAY RECAP ****************************************************************************************************************************
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
    ```
    ---

1. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

    **Answer**

    ```console
    docker run --name ubuntu -dt python sh -c "sleep 3600"
    docker run --name centos7 -dt centos:7 sh -c "sleep 3600"
    ```
    ---

1. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

    **Answer**

    ```console
    vagrant@vagrant$ ansible-playbook site.yml -i inventory/prod.yml 

    PLAY [Print os facts] *****************************************************************************************************************

    TASK [Gathering Facts] ****************************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ***********************************************************************************************************************
    ok: [centos7] => 
      msg: CentOS
    ok: [ubuntu] => 
      msg: Debian

    TASK [Print fact] *********************************************************************************************************************
    ok: [centos7] => 
      msg: el
    ok: [ubuntu] => 
      msg: deb

    PLAY RECAP ****************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    ---

1. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

    **Answer**
    ```console
    vagrant@vagrant$ ansible-inventory -i inventory/prod.yml --graph --vars
    @all:
      |--@deb:
      |  |--ubuntu
      |  |  |--{ansible_connection = docker}
      |  |  |--{some_fact = deb default fact}
      |--@el:
      |  |--centos7
      |  |  |--{ansible_connection = docker}
      |  |  |--{some_fact = el default fact}
      |--@ungrouped:

    ```
    ---

1.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

    **Answer**
    ```console
    vagrant@vagrant$ ansible-playbook site.yml -i inventory/prod.yml 

    PLAY [Print os facts] *****************************************************************************************************************

    TASK [Gathering Facts] ****************************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ***********************************************************************************************************************
    ok: [centos7] => 
      msg: CentOS
    ok: [ubuntu] => 
      msg: Debian

    TASK [Print fact] *********************************************************************************************************************
    ok: [centos7] => 
      msg: el default fact
    ok: [ubuntu] => 
      msg: deb default fact

    PLAY RECAP ****************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
    ```
    ---

1. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

    **Answer**
    ```console
    vagrant@vagrant$ ansible-vault encrypt group_vars/deb/examp.yml
    vagrant@vagrant$ ansible-vault encrypt group_vars/el/examp.yml
    ```
    ---

1. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

    **Answer**
    ```console
    vagrant@vagrant$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-password
    Vault password: 

    PLAY [Print os facts] *****************************************************************************************************************

    TASK [Gathering Facts] ****************************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ***********************************************************************************************************************
    ok: [centos7] => 
      msg: CentOS
    ok: [ubuntu] => 
      msg: Debian

    TASK [Print fact] *********************************************************************************************************************
    ok: [centos7] => 
      msg: el default fact
    ok: [ubuntu] => 
      msg: deb default fact

    PLAY RECAP ****************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ```
    ---

1.  Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

    **Answer**
    ```console
    vagrant@vagrant$ ansible-doc --type connection --list
    vagrant@vagrant$ ansible-doc --type connection local
    ```
    ---

1.  В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

    **Answer**
    ```yaml
      local:
        hosts:
          localhost:
            ansible_connection: local
    ```
    ---

1.  Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

    **Answer**
    ```console
    vagrant@vagrant$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-password
    Vault password: 

    PLAY [Print os facts] *****************************************************************************************************************

    TASK [Gathering Facts] ****************************************************************************************************************
    ok: [localhost]
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ***********************************************************************************************************************
    ok: [localhost] => 
      msg: Ubuntu
    ok: [centos7] => 
      msg: CentOS
    ok: [ubuntu] => 
      msg: Debian

    TASK [Print fact] *********************************************************************************************************************
    ok: [localhost] => 
      msg: all default fact
    ok: [centos7] => 
      msg: el default fact
    ok: [ubuntu] => 
      msg: deb default fact

    PLAY RECAP ****************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

    ```
    ---

1.  Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

    **Answer**  

    [Repository](https://github.com/Kraktorist/devops-netology-ansible/blob/master/README.md)

    ---

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

    **Answer**
    ```console
    vagrant@vagrant$ ansible-vault decrypt group_vars/deb/examp.yml
    vagrant@vagrant$ ansible-vault decrypt group_vars/el/examp.yml
    ```
    ---

1. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

    **Answer**
    ```console
    vagrant@vagrant$ ansible-vault encrypt_string PaSSw0rd
    New Vault password: 
    Confirm New Vault password: 
    !vault |
              $ANSIBLE_VAULT;1.1;AES256
              64633336376135373966383461616231363739346364306363346339623361363232643435646235
              3633303531383334353531653537343135366361366363610a613062636563343130373831363735
              36643237623463663562396430316164386635386633313539373663316138613464313535633036
              6363303861353435370a386135623564396236323932316533386365393337633163363063376663
              3330
    Encryption successful
    ```
    ---

1. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

    **Answer**

    ```console
    vagrant@vagrant$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-password
    Vault password: 

    PLAY [Print os facts] *****************************************************************************************************************

    TASK [Gathering Facts] ****************************************************************************************************************
    ok: [localhost]
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ***********************************************************************************************************************
    ok: [localhost] => 
      msg: Ubuntu
    ok: [centos7] => 
      msg: CentOS
    ok: [ubuntu] => 
      msg: Debian

    TASK [Print fact] *********************************************************************************************************************
    ok: [localhost] => 
      msg: PaSSw0rd
    ok: [centos7] => 
      msg: el default fact
    ok: [ubuntu] => 
      msg: deb default fact

    PLAY RECAP ****************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    ---

1. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

    **Answer**

    ```console
    vagrant@vagrant$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-password
    Vault password: 
    [WARNING]: Found both group and host with same name: fedora

    PLAY [Print os facts] *****************************************************************************************************************

    TASK [Gathering Facts] ****************************************************************************************************************
    ok: [localhost]
    ok: [fedora]
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ***********************************************************************************************************************
    ok: [localhost] => 
      msg: Ubuntu
    ok: [ubuntu] => 
      msg: Debian
    ok: [centos7] => 
      msg: CentOS
    ok: [fedora] => 
      msg: Fedora

    TASK [Print fact] *********************************************************************************************************************
    ok: [localhost] => 
      msg: PaSSw0rd
    ok: [ubuntu] => 
      msg: deb default fact
    ok: [centos7] => 
      msg: el default fact
    ok: [fedora] => 
      msg: fedora fact

    PLAY RECAP ****************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ```
    ---

1. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

    **Answer**  

    [bootstrap.sh](assets/bootstrap.sh)

---

6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.
