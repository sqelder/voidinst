#!/bin/sh

# ask the user what kernel version to install
kernel_version="${kernel_version:-$(chopt "Which kernel version do you want to use?" "5.4")}"

export PACKAGES="${PACKAGES:+$PACKAGES }linux$kernel_version"
