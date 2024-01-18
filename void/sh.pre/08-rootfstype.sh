#!/bin/sh

# choose the filesystem for /
case "$root_fs" in
    ext[234]|f2fs|btrfs|xfs) ;;
    *) root_fs="$(chmenu 'Which filesystem would you like to use for the system root (/)?' 'ext4' 'ext3' 'ext2' 'f2fs' 'btrfs' 'xfs')"
esac
