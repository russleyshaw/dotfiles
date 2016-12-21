#/bin/bash

mkdir ~/bin/
mkdir -p ~/images/screenshots/
mkdir -p ~/images/wallpapers/
mkdir ~/projects/

# Time & Date
timedatectl set-timezone America/Chicago
timedatectl set-ntp true

# Powerline Fonts
git clone https://github.com/powerline/fonts.git ~/bin/powerline/fonts
bash ~/bin/powerline/fonts/install.sh

# Antigen
curl https://cdn.rawgit.com/zsh-users/antigen/v1.3.1/bin/antigen.zsh > ~/bin/antigen.zsh


sudo pacman -S xorg-server xorg-xrandr

# LightDM
sudo pacman -S --force lightdm lightdm-gtk-greeter

sudo pacman -S zsh neovim i3-wm i3status udevil compton simplescreenrecorder feh gparted gksu

# Yaourt things
yaourt -S google-chrome-beta visual-studio-code gitkraken slack-desktop arandr

cp .fehbg ~/.fehbg
cp -r config ~/.config
cp -r .shutter ~/

