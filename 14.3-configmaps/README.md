# Домашнее задание к занятию "14.3 Карты конфигураций"

<details>
<summary>Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube</summary>

## Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать карту конфигураций?

```
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap domain --from-literal=name=netology.ru
```

### Как просмотреть список карт конфигураций?

```
kubectl get configmaps
kubectl get configmap
```

### Как просмотреть карту конфигурации?

```
kubectl get configmap nginx-config
kubectl describe configmap domain
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get configmap nginx-config -o yaml
kubectl get configmap domain -o json
```

### Как выгрузить карту конфигурации и сохранить его в файл?

```
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml
```

### Как удалить карту конфигурации?

```
kubectl delete configmap nginx-config
```

### Как загрузить карту конфигурации из файла?

```
kubectl apply -f nginx-config.yml
```

</details>

## Задача 2 (*): Работа с картами конфигураций внутри модуля

Выбрать любимый образ контейнера, подключить карты конфигураций и проверить
их доступность как в виде переменных окружения, так и в виде примонтированного
тома

**Answer**

[pod.yaml](assets/pod.yaml) - под, запускающий bash скрипт, выводящий содержимое переменной среды и файлы, в которые примонтированы данные из configmap.

```console
% kubectl apply -f assets/pod.yaml
pod/configmap-test created

% kubectl logs configmap-test
-----BEGIN CERTIFICATE----- MIIFbTCCA1WgAwIBAgIUVZKGKPjBnOWz/kKAOjd90ly7Qz0wDQYJKoZIhvcNAQEL BQAwRjELMAkGA1UEBhMCUlUxDzANBgNVBAgMBk1vc2NvdzEPMA0GA1UEBwwGTW9z Y293MRUwEwYDVQQDDAxzZXJ2ZXIubG9jYWwwHhcNMjIxMTIwMTg0MjIwWhcNMzIx MTE3MTg0MjIwWjBGMQswCQYDVQQGEwJSVTEPMA0GA1UECAwGTW9zY293MQ8wDQYD VQQHDAZNb3Njb3cxFTATBgNVBAMMDHNlcnZlci5sb2NhbDCCAiIwDQYJKoZIhvcN AQEBBQADggIPADCCAgoCggIBAMST73Qk8kqFrOJ1f6EXAgSm6mVuUXdvx3SCsRgM Rq1KPup7B7Hc8IPzZyPGixAKSkzglTBjryERY6OHwDlTzyZxNaEGJC/yFR+aS1m0 1bu1YTrEHPV6IPrC5axJNtcA2tJ4e8hBmC8xe75cP50fFGM9LzwfETHBJ/+iX5Qg Rfp/S8ToD3Mk6t85KHuwze/h9gjdSBJkCv1rPlAK/Y7Tc2gisgynmShnj/sxgkYQ VHqz4I/sqXEk5NknQW4dXuMVxD4P1OhXA9/RTCWCN1U/I6YHqHx+xOC13VB1kwZq gFFB2+Im4ryT0Swx9rh/4kNxrtMXuTDhi7CZ/n5ZyEtkjnRh/ZQsDz5xkGz/grvd 2mq03KlnR9tJuwU11TVfGkUvS0LK7xJmuprh7Va3EbDDdf4QayMaYMR69H2MTKOR m70oiUFProlsptOhDq0W16d5ZGtO7JrIPNDgTJjA8DHuu6mQ6CAnq+DKeVvEUws3 VqJPjf7vmrDc8nQYmJYcYN+VT0IJijkOHgAHJLbtfPAh1ZVHRgyjtXheN2ZybYVI 7zZ3d/6K8KF4s41DjN4rvdyt8UR6LBpLWd9SI7N7WzZCtLqYt5al27HXRyzNiE7b idY+nJ75ZjBthNo3r5IfF9nyqWXSQ7lr7R+R9GeMZKdBpB3onG0uVsHnfyQ6vVFJ mVX5AgMBAAGjUzBRMB0GA1UdDgQWBBRXu3K+2Ek0BEENhAVTd2jH5DSkwDAfBgNV HSMEGDAWgBRXu3K+2Ek0BEENhAVTd2jH5DSkwDAPBgNVHRMBAf8EBTADAQH/MA0G CSqGSIb3DQEBCwUAA4ICAQCZa1CeUjxIinIafCU7EU7FNUG7lKMoWPJMHJ3RUx87 B3mrgI68UP+hk02thrZ1rp45u162KjDf6vqXBhEypGPQVakTLPp1ESoBU/WMx6kq 7Ip8Uii/fb6I2ekleMtau2YdIoJ49OpMrVwmSkprnkTkKwGPnanHFR0GoK9q0bwy TmPYFNCVJ5d3LMTcLkkEtxHPnC2qmXWucqwcYmHROrihIx91/WEYFkzVt29uCxC7 JSuIR500qCG32m1yNDsXYiGaRMnCw5sMqYSa7zMh7Aj4h8ObM1pmU//2Qd8O6H81 481jVozYzje9StKylX+jhmv59JRVfG1cVJ4pKIQz4EG+6JTg8ZrB87tv8fk+eWb5 iHSGFHJDElEzGP3pHoc6qwK8B56Q4M6gV+fqYWaeq2+auCnmQpnEKPY6VGIwfXtw 83tQWmesO63Jzy09VxVHvY5oAo4tyyxHWI8Ny5xkAGw7EZ7/NxBnj5Iih/QvVeAZ 4XhEqv71ydMnv2+ie0X0SbrFNEQdIKL+wv2g0OsE9r7/xOOAyl5sF4iMGSFogKHJ 2IlB93YV7BGdnMyv8+6H88WxseQ2/pya3cJTSLjomfLKLDXwz2ClmAqNc3kvhurx D4Jzksq7JJWHxkpW1X4bz81yun8OCOVom1kJTurECDM/Amx3o9jw/8v9gcjukcdB 5A== -----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIFbTCCA1WgAwIBAgIUVZKGKPjBnOWz/kKAOjd90ly7Qz0wDQYJKoZIhvcNAQEL
BQAwRjELMAkGA1UEBhMCUlUxDzANBgNVBAgMBk1vc2NvdzEPMA0GA1UEBwwGTW9z
Y293MRUwEwYDVQQDDAxzZXJ2ZXIubG9jYWwwHhcNMjIxMTIwMTg0MjIwWhcNMzIx
MTE3MTg0MjIwWjBGMQswCQYDVQQGEwJSVTEPMA0GA1UECAwGTW9zY293MQ8wDQYD
VQQHDAZNb3Njb3cxFTATBgNVBAMMDHNlcnZlci5sb2NhbDCCAiIwDQYJKoZIhvcN
AQEBBQADggIPADCCAgoCggIBAMST73Qk8kqFrOJ1f6EXAgSm6mVuUXdvx3SCsRgM
Rq1KPup7B7Hc8IPzZyPGixAKSkzglTBjryERY6OHwDlTzyZxNaEGJC/yFR+aS1m0
1bu1YTrEHPV6IPrC5axJNtcA2tJ4e8hBmC8xe75cP50fFGM9LzwfETHBJ/+iX5Qg
Rfp/S8ToD3Mk6t85KHuwze/h9gjdSBJkCv1rPlAK/Y7Tc2gisgynmShnj/sxgkYQ
VHqz4I/sqXEk5NknQW4dXuMVxD4P1OhXA9/RTCWCN1U/I6YHqHx+xOC13VB1kwZq
gFFB2+Im4ryT0Swx9rh/4kNxrtMXuTDhi7CZ/n5ZyEtkjnRh/ZQsDz5xkGz/grvd
2mq03KlnR9tJuwU11TVfGkUvS0LK7xJmuprh7Va3EbDDdf4QayMaYMR69H2MTKOR
m70oiUFProlsptOhDq0W16d5ZGtO7JrIPNDgTJjA8DHuu6mQ6CAnq+DKeVvEUws3
VqJPjf7vmrDc8nQYmJYcYN+VT0IJijkOHgAHJLbtfPAh1ZVHRgyjtXheN2ZybYVI
7zZ3d/6K8KF4s41DjN4rvdyt8UR6LBpLWd9SI7N7WzZCtLqYt5al27HXRyzNiE7b
idY+nJ75ZjBthNo3r5IfF9nyqWXSQ7lr7R+R9GeMZKdBpB3onG0uVsHnfyQ6vVFJ
mVX5AgMBAAGjUzBRMB0GA1UdDgQWBBRXu3K+2Ek0BEENhAVTd2jH5DSkwDAfBgNV
HSMEGDAWgBRXu3K+2Ek0BEENhAVTd2jH5DSkwDAPBgNVHRMBAf8EBTADAQH/MA0G
CSqGSIb3DQEBCwUAA4ICAQCZa1CeUjxIinIafCU7EU7FNUG7lKMoWPJMHJ3RUx87
B3mrgI68UP+hk02thrZ1rp45u162KjDf6vqXBhEypGPQVakTLPp1ESoBU/WMx6kq
7Ip8Uii/fb6I2ekleMtau2YdIoJ49OpMrVwmSkprnkTkKwGPnanHFR0GoK9q0bwy
TmPYFNCVJ5d3LMTcLkkEtxHPnC2qmXWucqwcYmHROrihIx91/WEYFkzVt29uCxC7
JSuIR500qCG32m1yNDsXYiGaRMnCw5sMqYSa7zMh7Aj4h8ObM1pmU//2Qd8O6H81
481jVozYzje9StKylX+jhmv59JRVfG1cVJ4pKIQz4EG+6JTg8ZrB87tv8fk+eWb5
iHSGFHJDElEzGP3pHoc6qwK8B56Q4M6gV+fqYWaeq2+auCnmQpnEKPY6VGIwfXtw
83tQWmesO63Jzy09VxVHvY5oAo4tyyxHWI8Ny5xkAGw7EZ7/NxBnj5Iih/QvVeAZ
4XhEqv71ydMnv2+ie0X0SbrFNEQdIKL+wv2g0OsE9r7/xOOAyl5sF4iMGSFogKHJ
2IlB93YV7BGdnMyv8+6H88WxseQ2/pya3cJTSLjomfLKLDXwz2ClmAqNc3kvhurx
D4Jzksq7JJWHxkpW1X4bz81yun8OCOVom1kJTurECDM/Amx3o9jw/8v9gcjukcdB
5A==
-----END CERTIFICATE-----
```