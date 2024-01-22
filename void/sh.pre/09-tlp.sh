#!/bin/sh

# intel graphics drivers
case "${install_tlp:-$(chmenu "Do you want to install \`tlp(8)\` for laptop battery optimization?" "yes" "no")}" in
    [yY]|[yY]es)
        export PACKAGES="${PACKAGES:+$PACKAGES }tlp"
        export SERVICES="${SERVICES:+$SERVICES }tlp"
        ;;
    [nN]|[nN]o)
        ;;
    *) printf "${0##*/}: error: invalid operand $install_tlp to option install_tlp\n"; exit 1 ;;
esac
