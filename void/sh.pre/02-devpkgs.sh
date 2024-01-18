#!/bin/sh

# remove variation in boolean expression
case "${install_dev_packages:-$(chmenu "Do you want to install development packages?" "yes" "no")}" in
    [yY]|[yY]es) install_dev_packages="y"; export PACKAGES="${PACKAGES:+$PACKAGES }${dev_packages:-base-devel bc git github-cli}" ;;
    [nN]|[nN]o) install_dev_packages="n" ;;
    *) printf "${0##*/}: error: invalid operand $install_dev_packages for option install_dev_packages\n"; exit 1 ;;
esac
