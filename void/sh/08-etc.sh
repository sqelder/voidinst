#!/bin/sh

# remove the default homedir skeleton
[ -d "$SCDIR/etc/skel" ] && rm -rf $VDIR/etc/skel

# copy custom configs to the install
cp -rfv "$SCDIR/etc" "$VDIR"

# get URL of repository in etc/skel
[ -r "$SCDIR/.gitmodules" ] && {
    line_count="$(wc -l <"$SCDIR/.gitmodules")"
    start_line="$(nl -b a $SCDIR/.gitmodules | awk '/submodule "etc\/skel"/ {print $1}')"
    url="$(tail -n $(((line_count-start_line)+1)) "$SCDIR/.gitmodules" | head -n 3 | awk '/url/ {print $3}')"
}

# replace skel's dummy .git
[ -d "$SCDIR/etc/skel" ] && {
    rm -rf "$VDIR/etc/skel/.git"

    # re-clone a bare copy of the repo
    chroot $VDIR which git && {
        chroot $VDIR git clone --bare "$url" "$VDIR/etc/skel/.git"
        chroot $VDIR sh -c 'cd /etc/skel/.git && git --git-dir=/etc/skel/.git config --bool core.bare false'
        chroot $VDIR sh -c 'cd /etc/skel && git reset --hard'
    }
}
