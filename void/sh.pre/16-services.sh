#!/bin/sh

# services to enable
[ -z "$enable_services" ] && enable_services="$(chopt "Which runit services should be enabled?" "dhcpcd wpa_supplicant acpid")"

export SERVICES="${SERVICES:+$SERVICES }$enable_services"
