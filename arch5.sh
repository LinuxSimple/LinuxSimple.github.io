loadkeys ru

setfont cyr-sun16

echo '2.3 Синхронизация системных часов'

timedatectl set-ntp true

echo '2.4 создание разделов'

(

echo o;

echo n;

echo;

echo;

echo;

echo +51200M;

echo w;

) | fdisk /dev/sda

echo 'Ваша разметка диска'

fdisk -l

echo '2.4.2 Форматирование дисков'

mkfs.btrfs -f /dev/sda1 -L Диск

echo '2.4.3 Монтирование дисков'

mount /dev/sda1 /mnt

btrfs subvolume create /mnt/sv_root

umount /mnt

mount -o subvol=sv_root,compress=zstd,autodefrag /dev/sda1 /mnt

echo '3.1 Выбор зеркал для загрузки. Ставим зеркало'

echo "Server = http://mirror.mirohost.net/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'

pacstrap /mnt base base-devel linux-lts linux-firmware

echo '3.3 Настройка системы'

genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL LinuxSimple.github.io/arch2.sh)"
