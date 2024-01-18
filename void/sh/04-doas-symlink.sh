#!/bin/sh

# link /bin/doas to /bin/sudo
chroot $VDIR sh -c 'ln -sfv $(which doas) $(dirname $(which doas))/sudo'
