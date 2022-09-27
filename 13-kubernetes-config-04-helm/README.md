# Домашнее задание к занятию "13.4 инструменты для упрощения написания конфигурационных файлов. Helm и Jsonnet"
В работе часто приходится применять системы автоматической генерации конфигураций. Для изучения нюансов использования разных инструментов нужно попробовать упаковать приложение каждым из них.

## Задание 1: подготовить helm чарт для приложения
Необходимо упаковать приложение в чарт для деплоя в разные окружения. Требования:
* каждый компонент приложения деплоится отдельным deployment’ом/statefulset’ом;
* в переменных чарта измените образ приложения для изменения версии.

**Answer**

Использовано приложение из предыдущих домашних заданий.
Оно состоит из следующих компонентов:

- [postgres.yaml](assets/helm/newspaper/templates/postgres.yaml) (StatefuleSet+Service)
- [backend.yaml](assets/helm/newspaper/templates/backend.yaml) (Deployment+Service+Ingress)
- [frontend.yaml](assets/helm/newspaper/templates/frontend.yaml) (Deployment+Service+Ingress)
- [credentials.yaml](assets/helm/newspaper/templates/credentials.yaml)  (сгенерированный пароль postgres пользователя, расшаренный между postgres и backend)
- [pvc.yaml](assets/helm/newspaper/templates/pvc.yaml) (общий NFS диск для backend и frontend)

Для работы требуется NFS провайдер `helm install nfs-server stable/nfs-server-provisioner` и nginx ingress-controller.

В правилах ингрессов прописан hostname, который необходимо задавать через `.Values.hostname`

Для проверки установки добавлено два теста:

- [test backend connection](assets/helm/newspaper/templates/tests/test-backend-connection.yaml)
- [test frontend connection](assets/helm/newspaper/templates/tests/test-frontend-connection.yaml)

---

## Задание 2: запустить 2 версии в разных неймспейсах
Подготовив чарт, необходимо его проверить. Попробуйте запустить несколько копий приложения:
* одну версию в namespace=app1;
* вторую версию в том же неймспейсе;
* третью версию в namespace=app2.

**Answer**

Деплоим первый релиз `alpha` в namespace `app1`

```console
vagrant@vagrant:/$ helm -n app1 install alpha newspaper
NAME: alpha
LAST DEPLOYED: Tue Sep 27 21:55:56 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 1
```
Деплоим второй релиз `beta` в тот же namespace

```console
vagrant@vagrant:~/$ helm -n app1 install beta newspaper --set hostname=beta
NAME: beta
LAST DEPLOYED: Tue Sep 27 22:04:04 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 1
```

Деплоим релиз `gamma` в namespace `app2`

```console
vagrant@vagrant:~/$ helm -n app2 install gamma newspaper --set hostname=gamma
NAME: gamma
LAST DEPLOYED: Tue Sep 27 22:06:56 2022
NAMESPACE: app2
STATUS: deployed
REVISION: 1
```

Тестируем все три релиза

```console
vagrant@vagrant:~/$ helm -n app1 test alpha
NAME: alpha
LAST DEPLOYED: Tue Sep 27 21:55:56 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE:     alpha-test-backend-connection
Last Started:   Tue Sep 27 22:11:16 2022
Last Completed: Tue Sep 27 22:11:20 2022
Phase:          Succeeded
TEST SUITE:     alpha-test-frontend-connection
Last Started:   Tue Sep 27 22:11:20 2022
Last Completed: Tue Sep 27 22:11:23 2022
Phase:          Succeeded
vagrant@vagrant:~/$ helm -n app1 test beta
NAME: beta
LAST DEPLOYED: Tue Sep 27 22:04:04 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE:     beta-test-backend-connection
Last Started:   Tue Sep 27 22:11:29 2022
Last Completed: Tue Sep 27 22:11:32 2022
Phase:          Succeeded
TEST SUITE:     beta-test-frontend-connection
Last Started:   Tue Sep 27 22:11:32 2022
Last Completed: Tue Sep 27 22:11:35 2022
Phase:          Succeeded
vagrant@vagrant:~/$ helm -n app2 test gamma
NAME: gamma
LAST DEPLOYED: Tue Sep 27 22:06:56 2022
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE:     gamma-test-backend-connection
Last Started:   Tue Sep 27 22:11:53 2022
Last Completed: Tue Sep 27 22:11:57 2022
Phase:          Succeeded
TEST SUITE:     gamma-test-frontend-connection
Last Started:   Tue Sep 27 22:11:57 2022
Last Completed: Tue Sep 27 22:12:00 2022
Phase:          Succeeded
```

Проверяем поды:

```console
vagrant@vagrant:~/$ kubectl get pods -A | (head -n 1; grep app)
NAMESPACE       NAME                                  READY   STATUS    RESTARTS        AGE
app1            alpha-backend-5ddd775798-mgrl9        1/1     Running   0               22m
app1            alpha-frontend-786bb5cd7c-cx952       1/1     Running   0               22m
app1            alpha-postgres-0                      1/1     Running   0               22m
app1            beta-backend-6454bb8878-jj6wl         1/1     Running   0               13m
app1            beta-frontend-754945d9f5-lg8tk        1/1     Running   0               14m
app1            beta-postgres-0                       1/1     Running   0               14m
app2            gamma-backend-f7f54546f-nw7hh         1/1     Running   0               11m
app2            gamma-frontend-787bfbbf79-z8g89       1/1     Running   0               11m
app2            gamma-postgres-0                      1/1     Running   0               11m
```

---

## Задание 3 (*): повторить упаковку на jsonnet
Для изучения другого инструмента стоит попробовать повторить опыт упаковки из задания 1, только теперь с помощью инструмента jsonnet.

**Answer**

---