# Galena Linux Rescue
Minimal debian rescue image, meant for use with `grub-imageboot`\
ISO target size is between 500mb and 900mb, the size will be more consistent later on in development, but **the size will never go above 1gb**

## Features
- Contains useful software
    - Timeshift, to allow easy restore of broken system unless even grub is borked
    - GParted, for GUI management of partitions
- Useable desktop environment

## Changes
These are changes made compared to stock debian:
- Preinstalled some applications
    - Timeshift
    - GParted
    - XFCE4
    - Firefox ESR
- Changed timeshift default config (`/etc/timeshift/default.json`) so it does not show the setup dialog on startup
- Changed gtk theming to default to dark theme
- Changed XFCE4 settings (`/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml`) to change default theme to adwaita dark
- Lightdm configuration to disable guest user and autologin, currently does not work as intended and does not relogin user after logging out
- Removed some outdated firmware

