#!/bin/sh

# user packages
[ "$install_user_packages" != "n" ] && user_packages="${user_packages:-$(chopt "Which additional packages would you like to install?")}"

export PACKAGES="${PACKAGES:+$PACKAGES }$user_packages"
