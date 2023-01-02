#!/bin/bash

clear

echo "gdisk"
#n enterx2 +300M ef00 boot
#n "     " +8G 	 8200 swap
#

gdisk /dev/sda

sleep 5
clear
#CRYPT... FORMAT
cryptsetup --cipher aes-xts-plain64 --hash sha512 --use-random --verify-passphrase luksFormat /dev/sda3
#CERYPT... OPEN
cryptsetup luksOpen /dev/sda3 io
#BTRFS
mkfs.btrfs /dev/mapper/io
sleep 5
clear
#SUBVOLUME
mount /dev/mapper/io /mnt
cd /mnt
btrfs subvolume create @
btrfs subvolume create @home
cd
umount /mnt
sleep 5
#ROOT
mount -o noatime,compress=zstd,space_cache=v2,ssd,discard=async,subvol=@ /dev/mapper/io /mnt
#HOOME
mkdir /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,ssd,discard=async,subvol=@home /dev/mapper/io /mnt/home
#BOOT
mkfs.vfat -F32 -n EFI /dev/sda1
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
#SWAP
mkswap /dev/sda2
swapon /dev/sda2
#BASE PKG
pacstrap -i /mnt base base-devel linux linux-headers linux-firmware git nano intel-ucode btrfs-progs
#FSTAB
genfstab -U /mnt >> /mnt/etc/fstab
#CHROOT
arch-chroot /mnt
