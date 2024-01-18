#!/bin/sh

# enable services
for i in $enable_services; do
    chroot $VDIR ln -sv /etc/sv/$i /etc/runit/runsvdir/default/
done
