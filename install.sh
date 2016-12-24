#/bin/bash

# Setup folders
mkdir -p ~/bin/
mkdir -p ~/images/screenshots/
mkdir -p ~/images/wallpapers/
mkdir -p ~/projects/

# Time & Date
timedatectl set-timezone America/Chicago
timedatectl set-ntp true

# Powerline Fonts
git clone https://github.com/powerline/fonts.git ~/bin/powerline/fonts
bash ~/bin/powerline/fonts/install.sh

# Antigen
curl https://cdn.rawgit.com/zsh-users/antigen/v1.3.1/bin/antigen.zsh > ~/bin/antigen.zsh

# Desktop Manager
sudo pacman -S --no-confirm --force \
    xorg-server xorg-xrandr lightdm lightdm-gtk-greeter \
    zsh neovim udevil i3status compton dunst feh docker \
    udevil simplescreenrecorder gparted gksu

# Yaourt things
yaourt -S --no-confirm \
    google-chrome-beta visual-studio-code gitkraken slack-desktop arandr

# Docker
sudo systemctl enable docker.service 
sudo usermod -aG docker $USER

# NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash

cp .fehbg ~/.fehbg
cp -r config ~/.config
