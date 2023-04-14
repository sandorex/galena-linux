#!/usr/bin/env bash
#
# install.sh - add bootable iso file as menuentry in grub
#
# requires 7zip/p7zip whiptail lblk

KERNEL_ARGS=
POSITIONAL_ARGS=()

while [ $# -gt 0 ]; do
    case $1 in
        --label)
            ARG_LABEL=$2
            shift 2
            ;;
        --rootpath)
            ARG_ROOTPATH=$2
            shift 2
            ;;
        --UUID)
            ISO_PARTITION_UUID=$2
            shift 2
            ;;
        --no-default-kargs)
            NO_DEFAULT_KARGS=1
            shift
            ;;
        --)
            shift
            KERNEL_ARGS=$*
            break
            ;;
        --help|-h)
            HELP=1
            shift
            ;;
        --*|-*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            # save positional arg
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# restore positional parameters
set -- "${POSITIONAL_ARGS[@]}"

if [ -z "$1" ] || [ -n "$HELP" ]; then
    echo "TODO"
    exit
fi

if [ ! -f "$1" ]; then
    echo "Invalid file path '$1'"
    exit 1
fi

ISO_PATH=${1:?}
ISO_FILENAME=$(basename "$ISO_PATH")
LABEL=${ARG_LABEL:-$ISO_FILENAME}
ROOTPATH=${ARG_ROOTPATH:-$ISO_PATH}

list-iso() {
    # support both official 7zip and the old deprecated p7zip
    if command -v 7zz; then
        7zz l "$1"
    else
        7z l "$1"
    fi
}

menu() {
    title=$1
    shift 1
    whiptail --backtitle "GRUB Rescue ISO Install" --title "$title" --noitem --menu "" 0 0 0 "$@" 3>&1 1>&2 2>&3
}

if [ ! -f "$ISO_PATH" ]; then
    echo "File does not exist at path '$ISO_PATH'"
    exit 1
fi

if [ -z "$ISO_PARTITION_UUID" ]; then
    iso_dev_device=$(df "$ISO_PATH" | tail -n1 | awk '{ print $1 }')
    echo "== $iso_dev_device"
    ISO_PARTITION_UUID=$(lsblk -o UUID "$iso_dev_device" | tail -n1)
    if [ -z "$ISO_PARTITION_UUID" ]; then
        echo "Could not get UUID of the partition, you can try providing it manually using --UUID <uuid>"
        exit 1
    fi
fi

files=$(list-iso "$ISO_PATH" | awk 'index($6, "/") { print $6 }')

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

# allow disabling kernel_args
if [ -z "$NO_DEFAULT_KARGS" ]; then
    KERNEL_ARGS="findiso=\$iso_path boot=live components quiet splash $KERNEL_ARGS"
fi

# TODO make a menu like here https://wiki.debian.org/DebianLive/MultibootISO
cat <<EOF
#!/bin/sh
echo "Added '$ISO_FILENAME' as '$LABEL' to menu"
exec tail -n +4 \$0

# this file was automatically generated on $(date)
# file $ISO_PATH
# partition uuid $ISO_PARTITION_UUID

menuentry "$LABEL" {
  insmod ext2
  set iso_path="$ROOTPATH"
  search --no-floppy --fs-uuid --set=root $ISO_PARTITION_UUID
  loopback loop (\$root)\$isofile
  linux (loop)/$LINUX_PATH $KERNEL_ARGS
  initrd (loop)/$INITRD_PATH
}
EOF

