# Домашнее задание к занятию "08.05 Тестирование Roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.4.0"`
2. Соберите локальный образ на основе [Dockerfile](./Dockerfile)

<details>
<summary>Задание</summary>

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it <image_name> /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Ссылка на репозиторий являются ответами на домашнее задание. Не забудьте указать в ответе теги решений Tox и Molecule заданий.

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли lighthouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории. В ответ приведите ссылки.

---

</details>

**Answers**

[vector-role with molecule tests and tox configuration](https://github.com/Kraktorist/devops-netology/tree/vector-role)

[lighthouse-role with molecule tests and tox configuration](https://github.com/Kraktorist/devops-netology/tree/lighthouse-role)


### Console Output

    ```console
    vagrant@vagrant:~/repos/vector-role$ molecule test -s centos-8
    INFO     centos-8 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
    INFO     Performing prerun...
    INFO     Set ANSIBLE_LIBRARY=/home/vagrant/.cache/ansible-compat/f5bcd7/modules:/home/vagrant/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
    INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/vagrant/.cache/ansible-compat/f5bcd7/collections:/home/vagrant/.ansible/collections:/usr/share/ansible/collections
    INFO     Set ANSIBLE_ROLES_PATH=/home/vagrant/.cache/ansible-compat/f5bcd7/roles:/home/vagrant/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
    INFO     Using /home/vagrant/.ansible/roles/vagrant.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
    INFO     Running centos-8 > dependency
    WARNING  Skipping, missing the requirements file.
    WARNING  Skipping, missing the requirements file.
    INFO     Running centos-8 > lint
    INFO     Lint is disabled.
    INFO     Running centos-8 > cleanup
    WARNING  Skipping, cleanup playbook not configured.
    INFO     Running centos-8 > destroy
    INFO     Sanity checks: 'docker'

    PLAY [Destroy] *****************************************************************

    TASK [Destroy molecule instance(s)] ********************************************
    changed: [localhost] => (item=centos-8)

    TASK [Wait for instance(s) deletion to complete] *******************************
    FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
    ok: [localhost] => (item=centos-8)

    TASK [Delete docker networks(s)] ***********************************************

    PLAY RECAP *********************************************************************
    localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

    INFO     Running centos-8 > syntax

    playbook: /home/vagrant/repos/vector-role/molecule/centos-8/converge.yml
    INFO     Running centos-8 > create

    PLAY [Create] ******************************************************************

    TASK [Log into a Docker registry] **********************************************
    skipping: [localhost] => (item=None) 
    skipping: [localhost]

    TASK [Check presence of custom Dockerfiles] ************************************
    ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'centos:8', 'name': 'centos-8', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

    TASK [Create Dockerfiles from image names] *************************************
    changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'centos:8', 'name': 'centos-8', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

    TASK [Discover local Docker images] ********************************************
    ok: [localhost] => (item={'diff': [], 'dest': '/home/vagrant/.cache/molecule/vector-role/centos-8/Dockerfile_centos_8', 'src': '/home/vagrant/.ansible/tmp/ansible-tmp-1653417526.553448-300890-214258860842711/source', 'md5sum': 'c07f347eeb8be58de350083cd2fbe020', 'checksum': '5032d49a8c94a638d83c2b28fea034395f6f41b7', 'changed': True, 'uid': 1000, 'gid': 1000, 'owner': 'vagrant', 'group': 'vagrant', 'mode': '0600', 'state': 'file', 'size': 2394, 'invocation': {'module_args': {'src': '/home/vagrant/.ansible/tmp/ansible-tmp-1653417526.553448-300890-214258860842711/source', 'dest': '/home/vagrant/.cache/molecule/vector-role/centos-8/Dockerfile_centos_8', 'mode': '0600', 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': '5032d49a8c94a638d83c2b28fea034395f6f41b7', 'backup': False, 'force': True, 'unsafe_writes': False, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None}}, 'failed': False, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'centos:8', 'name': 'centos-8', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

    TASK [Build an Ansible compatible image (new)] *********************************
    ok: [localhost] => (item=molecule_local/centos:8)

    TASK [Create docker network(s)] ************************************************

    TASK [Determine the CMD directives] ********************************************
    ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'centos:8', 'name': 'centos-8', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

    TASK [Create molecule instance(s)] *********************************************
    changed: [localhost] => (item=centos-8)

    TASK [Wait for instance(s) creation to complete] *******************************
    FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
    changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '18171781193.301045', 'results_file': '/home/vagrant/.ansible_async/18171781193.301045', 'changed': True, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'centos:8', 'name': 'centos-8', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})

    PLAY RECAP *********************************************************************
    localhost                  : ok=7    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

    INFO     Running centos-8 > prepare
    WARNING  Skipping, prepare playbook not configured.
    INFO     Running centos-8 > converge

    PLAY [Converge] ****************************************************************

    TASK [Gathering Facts] *********************************************************
    ok: [centos-8]

    TASK [Install sudo] ************************************************************
    ok: [centos-8]

    TASK [Include vector-role] *****************************************************

    TASK [vector-role : include_tasks] *********************************************
    included: /home/vagrant/repos/vector-role/tasks/install/dnf.yml for centos-8

    TASK [vector-role : Install vector package] ************************************
    changed: [centos-8]

    TASK [vector-role : Redefine vector config name] *******************************
    changed: [centos-8]

    TASK [vector-role : Create vector config] **************************************
    changed: [centos-8]

    RUNNING HANDLER [vector-role : Start Vector service] ***************************
    changed: [centos-8]

    PLAY RECAP *********************************************************************
    centos-8                   : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

    INFO     Running centos-8 > idempotence

    PLAY [Converge] ****************************************************************

    TASK [Gathering Facts] *********************************************************
    ok: [centos-8]

    TASK [Install sudo] ************************************************************
    ok: [centos-8]

    TASK [Include vector-role] *****************************************************

    TASK [vector-role : include_tasks] *********************************************
    included: /home/vagrant/repos/vector-role/tasks/install/dnf.yml for centos-8

    TASK [vector-role : Install vector package] ************************************
    ok: [centos-8]

    TASK [vector-role : Redefine vector config name] *******************************
    ok: [centos-8]

    TASK [vector-role : Create vector config] **************************************
    ok: [centos-8]

    PLAY RECAP *********************************************************************
    centos-8                   : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

    INFO     Idempotence completed successfully.
    INFO     Running centos-8 > side_effect
    WARNING  Skipping, side effect playbook not configured.
    INFO     Running centos-8 > verify
    INFO     Running Ansible Verifier

    PLAY [Verify] ******************************************************************

    TASK [Gather Installed Packages] ***********************************************
    ok: [centos-8]

    TASK [Assert Vector Packages] **************************************************
    ok: [centos-8] => {
        "changed": false,
        "msg": "All assertions passed"
    }

    TASK [Validate Vector Config] **************************************************
    changed: [centos-8]

    TASK [Assert Vector Config Validation Status] **********************************
    ok: [centos-8] => {
        "changed": false,
        "msg": "All assertions passed"
    }

    TASK [Collect Facts About System Services] *************************************
    ok: [centos-8]

    TASK [Assert Vector Systemd Unit Status] ***************************************
    ok: [centos-8] => {
        "changed": false,
        "msg": "All assertions passed"
    }

    TASK [Assert Vector Systemd Unit State] ****************************************
    ok: [centos-8] => {
        "changed": false,
        "msg": "All assertions passed"
    }

    PLAY RECAP *********************************************************************
    centos-8                   : ok=7    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

    INFO     Verifier completed successfully.
    INFO     Running centos-8 > cleanup
    WARNING  Skipping, cleanup playbook not configured.
    INFO     Running centos-8 > destroy

    PLAY [Destroy] *****************************************************************

    TASK [Destroy molecule instance(s)] ********************************************
    changed: [localhost] => (item=centos-8)

    TASK [Wait for instance(s) deletion to complete] *******************************
    FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
    changed: [localhost] => (item=centos-8)

    TASK [Delete docker networks(s)] ***********************************************

    PLAY RECAP *********************************************************************
    localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

    INFO     Pruning extra files from scenario ephemeral directory
    ```