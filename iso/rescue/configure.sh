#!/usr/bin/env bash
#
# this script assumes its ran inside the build directory after config has been
# created

## configuration ##
RELEASE=bookworm

# bookworm added non-free-firmware
AREAS="main,contrib,non-free-firmware"

args=(
    # sets predefined defaults for debian, i do not know exactly what TODO
    --mode debian

    # the resulting system is a live system not an installer
    --system live

    # for manual use only, opens interactive shell in chroot and cannot be automated
    #--interactive shell

    # type of image, best option iso-hybrid
    --binary-images iso-hybrid

    # include memtest
    --memtest memtest86+

    --iso-application "'Debian Rescue Live'"
    --iso-publisher "'sandorex: rzhw3h@gmail.com'"
    --iso-volume "'Rescue ($RELEASE)'"

    # which debian release to use
    --distribution "$RELEASE"

    # additional repo areas to use (contrib non-free etc)
    --archive-areas "$AREAS"

    # enable security repo
    --security true

    # enable updates repo
    --updates true

    # disable delta file zsync (i have no use for it)
    --zsync false

    # disable tarball creation (i only need iso)
    --net-tarball false
)

# configures live-build but does not actually build anything
lb config "${args[@]}"

# setup the packages needed
cat <<EOF > ./config/package-lists/util.list.chroot
gparted
btrfs-progs
EOF

cat <<EOF > ./config/package-lists/desktop.list.chroot
libxfce4ui-utils
thunar
xfce4-appfinder
xfce4-panel
xfce4-session
xfce4-settings
xfce4-terminal
xfconf
xfdesktop4
xfwm4
EOF

