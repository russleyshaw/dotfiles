#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

devmon --exec-on-drive "notify-send --urgency=low \"Drive %l (%f) has been mounted at %d\"" \
       --exec-on-unmount "notify-send --urgency=low \"Drive %l (%f) has been unmounted from %d\"" \
       --exec-on-remove "notify-send --urgency=low \"Drive %l (%f) has been removed from %d\"" &
octopi-notifier &
compton &
sh ~/.fehbg &
dunst &
redshift-gtk &
exec i3
