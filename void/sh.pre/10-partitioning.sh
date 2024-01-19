#!/bin/sh

# choose the partitioning mode
case "${partitioning_mode:-$(chmenu 'How should the disk be provisioned?' 'automatically' 'manually' | head -c1)}" in
    [mM]|[mM]anual) partitioning_mode="m" ;;
      [aA]|[aA]uto) partitioning_mode="a" ;;
                 *) printf "${0##*/}: error: invalid operand $partitioning_mode for option partitioning_mode\n"; exit 1 ;;
esac

# choose the disk to install void to
[ -z "$disk" ] && eval "disk=\"$(chmenu "Which disk do you want to use?" $(lsblk -ndo path))\""
