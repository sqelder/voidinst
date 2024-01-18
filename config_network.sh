#!/bin/sh

# wpa_supplicant network config wizard

# cd to the directory of the script
_IFS="$IFS"
IFS="/"
for i in $0; do
    [ -d "$i" ] && cd $i
done
IFS="$_IFS"

# add the script's utilities to PATH
[ -d "$PWD/bin" ] && {
    export PATH="$PWD/bin${PATH:+:$PATH}"
} || {
    printf "${0##*/}: error: failed to modify PATH\n"
    exit 1
}

# command dependencies
requirecmd sv wpa_passphrase chopt chmenu || exit 1

# check if we have root permissions for the install
case "${EUID:-${UID:-$(id -u)}}" in
    0) ;;
    *) printf "${0##*/}: error: Operation not permitted\n"; exit 2 ;;
esac

# whether to add a network or reload the network configuration
while true; do
    case "$(chmenu "What would you like to do?" "Add a wireless network" "Reload the network configuration" "Exit this menu")" in
        Exit*) exit ;;
        Reload*) sv restart wpa_supplicant dhcpcd ;;
        Add*)
            network_name="$(chopt 'What is the network name/SSID?')"
            network_password="$(chopt 'What is the network password? [ENTER=none] ')"

            [ -n "$network_password" ] && {
                wpa_passphrase "$network_name" "$network_password" >>/etc/wpa_supplicant/wpa_supplicant.conf
            } || {
                printf "network={\n\tssid=\"$network_name\"\n}\n" >>/etc/wpa_supplicant/wpa_supplicant.conf
            }
            ;;
    esac
done
