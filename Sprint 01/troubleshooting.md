Проблема 1: Сетевой интерфейс не получал IP 

*Причина* команда 'ip a' показывала enp0s3 в состоянии down, нет IP адреса

*Решение:

'''bash
sudo ip link set enp0s3 up
sudo dhcpcd enp0s3

*Для того чтоб не повторялась проблема был настроен netplan*

sudo nano /etc/netplan/50-cloud-init.yaml

Содержимое:

  network:
    version: 2
    ethernets:
      enp0s3:
        dhcp4: true

sudo netplan apply

Проблема 2: apt не может скачать пакеты

 *Причина*  VM не имела  доступа к интернету

  *Решение: Настроил сеть   Проблема 1), после применил:
sudo apt update

Проблема 3: SSH cервер не был установлен

*Решение:
sudo apt update
sudo apt install openssh-server -y
sudo systemctl enable --now ssh
