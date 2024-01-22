#!/bin/sh

# whether or not to enable bluetooth
case "${install_bluetooth:-$(chmenu "Would you like to install \`bluez(8)\` for bluetooth?" "yes" "no")}" in
    [yY]|[yY]es)
        export PACKAGES="${PACKAGES:+$PACKAGES }${btpkg:+$btpkg }bluez"
        export SERVICES="${SERVICES:+$SERVICES }bluetoothd"
        export DEFAULTGROUPS="${DEFAULTGROUPS:+$DEFAULTGROUPS,}bluetooth"
        ;;
    [nN]|[nN]o)
        ;;
    *) printf "${0##*/}: error: invalid operand $install_bluetooth to option install_bluetooth\n"; exit 1 ;;
esac
