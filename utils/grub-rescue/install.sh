#!/usr/bin/env bash
#
# install.sh - add bootable iso file as menuentry in grub
#
# requires 7z whiptail

# install.sh <iso file path> [<kernel arguments..>]

#GRUB_CONFIG_FILE=/etc/grub.d/40_grub-rescue-iso

MENU_LABEL="Rescue LiveCD"

# NOTE: has to be mounted when grub-mkconfig is ran!
ISO_PATH="/mnt/d/Downloads/debian-live-11.6.0-amd64-gnome+nonfree.iso"
# ISO_PATH=/boot/iso/bootable.iso

if [ ! -f "$ISO_PATH" ]; then
    echo "File does not exist at path '$ISO_PATH'"
    exit 1
fi

iso_dev_device=$(df "$ISO_PATH" | head -n1 | awk '{ print $1 }')
ISO_PARTITION_UUID=$(lblk -o UUID "$iso_dev_device" | tail -n1)

menu() {
    title=$1
    shift 1
    whiptail --backtitle "GRUB Rescue ISO Install" --title "$title" --noitem --menu "" 0 0 0 "$@" 3>&1 1>&2 2>&3
}

# TODO 7zz is official but 7z is legacy, support both i guess?

files=$(7zz l "$ISO_PATH" | awk 'index($6, "/") { print $6 }')

# im printing '_' as item for whiptail, seemed the simplest solution
linux=$(echo "$files" | awk '/linu[xz][^/]*$/ { print $0, "_" }')
initrd=$(echo "$files" | awk '/initrd[^/]*$/ { print $0, "_" }')

# shellcheck disable=SC2086
if ! LINUX_PATH=$(menu 'Select kernel file' $linux); then
    echo 'Script aborted'
    exit 1
fi

# shellcheck disable=SC2086
if ! INITRD_PATH=$(menu 'Select initrd file' $initrd); then
    echo 'Script aborted'
    exit 1
fi

# TODO take code from https://wiki.debian.org/DebianLive/MultibootISO
cat <<EOF
#!/bin/sh
echo "'$MENU_LABEL' added to menuentry"
exec tail -n +4 \$0

# this file was automatically generated on $(date)
# file $ISO_PATH
# partition uuid $ISO_PARTITION_UUID

menuentry "$MENU_LABEL" {
  insmod ext2
  set iso_path="$ISO_PATH"
  search --no-floppy --fs-uuid --set=root $ISO_PARTITION_UUID
  loopback loop (\$root)\$isofile
  linux (loop)/$LINUX_PATH findiso=\$iso_path boot=live components quiet splash $BOOT_ARGS
  initrd (loop)/$INITRD_PATH
}
EOF

