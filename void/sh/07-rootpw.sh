#!/bin/sh

# change the root password
printf "$root_password\n$root_password\n" | chroot $VDIR passwd root
