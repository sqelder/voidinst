#!/bin/sh

# install the NVIDIA driver
[ "$libc" = "musl" ] || {
    [ -n "$NVIDIA_PKG" ] && {
        xbps-install -y -S -r $VDIR -R "https://repo-default.voidlinux.org/nonfree" $NVIDIA_PKG
    }
}
