#!/bin/sh

# user packages
[ -z "$user_packages" ] && [ "$install_user_packages" != "n" ] && user_packages="$(chopt "Which additional packages would you like to install?")"

export PACKAGES="${PACKAGES:+$PACKAGES }$user_packages"
