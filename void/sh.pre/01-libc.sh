#!/bin/sh

case "${libc:-$(chmenu "Which libc implementation would you like to use?" "glibc (choose if unsure)" "musl")}" in
    [gG]libc*|libc6) libc="glibc"; export XBPS_REPO="https://repo-default.voidlinux.org/current"; export PACKAGES="${PACKAGES:+$PACKAGES }glibc-locales" ;;
            [mM]usl) libc="musl"; export XBPS_REPO="https://repo-default.voidlinux.org/musl"; export PACKAGES="${PACKAGES:+$PACKAGES }musl" ;;
                  *) printf "${0##*/}: error: invalid operand $libc for option libc\n"; exit 1 ;;
esac
