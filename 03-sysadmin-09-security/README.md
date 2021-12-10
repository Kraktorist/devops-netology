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

        root@vagrant:~# cat <<EOT > /etc/ssh_config.d/example.conf
        Host test
        HostName 192.168.0.14
        User kraktorist
        IdentityFile ~/id_rsa_new
        EOT

        vagrant@vagrant:~$ mv ~/.ssh/id_rsa ~/id_rsa_new

        vagrant@vagrant:~$ ssh -v test
        OpenSSH_8.2p1 Ubuntu-4ubuntu0.2, OpenSSL 1.1.1f  31 Mar 2020
        debug1: Reading configuration data /etc/ssh/ssh_config
        debug1: Reading configuration data /etc/ssh/ssh_config.d/example.conf
        debug1: /etc/ssh/ssh_config.d/example.conf line 1: Applying options for test
        debug1: /etc/ssh/ssh_config line 21: Applying options for *
        debug1: Connecting to 192.168.0.14 [192.168.0.14] port 22.
        debug1: Connection established.
        debug1: identity file /home/vagrant/id_rsa_new type -1
        debug1: identity file /home/vagrant/id_rsa_new-cert type -1
        ...
        debug1: Authenticating to 192.168.0.14:22 as 'kraktorist'
        ...
        debug1: Next authentication method: publickey
        debug1: Trying private key: /home/vagrant/id_rsa_new
        debug1: Authentication succeeded (publickey).
        ...
        Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)
        ...


7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.  

    **Answer**

        vagrant@vagrant:~$ sudo t^Cdump --interface any -c 100 -w 100.pcap
        vagrant@vagrant:~$ tshark -r 100.pcap -T tabs
            1	  0.000000	   10.0.2.15	→	10.0.2.2    	SSH	124	Server: Encrypted packet (len=68)
            2	  0.000276	    10.0.2.2	→	10.0.2.15   	TCP	62	51108 → 22 [ACK] Seq=1 Ack=69 Win=65535 Len=0
            3	  6.666119	192.168.0.14	→	192.168.0.37	TCP	76	49668 → 443 [SYN] Seq=0 Win=64240 Len=0 MSS=1460 SACK_PERM=1 TSval=1842455698 TSecr=0 WS=128
            4	  6.666141	192.168.0.37	→	192.168.0.14	TCP	76	443 → 49668 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=4045874961 TSecr=1842455698 WS=128
            5	  6.666252	192.168.0.14	→	192.168.0.37	TCP	68	49668 → 443 [ACK] Seq=1 Ack=1 Win=64256 Len=0 TSval=1842455698 TSecr=4045874961
            6	  6.670860	192.168.0.14	→	192.168.0.37	TLSv1	585	Client Hello
            7	  6.670884	192.168.0.37	→	192.168.0.14	TCP	68	443 → 49668 [ACK] Seq=1 Ack=518 Win=64768 Len=0 TSval=4045874966 TSecr=1842455702
            8	  6.671908	192.168.0.37	→	192.168.0.14	TLSv1.3	1614	Server Hello, Change Cipher Spec, Application Data, Application Data, Application Data, Application Data
            9	  6.671975	192.168.0.14	→	192.168.0.37	TCP	68	49668 → 443 [ACK] Seq=518 Ack=1547 Win=64128 Len=0 TSval=1842455704 TSecr=4045874967
        10	  6.672317	192.168.0.14	→	192.168.0.37	TLSv1.3	148	Change Cipher Spec, Application Data
        11	  6.672318	192.168.0.14	→	192.168.0.37	TLSv1.3	166	Application Data
        12	  6.672324	192.168.0.37	→	192.168.0.14	TCP	68	443 → 49668 [ACK] Seq=1547 Ack=598 Win=64768 Len=0 TSval=4045874967 TSecr=1842455704
        13	  6.672338	192.168.0.37	→	192.168.0.14	TCP	68	443 → 49668 [ACK] Seq=1547 Ack=696 Win=64768 Len=0 TSval=4045874967 TSecr=1842455704
        14	  6.672448	192.168.0.37	→	192.168.0.14	TLSv1.3	339	Application Data
        15	  6.672506	192.168.0.14	→	192.168.0.37	TCP	68	49668 → 443 [ACK] Seq=696 Ack=1818 Win=64128 Len=0 TSval=1842455704 TSecr=4045874967
        16	  6.672527	192.168.0.37	→	192.168.0.14	TLSv1.3	339	Application Data
        17	  6.672582	192.168.0.14	→	192.168.0.37	TCP	68	49668 → 443 [ACK] Seq=696 Ack=2089 Win=64128 Len=0 TSval=1842455704 TSecr=4045874967
        18	  6.672656	192.168.0.37	→	192.168.0.14	TLSv1.3	416	Application Data
        19	  6.672717	192.168.0.14	→	192.168.0.37	TCP	68	49668 → 443 [ACK] Seq=696 Ack=2437 Win=64128 Len=0 TSval=1842455704 TSecr=4045874967
   