#/bin/bash

function array_zip {
    for (( i=0; i<${#1[*]}; ++i)); do result+=( ${1[$i]} ${2[$i]} ); done
}

function prompt_menu {
    #title, text, options
    MENU_OPTIONS=
    COUNT=0
    
    for i in $3
    do
           COUNT=$[COUNT+1]
           MENU_OPTIONS="${MENU_OPTIONS} $i $i "
    done
    cmd=(dialog --clear --title "$1" --menu "$2" 22 76 16)
    menu_options=(${MENU_OPTIONS})
    choices=$("${cmd[@]}" "${menu_options[@]}" 2>&1 >/dev/tty)
    echo $choices
}

function prompt_menu_adv {
    #title, text, keys, options
    MENU_OPTIONS=
    COUNT=0
    
    MENU_OPTIONS=$(array_zip $3 $4)
    cmd=(dialog --clear --title "$1" --menu "$2" 22 76 16)
    menu_options=(${MENU_OPTIONS})
    choices=$("${cmd[@]}" "${menu_options[@]}" 2>&1 >/dev/tty)
    echo $choices
}

function prompt_msg {
    #title, msg
    dialog --clear --title "$1" --msgbox "$2" 22 76
}

function prompt_progress {
    #title cmd
    val=$($2 | dialog --title "$1" --progressbox 22 76)
    echo $val
}

# Welcome to Rinux
prompt_msg "Welcome to Rinux" "This script will guide you through installing your new Arch Linux installation"

### Pre-Installation

## Keyboard Layout
unset choices
choices=$(prompt_menu "Keyboard Layout" "Select a keyboard layout: " "$(ls /usr/share/kbd/keymaps/**/*.map.gz | grep -Eo "[a-Z0-9-]+.map.gz")" | grep -Eo "[a-Z0-9-]+" | sort | uniq)
if [! -z "${choices// }" ]
then
    prompt_progress "Keyboard Layout" "loadkeys $choices"
else
    prompt_msg "Keyboard Layout" "No layout selected. "
fi

## Internet
prompt_progress "Internet Configuration" "ping -c 10 www.google.com"

## Time
unset choices
choices=$(prompt_menu "Time Configuration" "Select a timezone: " "$(timedatectl list-timezones | sort | uniq)")
if [! -z "${choices// }" ]
then
    prompt_progress "Time Configuration" "timedatectl set-timezone ${choices}; timedatectl set-ntp true; timedatectl status"
else 
    prompt_msg "Time Configuration" "No timezone selected. "
fi

exit 0




# Setup 
sudo cp -v etc/pacman.conf /etc/pacman.conf

# Time & Date
timedatectl set-timezone America/Chicago
timedatectl set-ntp true

# Update all 
sudo pacman -Syyu --noconfirm

# Graphics Drivers
select c in Intel Nvidia
do 
    case $c in 
        Intel)
        sudo pacman -S --noconfirm xf86-video-intel mesa-libgl lib32-mesa-libgl
        break
        ;;

        Nvidia)
        sudo pacman -S --noconfirm xf86-video-intel mesa-libgl lib32-mesa-libgl
        break
        ;;
    esac
done

# Setup folders
mkdir -p ~/bin/
mkdir -p ~/projects/
mkdir -p ~/.screenlayout/

mkdir -p ~/images/
mkdir -p ~/images/screenshots/
mkdir -p ~/images/wallpapers/

# Copy images
cp -TRvf images/ ~/images/

# Powerline Fonts
git clone https://github.com/powerline/fonts.git ~/bin/powerline/fonts
bash ~/bin/powerline/fonts/install.sh

# Antigen
curl https://cdn.rawgit.com/zsh-users/antigen/v1.3.1/bin/antigen.zsh > ~/bin/antigen.zsh

# Packages Packages
sudo pacman -S --noconfirm --force \
    xorg-server xorg-xrandr lightdm lightdm-gtk-greeter light-locker xorg-xbacklight redshift \
    xf86-input-synaptics keepass linux-headers virtualbox shutter \
    bluez bluez-utils blueman i3status\
    zsh neovim udevil termite compton dunst feh docker dmenu \
    udevil simplescreenrecorder gparted gksu networkmanager network-manager-applet \
    pulseaudio pulseaudio-alsa pavucontrol

# Yaourt Packages
yaourt -S --noconfirm \
    i3-gaps google-chrome-beta visual-studio-code gitkraken arandr

# Network Manager
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# LightDM
sudo systemctl enable lightdm.service

# Docker
sudo systemctl enable docker.service 
sudo usermod -aG docker $USER

# Bluetooth
sudo systemctl enable bluetooth.service

# NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

cp -vf .fehbg ~/.fehbg
cp -vf .zshrc ~/.zshrc
cp -TRvf config/ ~/.config/

sudo usermod --shell $(which zsh) russley
