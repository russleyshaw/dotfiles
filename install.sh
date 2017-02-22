#!/bin/bash

################################################################################
# Prompt Helpers
################################################################################

function prompt_menu {
    #title, text, options
    cmd=(dialog --clear --title "$1" --menu "$2" 22 76 16)
    menu_options=($3)
    choices=$("${cmd[@]}" "${menu_options[@]}" 2>&1 >/dev/tty)
    echo $choices
}

DIALOG_YES="0"
DIALOG_NO="1"
function prompt_yesno {
    #title, text
    dialog --clear --title "$1" --yesno "$2" 22 76 2>&1 >/dev/tty
    echo "$?"
}

function prompt_msg {
    #title, msg
    dialog --clear --title "$1" --msgbox "$2" 22 76
}

function prompt_progress {
    #title cmd
    dialog --clear --title "$1" --progressbox 22 76
}

function prompt_pause {
    #title text seconds
    dialog --clear --title "$1" --pause "$2" 22 76 $3
}

################################################################################
# Welcome
################################################################################
prompt_msg "Welcome to Russley's Dotfiles" "This script will guide you through dotfiles installation"
    
################################################################################
# Internet
################################################################################
ping -c 10 www.google.com | prompt_progress "Internet Configuration" 

################################################################################
# Time
################################################################################
TIMEZONE=$(prompt_menu "Graphics Drivers" "Select a set of drivers:" $(timedatectl list-timezones))
timedatectl set-timezone $TIMEZONE
timedatectl set-ntp true
prompt_msg "Time Configuration" "$(timedatectl status)"

PACKAGES="xorg-server xorg-xrandr lightdm lightdm-gtk-greeter light-locker \
    xorg-xbacklight keepass shutter i3status\
    zsh neovim termite compton dunst feh docker dmenu udevil gksu"
    
AUR_PACKAGES="i3-gaps google-chrome visual-studio-code gitkraken arandr"

################################################################################
# Graphics Drivers
################################################################################
DRIVERS=$(prompt_menu "Graphics Drivers" "Select a set of drivers:" "ati ATI intel Intel nvidia Nvidia")
case $DRIVERS in 
    intel)
        pkgs="xf86-video-intel mesa-libgl lib32-mesa-libgl"
        prompt_msg "Graphics Drivers" "Adding: $pkgs"
        PACKAGES="$PACKAGES $pkgs"
        ;;
    nvidia)
        pkgs="nvidia nvidia-libgl lib32-nvidia-libgl"
        prompt_msg "Graphics Drivers" "Adding: $pkgs"
        PACKAGES="$PACKAGES $pkgs"
        ;;
    *)
        prompt_msg "Graphics Drivers" "Drivers for $DRIVERS are not supported!"
        exit 1
        ;;
esac

################################################################################
# Laptop
################################################################################
LAPTOP=$(prompt_yesno "Laptop" "Install laptop specifics?")
if [ "$LAPTOP" == "$DIALOG_YES" ]
then
    pkgs="xf86-input-synaptics"
    prompt_msg "Laptop" "Adding: ${pkgs}"
    PACKAGES="$PACKAGES $pkgs"
fi

################################################################################
# Wireless
################################################################################
PACKAGES="$PACKAGES networkmanager network-manager-applet"

################################################################################
# Bluetooth
################################################################################
BLUETOOTH=$(prompt_yesno "Bluetooth" "Install Bluetooth utilities?")
if [ "$BLUETOOTH" == "$DIALOG_YES" ]
then
    pkgs="bluez bluez-utils blueman"
    prompt_msg "Bluetooth" "Adding: $pkgs"
    PACKAGES="$PACKAGES $pkgs"
fi
################################################################################
# Audio
################################################################################
AUDIO=$(prompt_yesno "Audio" "Install audio utilities?")
if [ "$AUDIO" == "$DIALOG_YES" ]
then
    pkgs="pulseaudio pulseaudio-alsa pavucontrol volumeicon"
    prompt_msg "Audio" "Adding: $pkgs"
    PACKAGES="$PACKAGES $pkgs"
fi

prompt_msg "Packages" "PACKAGES: $PACKAGES"
prompt_msg "Packages" "AUR_PACKAGES: $AUR_PACKAGES"
clear

# Make sure using a good Arch-y pacman.conf
sudo cp root/etc/pacman.conf /etc/pacman.conf

sudo pacman -Syyu 
sudo pacman -Syyu --noconfirm --force $PACKAGES
yaourt -S --noconfirm --force $AUR_PACKAGES

# Copy home
cp -TRvf home/ ~/

# Copy root
sudo cp -TRvf root/ /

# Powerline Fonts
git clone https://github.com/powerline/fonts.git ~/bin/powerline/fonts
bash ~/bin/powerline/fonts/install.sh

# Antigen
curl https://cdn.rawgit.com/zsh-users/antigen/v1.3.1/bin/antigen.zsh > ~/bin/antigen.zsh

# Network Manager
sudo systemctl enable NetworkManager.service

# LightDM
sudo systemctl enable lightdm.service

# Docker
sudo systemctl enable docker.service 
sudo usermod -aG docker $USER

if [ "$BLUETOOTH" == "$DIALOG_YES" ]
then
    sudo systemctl enable bluetooth.service
fi

# NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

sudo usermod --shell $(which zsh) russley


################################################################################
# Reboot?
################################################################################
unset choice
choice=$(prompt_yesno "Installation Complete" "Your installation of Russley's Dotfiles is complete. Reboot?")
if [ "$choice" -eq "$DIALOG_YES" ]
then 
    prompt_pause "Installation Complete" "Rebooting..." 5
    reboot
fi

exit 0
