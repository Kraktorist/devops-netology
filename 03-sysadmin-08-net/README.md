# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```  
**Answer**  

        route-views>show ip route 178.176.74.23
        Routing entry for 178.176.72.0/21
        Known via "bgp 6447", distance 20, metric 0
        Tag 6939, type external
        Last update from 64.71.137.241 5w3d ago
        Routing Descriptor Blocks:
        * 64.71.137.241, from 64.71.137.241, 5w3d ago
            Route metric is 0, traffic share count is 1
            AS Hops 3
            Route tag 6939
            MPLS label: none

        route-views>show ip bgp 178.176.72.0/21 longer-prefixes
        BGP table version is 1395448425, local router ID is 128.223.51.103
        Status codes: s suppressed, d damped, h history, * valid, > best, i - internal,
                    r RIB-failure, S Stale, m multipath, b backup-path, f RT-Filter,
                    x best-external, a additional-path, c RIB-compressed,
        Origin codes: i - IGP, e - EGP, ? - incomplete
        RPKI validation codes: V valid, I invalid, N Not found

            Network          Next Hop            Metric LocPrf Weight Path
        N*   178.176.72.0/21  217.192.89.50                          0 3303 31133 25159 i
        N*                    162.250.137.254                        0 4901 6079 31133 25159 i
        N*                    203.181.248.168                        0 7660 2516 174 31133 25159 i
        N*                    194.85.40.15             0             0 3267 31133 25159 i
        N*                    37.139.139.17            0             0 57866 6830 174 31133 25159 i
        N*                    12.0.1.63                              0 7018 174 31133 25159 i
        N*                    193.0.0.56                             0 3333 1103 31133 25159 i
        N*                    91.218.184.60                          0 49788 12552 31133 25159 i
        N*                    212.66.96.126                          0 20912 3257 174 31133 25159 i
        N*                    94.142.247.3             0             0 8283 31133 25159 i
        N*                    4.68.4.46                0             0 3356 174 31133 25159 i
        N*                    154.11.12.212            0             0 852 31133 25159 i
        N*                    203.62.252.83                          0 1221 4637 31133 25159 i
        N*                    202.232.0.2                            0 2497 174 31133 25159 i
        N*                    140.192.8.16                           0 20130 6939 31133 25159 i
        N*                    137.39.3.55                            0 701 174 31133 25159 i
        N*                    89.149.178.10           10             0 3257 174 31133 25159 i
        N*                    208.51.134.254           0             0 3549 3356 174 31133 25159 i
        N*                    162.251.163.2                          0 53767 174 31133 25159 i
        N*                    209.124.176.223                        0 101 11164 2603 31133 25159 i
        N*                    206.24.210.80                          0 3561 209 3356 174 31133 25159 i
        N*                    132.198.255.253                        0 1351 6939 31133 25159 i
        N*>                   64.71.137.241                          0 6939 31133 25159 i
        N*                    208.74.64.40                           0 19214 174 31133 25159 i


2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.  
**Answer**

        root@vagrant:~# modprobe -v dummy numdummies=2
        root@vagrant:~# ip address add 10.0.0.45/24 dev dummy0
        root@vagrant:~# ip link set dummy0 up
        root@vagrant:~# ip addr show dummy0
        3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
            link/ether 56:f3:d2:ed:65:4e brd ff:ff:ff:ff:ff:ff
            inet 10.0.0.45/24 scope global dummy0
            valid_lft forever preferred_lft forever
            inet6 fe80::54f3:d2ff:feed:654e/64 scope link
            valid_lft forever preferred_lft forever

        root@vagrant:~# ip route add 10.1.1.0/24 via 10.0.0.1 dev dummy0
        root@vagrant:~# ip route add 172.16.1.0/24 via 10.0.0.30 dev dummy0
        root@vagrant:~# ip route
        default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
        10.0.0.0/24 dev dummy0 proto kernel scope link src 10.0.0.45
        10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
        10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
        10.1.1.0/24 via 10.0.0.1 dev dummy0
        172.16.1.0/24 via 10.0.0.30 dev dummy0

3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.  
**Answer**

        root@vagrant:~# netstat -tnap
        Active Internet connections (servers and established)
        Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
        tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      1/init
        tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      556/systemd-resolve
        tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      804/sshd: /usr/sbin
        tcp        0      0 10.0.2.15:22            10.0.2.2:51724          ESTABLISHED 1816/sshd: vagrant
        tcp6       0      0 :::111                  :::*                    LISTEN      1/init
        tcp6       0      0 :::22                   :::*                    LISTEN      804/sshd: /usr/sbin

        root@vagrant:~# ss -tanp
        State        Recv-Q       Send-Q              Local Address:Port               Peer Address:Port        Process
        LISTEN       0            4096                      0.0.0.0:111                     0.0.0.0:*            users:(("rpcbind",pid=554,fd=4),("systemd",pid=1,fd=53))
        LISTEN       0            4096                127.0.0.53%lo:53                      0.0.0.0:*            users:(("systemd-resolve",pid=556,fd=13))
        LISTEN       0            128                       0.0.0.0:22                      0.0.0.0:*            users:(("sshd",pid=804,fd=3))
        ESTAB        0            0                       10.0.2.15:22                     10.0.2.2:51724        users:(("sshd",pid=1853,fd=4),("sshd",pid=1816,fd=4))
        LISTEN       0            4096                         [::]:111                        [::]:*            users:(("rpcbind",pid=554,fd=6),("systemd",pid=1,fd=55))
        LISTEN       0            128                          [::]:22                         [::]:*            users:(("sshd",pid=804,fd=4))


4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?  
**Answer**

        root@vagrant:~# ss -uanp
        State        Recv-Q       Send-Q               Local Address:Port               Peer Address:Port       Process
        UNCONN       0            0                    127.0.0.53%lo:53                      0.0.0.0:*           users:(("systemd-resolve",pid=556,fd=12))
        UNCONN       0            0                   10.0.2.15%eth0:68                      0.0.0.0:*           users:(("systemd-network",pid=394,fd=19))
        UNCONN       0            0                          0.0.0.0:111                     0.0.0.0:*           users:(("rpcbind",pid=554,fd=5),("systemd",pid=1,fd=54))
        UNCONN       0            0                             [::]:111                        [::]:*           users:(("rpcbind",pid=554,fd=7),("systemd",pid=1,fd=56))



5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.  
**Answer**

![Network](img/net.png)