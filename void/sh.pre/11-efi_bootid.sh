#!/bin/sh

# set the boot entry name (only used in EFI)
export bootentry_name="${bootentry_name:-$(chopt "What do you want to name the boot entry for the new system?" "Void Linux")}"
