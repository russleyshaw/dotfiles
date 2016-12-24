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

# Packages Packages
sudo pacman -S --noconfirm --force \
    xorg-server xorg-xrandr lightdm lightdm-gtk-greeter xorg-xbacklight redshift \
    zsh neovim udevil i3status compton dunst feh docker \
    udevil simplescreenrecorder gparted gksu networkmanager network-manager-applet \
    pulseaudio pulseaudio-alsa pavucontrol volumeicon

# Yaourt Packages
yaourt -S --noconfirm \
    google-chrome-beta visual-studio-code gitkraken slack-desktop arandr

# Network Manager
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# Docker
sudo systemctl enable docker.service 
sudo usermod -aG docker $USER

# NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash

cp -vf .fehbg ~/.fehbg
cp -TRvf config/ ~/.config/

# Switch to zsh
chsh -s $(which zsh)
