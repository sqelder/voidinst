#!/bin/sh

# set the language
printf "LANG=$language.UTF-8\nLC_ALL=$language.UTF-8\nLC_COLLATE=C" >$VDIR/etc/locale.conf
