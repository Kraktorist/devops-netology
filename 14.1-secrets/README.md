# Домашнее задание к занятию "14.1 Создание и использование секретов"

<details>
<summary>Задача 1: Работа с секретами через утилиту kubectl в установленном minikube</summary>
## Задача 1: Работа с секретами через утилиту kubectl в установленном minikube

Выполните приведённые ниже команды в консоли, получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать секрет?

```
openssl genrsa -out cert.key 4096
openssl req -x509 -new -key cert.key -days 3650 -out cert.crt \
-subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'
kubectl create secret tls domain-cert --cert=certs/cert.crt --key=certs/cert.key
```

### Как просмотреть список секретов?

```
kubectl get secrets
kubectl get secret
```

### Как просмотреть секрет?

```
kubectl get secret domain-cert
kubectl describe secret domain-cert
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get secret domain-cert -o yaml
kubectl get secret domain-cert -o json
```

### Как выгрузить секрет и сохранить его в файл?

```
kubectl get secrets -o json > secrets.json
kubectl get secret domain-cert -o yaml > domain-cert.yml
```

### Как удалить секрет?

```
kubectl delete secret domain-cert
```

### Как загрузить секрет из файла?

```
kubectl apply -f domain-cert.yml
```

</details>

## Задача 2 (*): Работа с секретами внутри модуля

Выберите любимый образ контейнера, подключите секреты и проверьте их доступность
как в виде переменных окружения, так и в виде примонтированного тома.

**Answer**

[pod.yaml](assets/pod.yaml)

bash pod with entrypoint which prints env variable and content of mounted secret 

