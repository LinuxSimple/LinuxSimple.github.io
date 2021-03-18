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

echo +40G;

echo w;

) | fdisk /dev/sda

echo 'Ваша разметка диска'

fdisk -l

echo '2.4.2 Форматирование дисков'

mkfs.btrfs /dev/sda1 -L root

echo '2.4.3 Монтирование дисков'

mkdir /mnt/btrfs-root
mount -o defaults,relatime,discard,ssd,nodev,nosuid /dev/sda1 /mnt/btrfs-root

mkdir -p /mnt/btrfs/__snapshot
mkdir -p /mnt/btrfs/__current
btrfs subvolume create /mnt/btrfs-root/__current/root
btrfs subvolume create /mnt/btrfs-root/__current/home
mkdir -p /mnt/btrfs-current
mount -o defaults,relatime,discard,ssd,nodev,subvol=__current/root /dev/sda1 /mnt/btrfs-current
mkdir -p /mnt/btrfs-current/home
mount -o defaults,relatime,discard,ssd,nodev,nosuid,subvol=__current/home /dev/sda1 /mnt/btrfs-current/home


echo '3.1 Выбор зеркал для загрузки. Ставим зеркало'

echo "Server = http://mirror.mirohost.net/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'

pacstrap /mnt/btrfs-current base base-devel linux-lts linux-firmware

echo '3.3 Настройка системы'

genfstab -U -p /mnt/btrfs-current >> /mnt/btrfs-current/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL LinuxSimple.github.io/arch2.sh)"
