#!/bin/sh

# choose the partitioning mode
case "${partitioning_mode:-$(chmenu 'How should the disk be provisioned?' 'automatically' 'manually' | head -c1)}" in
    [mM]|[mM]anual) partitioning_mode="m" ;;
      [aA]|[aA]uto) partitioning_mode="a" ;;
                 *) printf "${0##*/}: error: invalid operand $partitioning_mode for option partitioning_mode\n"; exit 1 ;;
esac

# choose the disk to install void to
[ -z "$disk" ] && eval "disk=\"$(chmenu "Which disk do you want to use?" $(lsblk -ndo path))\""

# get the disk preset from the user if not supplied
case "$partitioning_preset" in
    efi+bios:gpt|bios+efi:gpt|both:gpt|bios:gpt|bios:mbr|efi:gpt) ;;
    *) partitioning_preset="$(chmenu 'Which boot layout preset would you like to use?' "efi+bios:gpt" "efi:gpt" "bios:gpt" "bios:mbr")" ;;
esac
