# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.  
**Answer**

        vagrant@vagrant:/tmp$ dd if=/dev/zero of=./sparse-file bs=1 count=0 seek=20G
        0+0 records in
        0+0 records out
        0 bytes copied, 0.000235269 s, 0.0 kB/s
        vagrant@vagrant:/tmp$ ls -l ./sparse-file
        -rw-rw-r-- 1 vagrant vagrant 21474836480 Dec  1 18:09 ./sparse-file


1. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?  
**Answer**

        # No because owner and ACL are the attributes of inode. Any file and all hardlinks linked to it have the same inode and the same attributes.

        vagrant@vagrant:/tmp$ touch file
        vagrant@vagrant:/tmp$ ln file link_to_file
        vagrant@vagrant:/tmp$ ls -la *file
        -rw-rw-r-- 2 vagrant vagrant 0 Dec  1 18:10 file
        -rw-rw-r-- 2 vagrant vagrant 0 Dec  1 18:10 link_to_file
        vagrant@vagrant:/tmp$ chmod 777 link_to_file

        vagrant@vagrant:/tmp$ stat --format=%i\ %a\ %n *file
        3670030 777 file
        3670030 777 link_to_file


1. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.  
**Answer**

        vagrant@vagrant:~$ sudo fdisk -l | grep 'Disk /dev'
        Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
        Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk /dev/mapper/vgvagrant-root: 62.55 GiB, 67150807040 bytes, 131153920 sectors
        Disk /dev/mapper/vgvagrant-swap_1: 980 MiB, 1027604480 bytes, 2007040 sectors


1. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.  
**Answer**

        vagrant@vagrant:~$ sudo fdisk -l | grep '/dev'
        Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
        /dev/sda1  *       2048   1050623   1048576  512M  b W95 FAT32
        /dev/sda2       1052670 134215679 133163010 63.5G  5 Extended
        /dev/sda5       1052672 134215679 133163008 63.5G 8e Linux LVM
        Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        /dev/sdb1          2048 4196351 4194304    2G 83 Linux
        /dev/sdb2       4196352 5242879 1046528  511M 83 Linux
        Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk /dev/mapper/vgvagrant-root: 62.55 GiB, 67150807040 bytes, 131153920 sectors
        Disk /dev/mapper/vgvagrant-swap_1: 980 MiB, 1027604480 bytes, 2007040 sectors


1. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.  
**Answer**

        root@vagrant:~# sfdisk --dump /dev/sdb | sfdisk /dev/sdc
        Checking that no-one is using this disk right now ... OK

        Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk model: VBOX HARDDISK
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes

        >>> Script header accepted.
        >>> Script header accepted.
        >>> Script header accepted.
        >>> Script header accepted.
        >>> Created a new DOS disklabel with disk identifier 0x8414740b.
        /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
        /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
        /dev/sdc3: Done.

        New situation:
        Disklabel type: dos
        Disk identifier: 0x8414740b

        Device     Boot   Start     End Sectors  Size Id Type
        /dev/sdc1          2048 4196351 4194304    2G 83 Linux
        /dev/sdc2       4196352 5242879 1046528  511M 83 Linux

        The partition table has been altered.
        Calling ioctl() to re-read partition table.
        Syncing disks.
        root@vagrant:~# fdisk -l | grep '/dev'
        Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
        /dev/sda1  *       2048   1050623   1048576  512M  b W95 FAT32
        /dev/sda2       1052670 134215679 133163010 63.5G  5 Extended
        /dev/sda5       1052672 134215679 133163008 63.5G 8e Linux LVM
        Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        /dev/sdb1          2048 4196351 4194304    2G 83 Linux
        /dev/sdb2       4196352 5242879 1046528  511M 83 Linux
        Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        /dev/sdc1          2048 4196351 4194304    2G 83 Linux
        /dev/sdc2       4196352 5242879 1046528  511M 83 Linux
        Disk /dev/mapper/vgvagrant-root: 62.55 GiB, 67150807040 bytes, 131153920 sectors
        Disk /dev/mapper/vgvagrant-swap_1: 980 MiB, 1027604480 bytes, 2007040 sectors


1. Соберите `mdadm` RAID1 на паре разделов 2 Гб.  
**Answer**

        root@vagrant:~# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[bc]1 
 
1. Соберите `mdadm` RAID0 на второй паре маленьких разделов.  
**Answer**  

        root@vagrant:~# mdadm --create /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2  
        root@vagrant:~# mdadm --detail --scan
        ARRAY /dev/md0 metadata=1.2 name=vagrant:0 UUID=25cf748e:48e298db:a86f4242:b418c6e3
        ARRAY /dev/md1 metadata=1.2 name=vagrant:1 UUID=3072a1a7:83064551:eea82786:5915f1a6


1. Создайте 2 независимых PV на получившихся md-устройствах.  
**Answer**

        root@vagrant:~# pvcreate /dev/md0                 
        Physical volume "/dev/md0" successfully created.
        root@vagrant:~# pvcreate /dev/md1                 
        Physical volume "/dev/md1" successfully created.
        root@vagrant:~# pvs
        PV         VG        Fmt  Attr PSize    PFree
        /dev/md0             lvm2 ---    <2.00g   <2.00g
        /dev/md1             lvm2 ---  1018.00m 1018.00m
        /dev/sda5  vgvagrant lvm2 a--   <63.50g       0

