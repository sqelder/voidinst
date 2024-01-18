#!/bin/sh

case "${intel_firmware:-$(chmenu "Do you want to install Intel firmware? (linux-firmware-intel)" "yes" "no")}" in
    [yY]|[yY]es) export PACKAGES="${PACKAGES:+$PACKAGES }linux-firmware-intel" ;;
     [nN]|[nN]o) ;;
              *) printf "${0##*/}: error: invalid operand $intel_firmware for option intel_firmware\n"; exit 1 ;;
esac

case "${amd_firmware:-$(chmenu "Do you want to install AMD firmware? (linux-firmware-amd)" "yes" "no")}" in
    [yY]|[yY]es) export PACKAGES="${PACKAGES:+$PACKAGES }linux-firmware-amd" ;;
     [nN]|[nN]o) ;;
              *) printf "${0##*/}: error: invalid operand $amd_firmware for option amd_firmware\n"; exit 1 ;;
esac

case "${nvidia_firmware:-$(chmenu "Do you want to install Nvidia firmware? (linux-firmware-nvidia)" "yes" "no")}" in
    [yY]|[yY]es) export PACKAGES="${PACKAGES:+$PACKAGES }linux-firmware-nvidia" ;;
     [nN]|[nN]o) ;;
              *) printf "${0##*/}: error: invalid operand $nvidia_firmware for option nvidia_firmware\n"; exit 1 ;;
esac

case "${network_firmware:-$(chmenu "Do you want to install network drivers? (linux-firmware-network)" "yes" "no")}" in
    [yY]|[yY]es) export PACKAGES="${PACKAGES:+$PACKAGES }linux-firmware-network" ;;
     [nN]|[nN]o) ;;
              *) printf "${0##*/}: error: invalid operand $network_firmware for option network_firmware\n"; exit 1 ;;
esac
