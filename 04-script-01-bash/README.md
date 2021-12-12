# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | it's a simple string. The same as `abc`, `"a+b"`, or `+++`. |
| `d`  | 1+2  | It's a string with interpolated variables `$a` and `$b`. The same as `${a}+${b}`|
| `e`  | 3  | `$((...))` is a special syntax for arithmetic operations which calculates expression inside of parenthesis and returns the result. It's not even requires dollar signs inside of the parenthesis `$((a+b))` |


## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1))
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date > curl.log
	fi
done
```

Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
#!/bin/bash
log="log"
>$log
for target in 192.168.0.1 173.194.222.113 87.250.250.242
do
  counter=1
  while [ $counter -le 5 ]
  do
    curl --max-time 10 "http://${target}">/dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo "[ERR] ${target} is not available.Attempt: ${counter}">>$log
    else
      echo "[INFO] ${target} is available. Attempt: ${counter}">>$log
    fi
    ((counter++))
  done
done
```

## Обязательная задача 3
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
#!/bin/bash
log="log"
err="error"
>$log
>$err
counter=0
while ((1==1))
do
  ((counter++))
  for target in 192.168.0.1 173.194.222.113 87.250.250.242
  do
    curl --max-time 10 "http://${target}">/dev/null 2>&1
    exitcode=$?
    if [ $exitcode -ne 0 ]; then
      echo "[ERR] ${target} is not available.Attempt: ${counter}">>$log
      echo $target>$err
      exit $exitcode
    else
      echo "[INFO] ${target} is available. Attempt: ${counter}">>$log
    fi
  done
done
```
