# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"

1. Установите Bitwarden плагин для браузера. Зарегистрируйтесь и сохраните несколько паролей.  

    **Answer**

        Completed

2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.

    **Answer**

        Completed

3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.  
  
    **Answer**

        root@vagrant:~# apt-get install nginx -y
        root@vagrant:~# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

        root@vagrant:~# cat <<EOT > /etc/nginx/conf.d/example.com.conf
        server {
            listen 443 ssl;
            listen [::]:443 ssl;
            ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
            ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
            root /var/www/example.com/html;
            index index.html;
        }
        EOT
        root@vagrant:~# systemctl enable nginx
        root@vagrant:~# systemctl start nginx
        root@vagrant:~# curl -vvkI https://127.0.0.1 2>&1 | grep -A 5 'Server certificate'
        * Server certificate:
        *  subject: C=RU; ST=Some-State; L=MSK; O=Internet Widgits Pty Ltd; CN=test-server.example.com
        *  start date: Dec  9 19:34:15 2021 GMT
        *  expire date: Dec  9 19:34:15 2022 GMT
        *  issuer: C=RU; ST=Some-State; L=MSK; O=Internet Widgits Pty Ltd; CN=test-server.example.com
        *  SSL certificate verify result: self signed certificate (18), continuing anyway.


4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).  

    **Answer**

        root@vagrant:~/testssl.sh# ./testssl.sh -U --quiet https://sha1-2017.badssl.com/

        Start 2021-12-09 20:09:56        -->> 104.154.89.105:443 (sha1-2017.badssl.com) <<--

        rDNS (104.154.89.105):  105.89.154.104.bc.googleusercontent.com.
        Service detected:       HTTP


        Testing vulnerabilities 

        Heartbleed (CVE-2014-0160)                not vulnerable (OK), timed out
        CCS (CVE-2014-0224)                       not vulnerable (OK)
        Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
        ROBOT                                     not vulnerable (OK)
        Secure Renegotiation (RFC 5746)           supported (OK)
        Secure Client-Initiated Renegotiation     not vulnerable (OK)
        CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
        BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested
                                                Can be ignored for static pages or if no secrets in the page
        POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
        TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
        SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
        FREAK (CVE-2015-0204)                     not vulnerable (OK)
        DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                                make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                                https://censys.io/ipv4?q=141758610BD4D119C58E945674C6DB2BD85E404BD6197AF2EC8B80B8587268AB could help you to find out
        LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no common prime detected
        BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA DHE-RSA-AES128-SHA DHE-RSA-AES256-SHA
                                                        ECDHE-RSA-DES-CBC3-SHA AES128-SHA AES256-SHA DES-CBC3-SHA DHE-RSA-CAMELLIA256-SHA
                                                        CAMELLIA256-SHA DHE-RSA-CAMELLIA128-SHA CAMELLIA128-SHA 
                                                VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
        LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
        Winshock (CVE-2014-6321), experimental    not vulnerable (OK) - CAMELLIA or ECDHE_RSA GCM ciphers found
        RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


        Done 2021-12-09 20:11:35 [ 101s] -->> 104.154.89.105:443 (sha1-2017.badssl.com) <<--



5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.  

    **Answer**

        vagrant@vagrant:~$ cat /dev/zero | ssh-keygen -q -N ""
        Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):

        vagrant@vagrant:~$ ssh-copy-id kraktorist@192.168.0.14
        /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
        The authenticity of host '192.168.0.14 (192.168.0.14)' can't be established.
        ECDSA key fingerprint is SHA256:rdrCLJxzYW8I47h8j6lHhUcvSkOUGfXD/RC/wBGCokU.
        Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
        /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
        /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
        kraktorist@192.168.0.14's password: 

        Number of key(s) added: 1

        Now try logging into the machine, with:   "ssh 'kraktorist@192.168.0.14'"
        and check to make sure that only the key(s) you wanted were added.

        vagrant@vagrant:~$ ssh 'kraktorist@192.168.0.14'
        Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента так, чтобы вход на удаленный сервер осуществлялся по имени сервера.  

    **Answer**  

    ...

7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

8*. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

9*. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443