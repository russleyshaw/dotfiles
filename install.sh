#/bin/bash

DIALOG_YES="0"
DIALOG_NO="1"

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

function prompt_menu_raw {
    #title, text, options
    MENU_OPTIONS=
    COUNT=0
    
    MENU_OPTIONS=$3
    cmd=(dialog --clear --title "$1" --menu "$2" 22 76 16)
    menu_options=(${MENU_OPTIONS})
    choices=$("${cmd[@]}" "${menu_options[@]}" 2>&1 >/dev/tty)
    echo $choices
}

function prompt_menu_zip {
    #title, text, ids, text
    MENU_OPTIONS=
    COUNT=0
    
    MENU_OPTIONS=array_zip $3 $4
    cmd=(dialog --clear --title "$1" --menu "$2" 22 76 16)
    menu_options=(${MENU_OPTIONS})
    choices=$("${cmd[@]}" "${menu_options[@]}" 2>&1 >/dev/tty)
    echo $choices
}

function prompt_yesno {
    #title, text
    dialog --clear --title "$1" --yesno "$2" 22 76 2>&1 >/dev/tty
    
    # 0=yes 1=no
    echo "$?"
}

function prompt_msg {
    #title, msg
    dialog --clear --title "$1" --msgbox "$2" 22 76
}

function prompt_progress {
    #title cmd
    $2 | dialog --clear --title "$1" --progressbox 22 76
}

function prompt_pause {
    #title text seconds
    dialog --clear --title "$1" --pause "$2" 22 76 $3
}

function get_partitions {
    # disk
    parts=
    parted --list --machine 2/dev/null | while read line
    do
        # Read lines until BYT;
        if [ "$line" == "BYT;" ]
        then
            # Read the disk info
            read line
            curr=$(cat line | cut -d: -f1)
            if [ "$line" == "$1"]
            then
                # Read all the partitions
                while read line
                do
                    if [ -n "$line" ]
                    then
                        part=$(cat line | cut -d: -f1)
                        parts="$parts $part"
                    fi
                done
            fi
        fi
    done
    echo "$parts"
}

################################################################################
# Welcome to Rinux
################################################################################
prompt_msg "Welcome to Rinux" "This script will guide you through installing your new Arch Linux installation"

### Pre-Installation

################################################################################
# Keyboard Layout
################################################################################
# unset choices
# choices=$(prompt_menu "Keyboard Layout" "Select a keyboard layout: " "$(ls /usr/share/kbd/keymaps/**/*.map.gz | xargs basename -s .map.gz | sort | uniq)")
# if [ -n "$choices" ]
# then
#     prompt_msg "Keyboard Layout" "You chose the layout: $choices."
#     loadkeys $choices
# else
#     prompt_msg "Keyboard Layout" "You chose no layout."
# fi
    
################################################################################
# Internet
################################################################################
prompt_progress "Internet Configuration" "ping -c 10 www.google.com"

################################################################################
# Time
################################################################################
unset choice
choice=$(prompt_menu "Time Configuration" "Select a timezone: " "$(timedatectl list-timezones | sort | uniq)")
if [ -n "$choice" ]
then
    prompt_msg "Time Configuration" "You chose the timezone: $choice."
    timedatectl set-timezone $choice
    timedatectl set-ntp true
fi
prompt_msg "Time Configuration" "$(timedatectl status)"

################################################################################
# Disk Partitioning
################################################################################
unset choice
choice=$(prompt_menu_raw "Disk Partitioning" "Select a partitioning method: " "guided Guided diy Bash")
case $choice in
    simple)
        options=
        parted --list --machine 2>/dev/null | while read line
        do
            if [ "$line" == "BYT;" ]
            then
                read line
                options="$options $(cat line | cut -d: -f1,2 | sed 's/:/\ /')"
            fi
        done
        # Prompt and select Disks
        disk=$(prompt_menu_raw "Disk Partitioning" "Select a disk to install to: " "$options")
        prompt_msg "Disk Partitioning" "SELECTED $disk"
        
        # Select all partitions
        parts=$(get_partitions $disk)
        prompt_msg "Disk Partitioning" "PARTITIONS $parts"
        
        ;;
    diy)
        prompt_msg "Disk Partitioning" "Please partition your disks manually. A bash prompt will open. Please exit when finished"
        bash
        ;;
esac


################################################################################
# Reboot?
################################################################################
unset choice
choice=$(prompt_yesno "Installation Complete" "Your installation of Rinix is complete. Reboot?")
if [ "$choice" -eq "$DIALOG_YES" ]
then 
    prompt_pause "Installation Complete" "Rebooting..." 5
    reboot
fi
clear
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