```console
vagrant@minikube:~/14.1$ kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: secret-test
  name: secret-test
spec:
  containers:
  - image: bash
    name: secret-test
    command:
    - bash
    - -c 
    - "echo $CRT_FROM_SECRET && cat /tmp/domain-cert/tls.crt"
    env:
      - name: CRT_FROM_SECRET
        valueFrom:
          secretKeyRef:
            name: domain-cert
            key: tls.crt    
    volumeMounts:
      - name: domain-cert
        mountPath: /tmp/domain-cert
  volumes:
  - name: domain-cert
    secret:
      secretName: domain-cert
pod/secret-test created
vagrant@minikube:~/14.1$ kubectl logs secret-test
-----BEGIN CERTIFICATE----- MIIFbTCCA1WgAwIBAgIUZuUEs+DUw2THIxkb/uQUrQhWP2EwDQYJKoZIhvcNAQEL BQAwRjELMAkGA1UEBhMCUlUxDzANBgNVBAgMBk1vc2NvdzEPMA0GA1UEBwwGTW9z Y293MRUwEwYDVQQDDAxzZXJ2ZXIubG9jYWwwHhcNMjIxMTA5MTg0NTEyWhcNMzIx MTA2MTg0NTEyWjBGMQswCQYDVQQGEwJSVTEPMA0GA1UECAwGTW9zY293MQ8wDQYD VQQHDAZNb3Njb3cxFTATBgNVBAMMDHNlcnZlci5sb2NhbDCCAiIwDQYJKoZIhvcN AQEBBQADggIPADCCAgoCggIBAMte5BUOGoHt63x2C3WHl/8n0pBOMJ+AriORjMM3 bAeje38OAU+TTMjuoz3IOgqGv4p13y25ZFLQSb4/hwjVVKP3jLBW/JnDF5IoXVSo 4wSAyijE+Jx2AAdgSRuhSsgrGv3imy4GN5nrw6O88NHPj0/7t8NsdUX5SSmDuZeQ 0Yf52PqOt4OTixbkTJP8PL31yJ334wVbm9YE/UHKSSd5bvR/7+p7G4DF9dQ6Kxnj 0NurZyzYjORht5Ziyn6VsjsUaIbprp3bgF5PAhMlFmTpyf62RrAnqo46Lf5k+Eb4 eOUgSc1tpgpga/a4knLgLP78eC/1zvki23aJXrEN98kQGWUOOLpT4yhQzhT1gzza WowQt7O4WwhDavuxDK++pwgjMrixZGuwVDyWcE7lCki9WuZZXDaWo6oq1L1437Uy dXC7LAqbX7QhJ91eUGtNUXxrZ9V6CgAr9+HlTt5yGLGv2DDi766++MDy8kiKP5EQ OE3P/gUogyr1DNQAM0WxT/7wL0FoZ/HYg05JPgdzfO00yHDhlea+zvQBwA+kf2NT 3kyX/lqRSLThGOwWL5iqJGSAUyTqUELDI3lb5j4PxjLZkR+kwbai8L1PLg0lZSn8 P4OvKijFbTvr+CXbY8JqA/oQwFBc+LXOrrGxFe73jgMo9iyUioOTZL716YdTLAQl kWipAgMBAAGjUzBRMB0GA1UdDgQWBBTmkTWGeufSi2RGUdCvOy3ltEvlijAfBgNV HSMEGDAWgBTmkTWGeufSi2RGUdCvOy3ltEvlijAPBgNVHRMBAf8EBTADAQH/MA0G CSqGSIb3DQEBCwUAA4ICAQDLSTS6jN16J5ysR8RhENaLATUlzir41xSUgIIbea50 FrW4b1k3MfGSdc43Zex/b6gnWuinid/7zVvzG0fAgle6BPqrgNFjkaDqMbvf0quW XA+OnWwTFIazJL3WXkqussSUvvN7EuOjuPLqBVi8cTYqeMjBFfZUfI5ziuEffOFh jUWAof6+C+RqmVNGbxa0mZ445o+uxn00hlI7ye1FNdxWsbS/p7AfpqlfaXfxA89Z TY+Ds6jb5jHeUxEyLK5xLKsphcyAzfkVAURqQCF/5uuAgd1upGsZ5+quKU1ZnJoS k9R9PtRc11DCvSlHmRbF3RJVl0gaW3Ydv8j7VMjkl9j8flkD1T7zjGkcSuEdrjAO imzm97P0g9FSNL/rMjVSU2KLliKMIQSKvR3PQ0SkI99OSCR+M9Wv4prT9SPkOcbR KYMsBgDmhCTQg/nYaOIur1L3piUbnqdxHxfVL/jvj3vF6noJFnKFISeun73nvffg CUxyL/E/n2YNqg/N+awJfbIZPAcrV0Nxn4j7R2BXy4LirRsq7W/NLd7jntaGR9iJ KjQY8m8QV++Bzxp+vDcJUNkaMLgUfN5py5QkT6q7Sno0Q67XPh23pTcg6S1CPY+H ajFsllXA7XkM2CXZXsXnjloisno8nSknOuOx/GHblbJtusAhv2Ml2npNe17rGNYY 7g== -----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIFbTCCA1WgAwIBAgIUZuUEs+DUw2THIxkb/uQUrQhWP2EwDQYJKoZIhvcNAQEL
BQAwRjELMAkGA1UEBhMCUlUxDzANBgNVBAgMBk1vc2NvdzEPMA0GA1UEBwwGTW9z
Y293MRUwEwYDVQQDDAxzZXJ2ZXIubG9jYWwwHhcNMjIxMTA5MTg0NTEyWhcNMzIx
MTA2MTg0NTEyWjBGMQswCQYDVQQGEwJSVTEPMA0GA1UECAwGTW9zY293MQ8wDQYD
VQQHDAZNb3Njb3cxFTATBgNVBAMMDHNlcnZlci5sb2NhbDCCAiIwDQYJKoZIhvcN
AQEBBQADggIPADCCAgoCggIBAMte5BUOGoHt63x2C3WHl/8n0pBOMJ+AriORjMM3
bAeje38OAU+TTMjuoz3IOgqGv4p13y25ZFLQSb4/hwjVVKP3jLBW/JnDF5IoXVSo
4wSAyijE+Jx2AAdgSRuhSsgrGv3imy4GN5nrw6O88NHPj0/7t8NsdUX5SSmDuZeQ
0Yf52PqOt4OTixbkTJP8PL31yJ334wVbm9YE/UHKSSd5bvR/7+p7G4DF9dQ6Kxnj
0NurZyzYjORht5Ziyn6VsjsUaIbprp3bgF5PAhMlFmTpyf62RrAnqo46Lf5k+Eb4
eOUgSc1tpgpga/a4knLgLP78eC/1zvki23aJXrEN98kQGWUOOLpT4yhQzhT1gzza
WowQt7O4WwhDavuxDK++pwgjMrixZGuwVDyWcE7lCki9WuZZXDaWo6oq1L1437Uy
dXC7LAqbX7QhJ91eUGtNUXxrZ9V6CgAr9+HlTt5yGLGv2DDi766++MDy8kiKP5EQ
OE3P/gUogyr1DNQAM0WxT/7wL0FoZ/HYg05JPgdzfO00yHDhlea+zvQBwA+kf2NT
3kyX/lqRSLThGOwWL5iqJGSAUyTqUELDI3lb5j4PxjLZkR+kwbai8L1PLg0lZSn8
P4OvKijFbTvr+CXbY8JqA/oQwFBc+LXOrrGxFe73jgMo9iyUioOTZL716YdTLAQl
kWipAgMBAAGjUzBRMB0GA1UdDgQWBBTmkTWGeufSi2RGUdCvOy3ltEvlijAfBgNV
HSMEGDAWgBTmkTWGeufSi2RGUdCvOy3ltEvlijAPBgNVHRMBAf8EBTADAQH/MA0G
CSqGSIb3DQEBCwUAA4ICAQDLSTS6jN16J5ysR8RhENaLATUlzir41xSUgIIbea50
FrW4b1k3MfGSdc43Zex/b6gnWuinid/7zVvzG0fAgle6BPqrgNFjkaDqMbvf0quW
XA+OnWwTFIazJL3WXkqussSUvvN7EuOjuPLqBVi8cTYqeMjBFfZUfI5ziuEffOFh
jUWAof6+C+RqmVNGbxa0mZ445o+uxn00hlI7ye1FNdxWsbS/p7AfpqlfaXfxA89Z
TY+Ds6jb5jHeUxEyLK5xLKsphcyAzfkVAURqQCF/5uuAgd1upGsZ5+quKU1ZnJoS
k9R9PtRc11DCvSlHmRbF3RJVl0gaW3Ydv8j7VMjkl9j8flkD1T7zjGkcSuEdrjAO
imzm97P0g9FSNL/rMjVSU2KLliKMIQSKvR3PQ0SkI99OSCR+M9Wv4prT9SPkOcbR
KYMsBgDmhCTQg/nYaOIur1L3piUbnqdxHxfVL/jvj3vF6noJFnKFISeun73nvffg
CUxyL/E/n2YNqg/N+awJfbIZPAcrV0Nxn4j7R2BXy4LirRsq7W/NLd7jntaGR9iJ
KjQY8m8QV++Bzxp+vDcJUNkaMLgUfN5py5QkT6q7Sno0Q67XPh23pTcg6S1CPY+H
ajFsllXA7XkM2CXZXsXnjloisno8nSknOuOx/GHblbJtusAhv2Ml2npNe17rGNYY
7g==
-----END CERTIFICATE-----
```
