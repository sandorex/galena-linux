#!/bin/sh
# common configuration for the live-build scripts

set -eu

if [ "${#ISO_VOLUME}" -gt 16 ]; then
    echo "Invalid ISO volume, longer than 16 characters"
    exit 1
fi

# copy the common things
cp -fr ../common/config ./

# dynamic grub title
sed -i "s/@@GRUB_TITLE@@/$GRUB_TITLE/g" ./config/bootloaders/grub-pc/live-theme/theme.txt

lb config noauto \
    --system live \
    --distribution "$RELEASE" \
    --architectures amd64 \
    --archive-areas "main,contrib,non-free,non-free-firmware" \
    --apt-source-archives false \
    --updates true \
    --security true \
    --backports true \
    --binary-images iso-hybrid \
    --binary-filesystem ext4 \
    --iso-application "$ISO_LABEL" \
    --iso-volume "$ISO_VOLUME" \
    --iso-publisher "$ISO_PUBLISHER" \
    --image-name "$ISO_IMAGE_NAME" \
    --bootappend-live "$LIVE_APPEND_BOOT" \
    --bootloaders "grub-pc,grub-efi" \
    --memtest memtest86+ \
    --debootstrap-options "--include=apt-transport-https,ca-certificates,openssl" \
    --apt-indices false \
    --cache-indices true \
    --zsync false \
    --net-tarball false \
    --clean \
    --color \
    "$@"


