#!/bin/bash
read -p "Введите имя компьютера: " hostname
read -p "Введите имя пользователя: " username

echo 'Прописываем имя компьютера'
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Europe/Kiev /etc/localtime

echo '3.4 Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo 'Обновим текущую локаль системы'
locale-gen

echo 'Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo 'Создадим загрузочный RAM диск'
mkinitcpio -P linux

echo '3.5 Устанавливаем загрузчик'
pacman -Syy
pacman -S grub --noconfirm 
grub-install /dev/sda

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm 

echo 'Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash $username

echo 'Создаем root пароль'
passwd

echo 'Устанавливаем пароль пользователя'
passwd $username

echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo "Куда устанавливем Arch Linux на виртуальную машину?"
read -p "1 - Да, 0 - Нет: " vm_setting
if [[ $vm_setting == 0 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit"
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"
fi

echo 'Ставим иксы и драйвера'
pacman -S $gui_install

echo "Какое DE ставим?"
read -p "1 - XFCE, 2 - KDE, 3 - Lxqt: " vm_setting
if [[ $vm_setting == 1 ]]; then
  pacman -S xfce4 xfce4-goodies --noconfirm
elif [[ $vm_setting == 2 ]]; then
  pacman -S plasma plasma-meta --noconfirm
elif [[ $vm_setting == 3 ]]; then  
  pacman -S  lxqt
fi

echo 'Какой ставим DM ?'
read -p "1 - sddm, 2 - lxdm: " dm_setting
if [[ $dm_setting == 1 ]]; then
  pacman -Sy sddm sddm-kcm --noconfirm
  systemctl enable sddm.service -f
elif [[ $dm_setting == 2 ]]; then
  pacman -S lxdm --noconfirm
  systemctl enable lxdm
fi

echo 'Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu --noconfirm 

echo 'Ставим сеть'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echo 'Настраиваем звук и необходимые программы'
pacman -S pulseaudio --noconfirm
pacman -S pavucontrol --noconfirm
pacman -S konsole dolphin packagekit-qt5 htop nano ark p7zip unrar gvfs-mtp mtpfs xdg-user-dirs wget ttf-dejavu noto-fonts-emoji --noconfirm

echo 'Установка AUR (yay)'
mkdir -p /tmp/yay_install
cd /tmp/yay_install
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sir --needed --noconfirm --skippgpcheck
echo 'CИСТЕМА УСТАНОВЛЕНА, ПЕРЕЗАГРУЗИТЕ КОМПЬЮТЕР'
exit
