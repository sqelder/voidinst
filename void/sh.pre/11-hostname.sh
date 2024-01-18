#!/bin/sh

# hostname
hostname="${hostname:-$(chopt "What do you want to set as the hostname?" "voidlinux")}"
