#!/bin/bash
echo 'ставим ей'
mkdir -p /tmp/yay_install
cd /tmp/yay_install
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sir --needed --noconfirm --skippgpcheck
rm -rf yay_install
