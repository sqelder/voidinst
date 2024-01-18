#!/bin/sh

# set the glibc locale
[ -r "$VDIR/etc/default/libc-locales" ] && {
    sed "s/#$language/$language/g" <$VDIR/etc/default/libc-locales >$VDIR/etc/default/libc-locales2
    mv -v $VDIR/etc/default/libc-locales2 $VDIR/etc/default/libc-locales
}
