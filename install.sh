#/bin/bash

# Setup folders
mkdir -p ~/bin/
mkdir -p ~/projects/

# Setup images
mkdir -p ~/images/screenshots/
mkdir -p ~/images/wallpapers/
cp -TRvf images/ ~/images/

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
    xf86-input-synaptics keepass \
    zsh neovim udevil i3-wm i3status termite compton dunst feh docker \
    udevil simplescreenrecorder gparted gksu networkmanager network-manager-applet \
    pulseaudio pulseaudio-alsa pavucontrol volumeicon

# Yaourt Packages
yaourt -S --noconfirm \
    google-chrome-beta visual-studio-code gitkraken slack-desktop arandr

# Network Manager
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# LightDM
sudo systemctl enable lightdm.service

# Docker
sudo systemctl enable docker.service 
sudo usermod -aG docker $USER

# NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash

cp -vf .fehbg ~/.fehbg
cp -vf .zshrc ~/.zshrc
cp -TRvf config/ ~/.config/

sudo usermod --shell $(which zsh) russley
