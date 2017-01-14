#/bin/bash

function prompt_menu {
    #title, text, options
    MENU_OPTIONS=
    COUNT=0
    
    for i in $3
    do
           COUNT=$[COUNT+1]
           MENU_OPTIONS="${MENU_OPTIONS} $i $i "
    done
    cmd=(dialog --title "$1" --menu "$2" 22 76 16)
    menu_options=(${MENU_OPTIONS})
    choices=$("${cmd[@]}" "${menu_options[@]}" 2>&1 >/dev/tty)
    clear
    echo $choices
}

### Pre-Installation

## Keyboard Layout
choices=$(prompt_menu "Keyboard Layout" "Select a keyboard layout: " "$(ls /usr/share/kbd/keymaps/**/*.map.gz)")

## Internet
# Assuming valid internet connection because script was likely retrieved remotely

## Time
choices=$(prompt_menu "Time Zone" "Select a timezone: " "$(timedatectl list-timezones)")
timedatectl set-timezone ${choices}
timedatectl set-ntp true

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
