# Самоконтроль выполнения задания

1. Где расположен файл с `some_fact` из второго пункта задания?

    **Answer**

    [group_vars/all/examp.yml](group_vars/all/examp.yml)

    ---

2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?

    **Answer**

    ```console
    ansible-playbook -i inventory/test.yml  site.yml
    ```
    ---

3. Какой командой можно зашифровать файл?

    **Answer**
    ```console
    ansible-vault encrypt group_vars/deb/examp.yml
    ```
    ---

4. Какой командой можно расшифровать файл?

    **Answer**
    ```console
    ansible-vault decrypt group_vars/deb/examp.yml
    ```
    ---

5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?

    **Answer**

    ```console
    ansible-vault view group_vars/el/examp.yml
    ```
    ---

6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?

    **Answer**

    ```console
    ansible-playbook -i inventory/prod.yml  site.yml --ask-vault-password

    ansible-playbook -i inventory/prod.yml  site.yml --vault-password-file VAULT_PASSWORD_FILES
    ```
    ---

7. Как называется модуль подключения к host на windows?

    **Answer**

    ```console
    ansible-doc -t connection winrm
    ```
    ---

8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh

    **Answer**

    ```console
    ansible-doc -t connection ssh
    ```
    ---

9.  Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?


    **Answer**

    ```console
    - remote_user
            User name with which to login to the remote server, normally set by the remote_user keyword.
            If no user is supplied, Ansible will let the SSH client binary choose the user as it normally.
            [Default: (null)]
            set_via:
              cli:
              - name: user
                option: --user
              env:
              - name: ANSIBLE_REMOTE_USER
              ini:
              - key: remote_user
                section: defaults
              vars:
              - name: ansible_user
              - name: ansible_ssh_user
    ```
    ---
