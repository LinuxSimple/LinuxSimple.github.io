loadkeys ru

setfont cyr-sun16

echo '2.3 ������������� ��������� �����'

timedatectl set-ntp true

echo '2.4 �������� ��������'

(

echo o;

echo n;

echo;

echo;

echo;

echo +40G;

echo w;

) | fdisk /dev/sda

echo '���� �������� �����'

fdisk -l

echo '2.4.2 �������������� ������'

mkfs.ext4 /dev/sda1 -L root

echo '2.4.3 ������������ ������'

mount /dev/sda1 /mnt
#mount -o nodiratime,noatime /dev/sda1 /mnt
echo '3.1 ����� ������ ��� ��������. ������ �������'

echo "Server = http://mirror.mirohost.net/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 ��������� �������� �������'

pacstrap /mnt base base-devel linux-lts linux-firmware

echo '3.3 ��������� �������'

genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL LinuxSimple.github.io/arch2.sh)"