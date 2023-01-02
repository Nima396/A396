#!/bin/bash

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
cat /etc/locale.conf

sleep 5

clear

nano /etc/locale.gen
locale-gen

clear

echo "nine" >> /etc/hostname
cat /etc/hostname

sleep 5
clear

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 nine.localdomin nine" >> /etc/hosts
cat /etc/hosts

sleep 7
clear

pacman -S grub efibootmgr networkmanager dialog wpa_supplicant vim wget reflector grub-btrfs

clear
 
sed -i "s|^MODULES=.*|MODULES=(btrfs)|g" /etc/mkinitcpio.conf
sed -i "s|^HOOKS=.*|HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)|g" /etc/mkinitcpio.conf

mkinitcpio -p linux

sleep 10
clear

blkid -s UUID -o value /dev/sda3

read -p "Please enter UUID: " uuid
sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID='$uuid':io root=/dev/mapper/io"|g' /etc/default/grub

nano /etc/default/grub

passwd

useradd -m -g users -G wheel -s /bin/bash nima
passwd nima
EDITOR=nano visudo

rm /sys/firmware/efi/efivars/dump-*
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
sleep 10

grub-mkconfig -o /boot/grub/grub.cfg

sleep 10

exit
