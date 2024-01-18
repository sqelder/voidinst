#!/bin/sh

# copy the live image's wifi config so network works out of the box
cp -v /etc/wpa_supplicant/wpa_supplicant.conf $VDIR/etc/wpa_supplicant/wpa_supplicant.conf
cp -v /etc/resolv.conf $VDIR/etc/
