#!/bin/bash
# Автоустановка Arch Linux с / в ext4, сохранением /home (btrfs) и XFCE4
# Запускать из Live Arch: bash arch_auto_install_xfce.sh

HOSTNAME="arch-pc"
USERNAME="vanya"
USER_UID=1000
USER_GID=1000
TIMEZONE="Europe/Kyiv"

echo "=== Поиск разделов ==="
lsblk -f
echo
echo "Определяем текущий /home..."
HOME_PART=$(lsblk -f | grep -E "btrfs" | grep "/home" | awk '{print $1}' | head -n1)
if [ -z "$HOME_PART" ]; then
    echo "Не удалось автоматически найти /home. Укажи вручную (например, sdb3):"
    read -p "Раздел /home: " HOME_PART
fi
HOME_PART="/dev/${HOME_PART}"

echo "Определяем swap..."
SWAP_PART=$(lsblk -f | grep "swap" | awk '{print $1}' | head -n1)
if [ -z "$SWAP_PART" ]; then
    echo "Не удалось найти swap. Укажи вручную (например, sdb2):"
    read -p "Раздел swap: " SWAP_PART
fi
SWAP_PART="/dev/${SWAP_PART}"

echo "Определяем корень (/)..."
ROOT_PART=$(lsblk -f | grep -v "home" | grep -v "swap" | grep -E "btrfs|ext4" | awk '{print $1}' | head -n1)
if [ -z "$ROOT_PART" ]; then
    echo "Не удалось найти корневой раздел. Укажи вручную (например, sdb1):"
    read -p "Раздел /: " ROOT_PART
fi
ROOT_PART="/dev/${ROOT_PART}"

DISK="/dev/$(lsblk -no pkname $ROOT_PART)"

echo
echo "=== Найдены разделы ==="
echo "/ (корень)  : $ROOT_PART"
echo "swap        : $SWAP_PART"
echo "/home       : $HOME_PART"
echo "Диск        : $DISK"
echo
read -p "ВНИМАНИЕ: $ROOT_PART и $SWAP_PART будут ПЕРЕФОРМАТИРОВАНЫ! Продолжить? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Отмена."
    exit 1
fi

# Форматируем корень и swap
echo "[1/12] Форматируем / (ext4)"
mkfs.ext4 -F "$ROOT_PART"

echo "[2/12] Настраиваем swap"
mkswap "$SWAP_PART"

# Монтируем разделы
echo "[3/12] Монтируем разделы"
mount "$ROOT_PART" /mnt
mkdir /mnt/home
mount "$HOME_PART" /mnt/home
swapon "$SWAP_PART"

# Устанавливаем базовые пакеты
echo "[4/12] Устанавливаем базовую систему"
pacstrap /mnt base linux linux-firmware nano btrfs-progs sudo grub networkmanager

# Генерируем fstab
echo "[5/12] Генерируем /etc/fstab"
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot в новую систему
arch-chroot /mnt /bin/bash <<EOF
echo "[6/12] Настройка времени и локали"
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "[7/12] Настройка сети"
echo "${HOSTNAME}" > /etc/hostname
cat <<HOSTS > /etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    ${HOSTNAME}.localdomain ${HOSTNAME}
HOSTS

echo "[8/12] Настройка пользователей"
echo "root:root" | chpasswd
groupadd -g ${USER_GID} ${USERNAME}
useradd -u ${USER_UID} -g ${USER_GID} -m -d /home/${USERNAME} -s /bin/bash ${USERNAME}
echo "${USERNAME}:${USERNAME}" | chpasswd
usermod -aG wheel ${USERNAME}
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

echo "[9/12] Установка загрузчика"
grub-install --target=i386-pc ${DISK}
grub-mkconfig -o /boot/grub/grub.cfg

echo "[10/12] Установка XFCE4 и LightDM"
pacman -S --noconfirm xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
systemctl enable lightdm
systemctl enable NetworkManager

echo "[11/12] Чистка и оптимизация"
pacman -S --noconfirm gvfs gvfs-smb pavucontrol alsa-utils
EOF

echo "[12/12] Установка завершена!"
umount -R /mnt
swapoff -a
echo "Можешь перезагружаться."
