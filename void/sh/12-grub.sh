#!/bin/sh

# install grub to the device
[ -d /sys/firmware/efi/efivars ] && {
    chroot $VDIR grub-install $disk --target=$cpuarch-efi --bootloader-id="$bootentry_name" --efi-directory=/boot/efi --removable
    chroot $VDIR grub-install $disk --target=$cpuarch-efi --bootloader-id="$bootentry_name" --efi-directory=/boot/efi
} || {
    chroot $VDIR grub-install $disk
}
chroot $VDIR grub-mkconfig -o /boot/grub/grub.cfg
