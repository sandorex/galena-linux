# Galena Rescue
Minimal debian stable live image, meant for use with `grub-imageboot` for rescue purposes\
Target size is <=1GB, so 1.5GB free space is recommended for `/boot`, recommended size is 3GB for the whole partition

**Default user/password is `user/live`, passwordless sudo is enabled**

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
    - XFCE4 desktop environment
- Changed timeshift default config (`/etc/timeshift/default.json`) so it does not show setup dialog on startup
- Changed gtk theming to default to dark theme
- Changed XFCE4 settings (`/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml`) to change default theme to adwaita dark
- Lightdm configuration to disable guest user and autologin, currently does not work as intended and does not relogin user after logging out
- Removed firmware that realistically will never be needed on a desktop/laptop

