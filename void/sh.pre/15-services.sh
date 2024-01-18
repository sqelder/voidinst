#!/bin/sh

# services to enable
enable_services="${enable_services:-$(chopt "Which runit services should be enabled?" "${SERVICES:+$SERVICES }dhcpcd wpa_supplicant acpid")}"

export SERVICES="$enable_services"
