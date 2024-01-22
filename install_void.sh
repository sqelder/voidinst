#!/bin/sh

# cd to the directory of the script
_IFS="$IFS"
IFS="/"
for i in $0; do
    [ -d "$i" ] && cd $i
done
SCDIR="$PWD"
IFS="$_IFS"

# env vars
distroid="void"
export VDIR="/tmp/${distroid}inst/mnt"
export PACKAGES="base-files>=0.77 ncurses coreutils findutils diffutils libgcc dash bash grep xz lz4 gzip file sed gawk less util-linux which tar man-pages mdocml>=1.13.3 shadow e2fsprogs btrfs-progs xfsprogs f2fs-tools dosfstools procps-ng tzdata pciutils usbutils iana-etc openssh dhcpcd kbd iproute2 iputils iw wpa_supplicant xbps void-repo-nonfree neovim opendoas wifi-firmware traceroute ethtool kmod acpid eudev runit-void removed-packages dracut grub grub-x86_64-efi efibootmgr tree"
export XBPS_ARCH="x86_64"
export SERVICES=""
export DEFAULTGROUPS="wheel,tty,disk,lp,audio,video,cdrom,optical,storage,network,input,users"

# add the script's utilities to PATH
[ -d "$SCDIR/bin" ] && {
    export PATH="$SCDIR/bin${PATH:+:$PATH}"
} || {
    printf "${0##*/}: error: failed to set PATH\n"
    exit 1
}

# source the config file if it exists
[ -r "$SCDIR/voidinst.conf" ] && . "$SCDIR/voidinst.conf"

# these commands are required
requirecmd grep awk wc nl sort uniq swapoff mount umount mkdir cp lsblk fdisk mkfs.ext2 mkfs.fat xbps-install chroot chmenu chopt

# check if we have root permissions for the install
case "${EUID:-${UID:-$(id -u)}}" in
    0) ;;
    *) printf "${0##*/}: error: Operation not permitted\n"; exit 1 ;;
esac

# create dirs
[ -d "$VDIR" ] || {
    mkdir -p $VDIR || {
        printf "${0##*/}: error: failed to create directory $VDIR"
        exit 1
    }
}