1. Создайте общую volume-group на этих двух PV.  
**Answer**

        root@vagrant:~# vgcreate vg_shared /dev/md0 /dev/md1
        Volume group "vg_shared" successfully created
        root@vagrant:~# vgs
        VG        #PV #LV #SN Attr   VSize   VFree
        vg_shared   2   0   0 wz--n-  <2.99g <2.99g
        vgvagrant   1   2   0 wz--n- <63.50g     0
                

1. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.  
**Answer**

        root@vagrant:~# lvcreate -L 100M -n lv_100M /dev/mapper/vg_shared /dev/md1 
        Logical volume "lv_100M" created.                                        
        root@vagrant:~# lvdisplay /dev/vg_shared/lv_100M
        --- Logical volume ---
        LV Path                /dev/vg_shared/lv_100M
        LV Name                lv_100M
        VG Name                vg_shared
        LV UUID                VcBGs9-0Akf-8vVC-yARz-nfNb-VmWw-i31h5E
        LV Write Access        read/write
        LV Creation host, time vagrant, 2021-12-02 18:09:38 +0000
        LV Status              available
        # open                 0
        LV Size                100.00 MiB
        Current LE             25
        Segments               1
        Allocation             inherit
        Read ahead sectors     auto
        - currently set to     4096
        Block device           253:2

1. Создайте `mkfs.ext4` ФС на получившемся LV.  
**Answer**

        root@vagrant:~# mkfs.ext4 /dev/vg_shared/lv_100M
        mke2fs 1.45.5 (07-Jan-2020)
        Creating filesystem with 25600 4k blocks and 25600 inodes

        Allocating group tables: done
        Writing inode tables: done
        Creating journal (1024 blocks): done
        Writing superblocks and filesystem accounting information: done

1. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.  
**Answer**

        root@vagrant:~# mount /dev/vg_shared/lv_100M /mnt
        root@vagrant:~# df -h
        Filesystem                     Size  Used Avail Use% Mounted on
        udev                           447M     0  447M   0% /dev
        tmpfs                           99M  700K   98M   1% /run
        /dev/mapper/vgvagrant-root      62G  1.5G   57G   3% /
        tmpfs                          491M     0  491M   0% /dev/shm
        tmpfs                          5.0M     0  5.0M   0% /run/lock
        tmpfs                          491M     0  491M   0% /sys/fs/cgroup
        /dev/sda1                      511M  4.0K  511M   1% /boot/efi
        vagrant                        238G   13G  226G   6% /vagrant
        tmpfs                           99M     0   99M   0% /run/user/1000
        /dev/mapper/vg_shared-lv_100M   93M   72K   86M   1% /mnt


1. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.  
**Answer**

        root@vagrant:/mnt# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O test.gz
        --2021-12-02 18:19:12--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
        Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
        Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
        HTTP request sent, awaiting response... 200 OK
        Length: 22715138 (22M) [application/octet-stream]
        Saving to: ‘test.gz’

        test.gz                                   100%[=====================================================================================>]  21.66M  8.55MB/s    in 2.5s

        2021-12-02 18:19:14 (8.55 MB/s) - ‘test.gz’ saved [22715138/22715138]


1. Прикрепите вывод `lsblk`.  
**Answer**

        root@vagrant:/mnt# lsblk
        NAME                    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
        sda                       8:0    0   64G  0 disk
        ├─sda1                    8:1    0  512M  0 part  /boot/efi
        ├─sda2                    8:2    0    1K  0 part
        └─sda5                    8:5    0 63.5G  0 part
        ├─vgvagrant-root      253:0    0 62.6G  0 lvm   /
        └─vgvagrant-swap_1    253:1    0  980M  0 lvm   [SWAP]
        sdb                       8:16   0  2.5G  0 disk
        ├─sdb1                    8:17   0    2G  0 part
        │ └─md0                   9:0    0    2G  0 raid1
        └─sdb2                    8:18   0  511M  0 part
        └─md1                   9:1    0 1018M  0 raid0
        └─vg_shared-lv_100M 253:2    0  100M  0 lvm   /mnt
        sdc                       8:32   0  2.5G  0 disk
        ├─sdc1                    8:33   0    2G  0 part
        │ └─md0                   9:0    0    2G  0 raid1
        └─sdc2                    8:34   0  511M  0 part
        └─md1                   9:1    0 1018M  0 raid0
        └─vg_shared-lv_100M 253:2    0  100M  0 lvm   /mnt


1. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```  
   **Answer**

        root@vagrant:/mnt# gzip -t /mnt/test.gz
        root@vagrant:/mnt# echo $?
        0


1. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.  
**Answer**

        root@vagrant:~# pvmove /dev/md1 /dev/md0     
        /dev/md1: Moved: 16.00%                    
        /dev/md1: Moved: 100.00%                   

1. Сделайте `--fail` на устройство в вашем RAID1 md.  
**Answer**

        root@vagrant:/# mdadm /dev/md0 --fail /dev/sdc1
        mdadm: set /dev/sdc1 faulty in /dev/md0        

2. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.  
**Answer**

        root@vagrant:/# dmesg | grep raid1\:md0                                                 
        [ 4334.075771] md/raid1:md0: Disk failure on sdc1, disabling device.         
                md/raid1:md0: Operation continuing on 1 devices.              

3. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```   
    **Answer**   

        root@vagrant:/mnt# gzip -t /mnt/test.gz
        root@vagrant:/mnt# echo $?  
        0               

4. Погасите тестовый хост, `vagrant destroy`.  
**Answer**  

        poweroff