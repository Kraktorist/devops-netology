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



1. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

1. Создайте 2 независимых PV на получившихся md-устройствах.

1. Создайте общую volume-group на этих двух PV.

1. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

1. Создайте `mkfs.ext4` ФС на получившемся LV.

1. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

1. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

1. Прикрепите вывод `lsblk`.

1. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```

1. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

1. Сделайте `--fail` на устройство в вашем RAID1 md.

1. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

1. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```

1. Погасите тестовый хост, `vagrant destroy`.