# pre-installation conf scripts
for f in $SCDIR/$distroid/sh.pre/*.sh; do
    [ -r "$f" ] && . $f
done

# manual partitioning
[ "$partitioning_mode" = "m" ] && {
    # if partitioning isn't set to continue without warning, prompt the user
    [ "$warn" = "n" ] || {

        # whether or not $disk has already been set up
        mpart_cont="$(chmenu "Disk $disk selected for manual partitioning. What would you like to do?" "continue (if $disk has been prepared, and its relevant volumes mounted at $VDIR)" "exit (if $disk still requires setup)")"

        # continue or exit
        case "${mpart_cont%% *}" in
            'continue') ;;
            'exit') printf "Set up $disk as desired and re-run the script.\n"; exit 0 ;;
        esac
    }
}

# automatic partitioning
[ "$partitioning_mode" = "a" ] && {
    # ensure we have the commands required for partitioning
    requirecmd mkfs.$root_fs

    # if partitioning isn't set to continue without warning, prompt the user twice
    [ "$warn" = "n" ] || {

        # whether or not to write over $disk
        apart_cont="$(chmenu "Disk $disk selected for automatic partitioning, which will overwrite the current data and partition table. Do you want to continue?" "yes" "no")"

        # continue or exit
        case "$apart_cont" in
            yes) ;;
            no) printf "Back up important data on $disk and re-run the script.\n"; exit 0 ;;
        esac

        # whether or not to write over $disk
        apart_cont="$(chmenu "\033[33mFINAL WARNING\033[39m: All the contents of $disk will be \033[31mLOST\033[39m during automatic partitioning. Are you SURE you want to continue?" "yes" "no")"

        # continue or exit
        case "$apart_cont" in
            yes) ;;
            no) printf "Back up important data on $disk and re-run the script.\n"; exit 0 ;;
        esac
    }

    # free $disk from any current activity before attempting to use it
    while ! freedisk $disk; do
        printf "accessing $disk failed. retrying in 3s...\n"
    done

    # create a new partition table
    case "$partitioning_preset" in
        efi+bios:gpt|bios+efi:gpt|both:gpt) partscheme="g\nn\n1\n\n+1M\nn\n2\n\n+${efipartsize:-128}M\nn\n3\n\n\nt\n1\n4\nt\n2\n1\nt\n3\n20\nx\nn\n1\nbios_boot\nn\n2\nefi_boot\nn\n3\n${distroid}rootfs\nA\n1\nr\nw\n"; biospart="1"; efipart="2"; rootpart="3" ;;
        bios:gpt) partscheme="g\nn\n1\n\n+1M\nn\n2\n\n\nt\n1\n4\nt\n2\n20\nx\nn\n1\nbios_boot\nn\n2\n${distroid}rootfs\nA\n1\nr\nw\n"; biospart="1"; rootpart="2" ;;
        efi:gpt) partscheme="g\nn\n1\n\n+${efipartsize:-128}M\nn\n2\n\n\nt\n1\n1\nt\n2\n20\nx\nn\n1\nefi_boot\nn\n2\n${distroid}rootfs\nr\nw\n"; efipart="1"; rootpart="2" ;;
        bios:mbr) partscheme="o\nn\np\n1\n\n\nt\n1\n83\na\n1\nw\n"; rootpart="1" ;;
    esac

    # run fdisk
    printf "$partscheme" | fdisk -w always -W always $disk

    # store the prefix to partition numbers
    partprefix="$(lsblk -no PATH $disk | awk 'END{print substr($1, 1, length($1)-1)}')"

    # format the root partition with the chosen filesystem
    case "$root_fs" in
        ext2) mkfs.ext2 -L ${distroid}rootfs ${partprefix}${rootpart} ;;
        ext3) mkfs.ext3 -L ${distroid}rootfs ${partprefix}${rootpart} ;;
        ext4) mkfs.ext4 -L ${distroid}rootfs ${partprefix}${rootpart} ;;
        btrfs) mkfs.btrfs -L ${distroid}rootfs ${partprefix}${rootpart} ;;
        f2fs) mkfs.f2fs -l ${distroid}rootfs ${partprefix}${rootpart} ;;
        xfs) mkfs.xfs -L ${distroid}rootfs ${partprefix}${rootpart} ;;
    esac

    # mount the root partition
    mount -v ${partprefix}${rootpart} $VDIR

    # mount the EFI partition if it exists
    [ -n "$efipart" ] && {
        # format the EFI partition
        mkfs.fat -F32 -n "EFI_BOOT" ${partprefix}${efipart}

        # mount it
        mkdir -p $VDIR/boot/efi
        mount -v ${partprefix}${efipart} $VDIR/boot/efi
    }
}

# change to the new root
cd $VDIR

# mount devices
mkdir -p $VDIR/dev $VDIR/sys $VDIR/proc $VDIR/run
mount --rbind /dev $VDIR/dev
mount --rbind /sys $VDIR/sys
mount --rbind /proc $VDIR/proc
mount --rbind /run $VDIR/run
mount --make-rslave $VDIR/dev
mount --make-rslave $VDIR/sys
mount --make-rslave $VDIR/proc
mount --make-rslave $VDIR/run

# copy xbps rsa keys
mkdir -p $VDIR/var/db/xbps/keys
cp /var/db/xbps/keys/* $VDIR/var/db/xbps/keys/

# install the base system
xbps-install -y -S -r $VDIR -R "$XBPS_REPO" $PACKAGES

# run system conf scripts
for f in $SCDIR/$distroid/sh/*.sh; do
    [ -r "$f" ] && . $f
done

# reconfigure the packages
chroot $VDIR xbps-reconfigure -fa

# change out of $VDIR
cd /

# unmount everything
freedisk $disk
