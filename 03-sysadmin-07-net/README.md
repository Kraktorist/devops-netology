# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?  
**Answer**  

        # for Windows
        ipconfig
        netsh interface show interface
        Get-NetAdapter

        # for linux
        ip link
        ls /sys/class/net
        nmcli device status
        ifconfig

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?  
**Answer**

        lldpd package
        lldpctl

1. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.  
**Answer**

        # apt-get install vlan
        # cat /etc/network/interfaces
        auto eth0.100
        iface eth0.100 inet dhcp
            vlan-raw-device eth0

3. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.  
**Answer**

        balance-rr or 0 — Sets a round-robin policy for fault tolerance and load balancing.
        active-backup or 1 — Sets an active-backup policy for fault tolerance.
        balance-xor or 2 — Transmissions are based on the selected hash policy. 
        broadcast or 3 — Sets a broadcast policy for fault tolerance.
        802.3ad or 4 — Sets an IEEE 802.3ad dynamic link aggregation policy. For fault tolerance and load balancing.
        balance-tlb or 5 — Sets a Transmit Load Balancing (TLB) policy for fault tolerance and load balancing.
        balance-alb or 6 — Sets an Adaptive Load Balancing (ALB) policy for fault tolerance and load balancing.

        # cat /etc/network/interfaces
        auto bond0
        iface bond0 inet static
            address 10.31.1.5
            netmask 255.255.255.0
            network 10.31.1.0
            gateway 10.31.1.254
            bond-slaves eth0 eth1
            bond-mode active-backup
            bond-miimon 100
            bond-downdelay 200
            bond-updelay 200

4. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.  
**Answer**

      - 8 addresses: 6 for hosts, 1 for broadcasting and 1 for the network itself
      - 32 subnets
      - 10.10.10.0/29
        10.10.10.8/29
        10.10.10.16/29
        ...

5. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.  
**Answer**  

        There is a special subnet 100.64.0.0/10 described in RFC6890 and RFC6598 as a shared address space.
        So we can take a range 100.64.0.0/26 from it.

6. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

        # for Windows
        arp -a
        arp -d 192.168.0.1
        arp -d *

        # for Linux
        arp [-n]
        arp -d 192.168.0.1      # or
        ip neigh del 10.0.2.2 lladdr 52:54:00:12:35:02 dev eth0
        ip neigh flush