# Домашнее задание к занятию "13.5 поддержка нескольких окружений на примере Qbec"
Приложение обычно существует в нескольких окружениях. Для удобства работы следует использовать соответствующие инструменты, например, Qbec.

## Задание 1: подготовить приложение для работы через qbec
Приложение следует упаковать в qbec. Окружения должно быть 2: stage и production. 

Требования:
* stage окружение должно поднимать каждый компонент приложения в одном экземпляре;
* production окружение — каждый компонент в трёх экземплярах;
* для production окружения нужно добавить endpoint на внешний адрес.

**Answer**

Деплой подготовлен для приложения, использовавшегося в предыдущей домашней работе (helm).
Отличия вызваны требованиями задания о наличии внешнего эндпоинта, а также тем, что в языке jsonnet отсутствует функция для генерации рандомных значений.

- [postgres.jsonnet](assets/newspaper/components/postgres.jsonnet)  (StatefuleSet+Service)
- [backend.jsonnet](assets/newspaper/components/backend.jsonnet) (Deployment+Service+Ingress)
- [frontend.jsonnet](assets/newspaper/components/frontend.jsonnet) (Deployment+Service+Ingress)
- [secret.jsonnet](assets/newspaper/components/secret.jsonnet) (сгенерированный пароль postgres пользователя, расшаренный между postgres и backend)
- [pvc.jsonnet](assets/newspaper/components/pvc.jsonnet) (общий NFS диск для backend и frontend)
- [external.jsonnet](assets/newspaper/components/external.jsonnet) (Service+Endpoint+Ingress для внешнего эндпоинта)

Для работы требуется NFS провайдер `helm install nfs-server stable/nfs-server-provisioner` и nginx ingress-controller.

```console
vagrant@vagrant:/$ qbec apply stage
[warn] force context lab
cluster metadata load took 21ms
6 components evaluated in 10ms

will synchronize 8 object(s)

Do you want to continue [y/n]: y
6 components evaluated in 10ms
create secrets stage-secrets -n app1 (source secret)
create persistentvolumeclaims stage-static -n app1 (source pvc)
create deployments stage-backend -n app1 (source backend)
create deployments stage-frontend -n app1 (source frontend)
create statefulsets stage-postgres -n app1 (source postgres)
create services stage-news-backend -n app1 (source backend)
create services stage-news-frontend -n app1 (source frontend)
create services stage-postgres -n app1 (source postgres)
server objects load took 1.004s
---
stats:
  created:
  - secrets stage-secrets -n app1 (source secret)
  - persistentvolumeclaims stage-static -n app1 (source pvc)
  - deployments stage-backend -n app1 (source backend)
  - deployments stage-frontend -n app1 (source frontend)
  - statefulsets stage-postgres -n app1 (source postgres)
  - services stage-news-backend -n app1 (source backend)
  - services stage-news-frontend -n app1 (source frontend)
  - services stage-postgres -n app1 (source postgres)

waiting for readiness of 3 objects
  - deployments stage-backend -n app1
  - deployments stage-frontend -n app1
  - statefulsets stage-postgres -n app1

  0s    : deployments stage-backend -n app1 :: 0 of 1 updated replicas are available
✓ 0s    : statefulsets stage-postgres -n app1 :: 1 new pods updated (2 remaining)
  0s    : deployments stage-frontend -n app1 :: 0 of 1 updated replicas are available
✓ 2s    : deployments stage-frontend -n app1 :: successfully rolled out (1 remaining)
✓ 11s   : deployments stage-backend -n app1 :: successfully rolled out (0 remaining)

✓ 11s: rollout complete
command took 15.12s
vagrant@vagrant:/$ qbec apply production
[warn] force context lab
cluster metadata load took 25ms
6 components evaluated in 10ms

will synchronize 13 object(s)

Do you want to continue [y/n]: y
6 components evaluated in 10ms
create secrets production-secrets -n app1 (source secret)
create endpoints production-ext -n app1 (source external)
create ingresses production-newspaper-backend -n app1 (source backend)
create ingresses production-ext -n app1 (source external)
create ingresses production-newspaper-frontend -n app1 (source frontend)
create persistentvolumeclaims production-static -n app1 (source pvc)
create deployments production-backend -n app1 (source backend)
create deployments production-frontend -n app1 (source frontend)
create statefulsets production-postgres -n app1 (source postgres)
create services production-news-backend -n app1 (source backend)
create services production-ext -n app1 (source external)
create services production-news-frontend -n app1 (source frontend)
create services production-postgres -n app1 (source postgres)
server objects load took 1.206s
---
stats:
  created:
  - secrets production-secrets -n app1 (source secret)
  - endpoints production-ext -n app1 (source external)
  - ingresses production-newspaper-backend -n app1 (source backend)
  - ingresses production-ext -n app1 (source external)
  - ingresses production-newspaper-frontend -n app1 (source frontend)
  - persistentvolumeclaims production-static -n app1 (source pvc)
  - deployments production-backend -n app1 (source backend)
  - deployments production-frontend -n app1 (source frontend)
  - statefulsets production-postgres -n app1 (source postgres)
  - services production-news-backend -n app1 (source backend)
  - services production-ext -n app1 (source external)
  - services production-news-frontend -n app1 (source frontend)
  - services production-postgres -n app1 (source postgres)

waiting for readiness of 3 objects
  - deployments production-backend -n app1
  - deployments production-frontend -n app1
  - statefulsets production-postgres -n app1

  0s    : deployments production-backend -n app1 :: 0 of 3 updated replicas are available
✓ 0s    : statefulsets production-postgres -n app1 :: 1 new pods updated (2 remaining)
  0s    : deployments production-frontend -n app1 :: 0 of 3 updated replicas are available
  9s    : deployments production-frontend -n app1 :: 1 of 3 updated replicas are available
  10s   : deployments production-frontend -n app1 :: 2 of 3 updated replicas are available
✓ 11s   : deployments production-frontend -n app1 :: successfully rolled out (1 remaining)
  12s   : deployments production-backend -n app1 :: 1 of 3 updated replicas are available
  12s   : deployments production-backend -n app1 :: 2 of 3 updated replicas are available
✓ 18s   : deployments production-backend -n app1 :: successfully rolled out (0 remaining)

✓ 18s: rollout complete
command took 22.89s
```

По сравнению с `helm` в `qbec` отсутствуют встроенные возможности тестирования.

Развернутые поды:

```console
vagrant@vagrant:/$ kubectl -n app1 get pods
NAME                                   READY   STATUS    RESTARTS   AGE
production-backend-857d98bb6-ml2b5     1/1     Running   0          77s
production-backend-857d98bb6-nlk6s     1/1     Running   0          77s
production-backend-857d98bb6-wb5mk     1/1     Running   0          77s
production-frontend-6c695bdfd4-5rcjw   1/1     Running   0          77s
production-frontend-6c695bdfd4-lv28f   1/1     Running   0          77s
production-frontend-6c695bdfd4-qlrh7   1/1     Running   0          77s
production-postgres-0                  1/1     Running   0          77s
stage-backend-5b977d64f-2gfhn          1/1     Running   0          106s
stage-frontend-69b5b68d46-xwz5r        1/1     Running   0          106s
stage-postgres-0                       1/1     Running   0          106s
```
---