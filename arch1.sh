loadkeys ru

setfont cyr-sun16

echo 'Скрипт сделан на основе чеклиста Бойко Алексея по Установке ArchLinux'

echo 'Ссылка на чек лист есть в группе vk.com/arch4u'

echo '2.3 Синхронизация системных часов'

timedatectl set-ntp true

echo '2.4 создание разделов'

(

echo o;

echo n;

echo;

echo;

echo;

echo +20G;

echo n;

echo;

echo;

echo;

echo +250G;

echo w;

) | fdisk /dev/sda

echo 'Ваша разметка диска'

fdisk -l

echo '2.4.2 Форматирование дисков'

mkfs.ext4 /dev/sda1 -L root

mkfs.ext4 /dev/sda2 -L home

echo '2.4.3 Монтирование дисков'

mount /dev/sda1 /mnt

mount /dev/sda2 /mnt

echo '3.1 Выбор зеркал для загрузки. Ставим зеркало'

echo "Server = http://mirror.mirohost.net/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'

pacstrap /mnt base base-devel linux linux-firmware

echo '3.3 Настройка системы'

genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL LinuxSimple.github.io/arch2.sh)"
