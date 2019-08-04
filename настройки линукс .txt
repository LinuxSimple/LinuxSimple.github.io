FSTAB -# Static information about the filesystems.
# See fstab(5) for details.
# <file system> <dir> <type> <options> <dump> <pass>
# UUID=8ba20bbc-b39a-4c3e-9d58-a3f128b6743b
/dev/sda1
/
ext4
rw,relatime
0 1
/dev/sda2 /run/media/arch/70CAB63410242F6F ntfs
uid=1000,gid=100,nosuid,nodev,nofail,x-gvfs-show,x-gvfs-name=Файлы


АВТОЗАПУСК ПРОГРАММ - telegram-desktop -- %u -startintray


УСТАНОВКА ДРАЙВЕРА Arch Linux
yay -S nvidia-340xx-lts  lib32-nvidia-340xx-utils
sudo pacman -R xf86-video-nouveau
Выполнить sudo mkinitcpio -P linux


ЗНАЧЕК МОЙ КОМПЬЮТЕР
[Desktop Entry]
Version=1.0
Type=Application
Name=Мой компьютер
Comment=
Exec=Thunar
Icon=system
Path=~
Terminal=false
StartupNotify=false
Name[ru]=Компьютер
Компьютер.desktop


КОДЕК ДЛЯ ОПЕРА
opera-ffmpeg-codecs


ОТКЛЮЧИТЬ LIGHTDM в Arch Linux
раскоментировать строчку autologin-user=sasha
autologin-session=xfce
sudo groupadd autologin && sudo usermod -a -G autologin sasha
systemctl enable lightdm.service && systemctl start lightdm.service



АУР Arch Linux

sudo pacman -Syu

mkdir -p /tmp/yay_install

cd /tmp/yay_install

sudo pacman -S git

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -sir --needed --noconfirm --skippgpcheck

rm -rf yay_install



# Создаём pamac-aur_install директорию и переходим в неё
mkdir -p /tmp/pamac-aur_install
cd /tmp/pamac-aur_install
# Установка "pamac-aur" из AUR
sudo pacman -S git
git clone https://aur.archlinux.org/pamac-aur.git
cd pamac-aur
makepkg -si --needed --noconfirm --skippgpcheck
rm -rf pamac-aur_install



СВОП НАСТРОЙКА
Редактируем файл /etc/sysctl.conf, добавим в конец файла строки:
Достаточно оперативной памяти
vm.swappiness = 10
vm.vfs_cache_pressure = 1000


СИНАПТИК БЫСТРЫЙ ПОИСК
sudo apt-get install apt-xapian-index
sudo update-apt-xapian-index -vf


УСТАНОВКА ДРАЙВЕРА ДЛЯ ДЕБИАН
contrib non-free (в конце каждого репозитория)
apt-cache search nvidia-detect
sudo apt install nvidia-detect
nvidia-detect
sudo apt install nvidia-legacy-340xx-driverЦВЕТ ПАПКИ СУРУ
wget -qO- https://git.io/fhQdI | sh скрипт
suru-plus-folders -C brown --theme Suru++ цвет папки






ПРОПИСАТЬ СЕБЯ В СУДО
nano /etc/sudoers
sasha   ALL=(ALL:ALL) ALL
sasha   ALL=(ALL) NOPASSWD: ALL

ГИТХАБ
LinuxSimple почта 03shurik03@ukr.net
R8Fz9jhjacp(#odm
wget git LinuxSimple.github.io/arch1.sh
sh arch1.sh


КОМПИЗ ДЛЯ Arch Linux
compiz-core
ccsm
compizconfig-python
libcompizconfig
fusion ico
emerald-themes
compiz-fusion-plugins-experimental