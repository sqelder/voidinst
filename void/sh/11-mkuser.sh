#!/bin/sh

# create user(s)
[ "$create_user" = "y" ] && {
    for i in $(seq 1 ${userct:-0}); do
        eval "chroot $VDIR useradd -mG \$user${i}_groups -s /bin/bash -c \"\$user${i}_name_comment\" \$user${i}_name"
        eval "printf \"\$user${i}_password\n\$user${i}_password\n\" | chroot $VDIR passwd \$user${i}_name"
    done
}
