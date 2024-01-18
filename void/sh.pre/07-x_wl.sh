#!/bin/sh

display_setup="${display_setup:-$(chmenu "Which display server would you like to use?" "None" "Wayland (pure)" "Wayland (X11 compatibility)" "X11")}"

# install graphics
case "$display_setup" in
    [nN]one)
        display_setup="none" ;;
    [wW]ayland*pure*)
        [ "$install_dev_packages" = "y" ] && export PACKAGES="${PACKAGES:+$PACKAGES }wlroots-devel"
        export PACKAGES="${PACKAGES:+$PACKAGES }wayland mesa-dri vulkan-loader dbus seatd wlroots way-displays wl-clipboard"
        export DEFAULTGROUPS="${DEFAULTGROUPS:+$DEFAULTGROUPS,}_seatd"
        export SERVICES="${SERVICES:+$SERVICES }dbus seatd"
        ;;
    [wW]ayland*compat*)
        [ "$install_dev_packages" = "y" ] && export PACKAGES="${PACKAGES:+$PACKAGES }wlroots-devel"
        export PACKAGES="${PACKAGES:+$PACKAGES }wayland mesa-dri vulkan-loader dbus seatd wlroots way-displays wl-clipboard xorg-server-xwayland"
        export DEFAULTGROUPS="${DEFAULTGROUPS:+$DEFAULTGROUPS,}_seatd"
        export XORG="y"
        export SERVICES="${SERVICES:+$SERVICES }dbus seatd"
        ;;
    [xX]11|[xX]org)
        export XORG="y"
        export PACKAGES="${PACKAGES:+$PACKAGES }mesa-dri vulkan-loader dbus xorg-server xbacklight xclip xdpyinfo xinit xinput xkbutils xprop xrandr xrdb xset xsetroot xf86-input-evdev xf86-input-libinput xf86-input-synaptics libX11 libXft libXcursor libXinerama"
        [ "$install_dev_packages" = "y" ] && export PACKAGES="${PACKAGES:+$PACKAGES }libX11-devel libXft-devel libXinerama-devel libXcursor-devel"
        export SERVICES="${SERVICES:+$SERVICES }dbus"
        ;;
    *) printf "${0##*/}: error: invalid operand $display_setup to option display_setup\n"; exit 1 ;;
esac

# skip gfx driver installation if not setting up a display server
case "$display_setup" in
    none) return ;;
esac

# intel graphics drivers
case "${intel_gfxdrivers:-$(chmenu "Would you like to install Intel graphics drivers?" "yes" "no")}" in
    [yY]|[yY]es)
        export PACKAGES="${PACKAGES:+$PACKAGES }mesa-vulkan-intel intel-video-accel"
        ;;
    [nN]|[nN]o)
        ;;
    *) printf "${0##*/}: error: invalid operand $intel_gfxdrivers to option intel_gfxdrivers\n"; exit 1 ;;
esac


# amd graphics drivers
case "${amd_gfxdrivers:-$(chmenu "Would you like to install AMD graphics drivers?" "yes" "no")}" in
    [yY]|[yY]es)
        # decide which gpu driver to install
        case "${amd_gpu_driver:-$(chmenu "Which GPU driver should be installed?" "mesa-vulkan-radeon" "amdvlk")}" in
            mesa-vulkan-radeon) ;;
            amdvlk) ;;
            *) printf "${0##*/}: error: invalid operand $amd_gpu_driver to option amd_gpu_driver\n"; exit 1 ;;
        esac

        export PACKAGES="${PACKAGES:+$PACKAGES }mesa-vaapi mesa-vdpau $amd_gpu_driver"
        [ "$XORG" = "y" ] && export PACKAGES="${PACKAGES:+$PACKAGES }xf86-video-amdgpu xf86-video-ati"
        ;;
    [nN]|[nN]o)
        ;;
    *) printf "${0##*/}: error: invalid operand $amd_gfxdrivers to option amd_gfxdrivers\n"; exit 1 ;;
esac


# nvidia graphics drivers
case "${nvidia_gfxdrivers:-$(chmenu "Would you like to install Nvidia graphics drivers?" "yes" "no")}" in
    [yY]|[yY]es)
        case "${nvidia_gpu_driver:-$(chmenu "Which GPU driver should be installed?" "nouveau" "nvidia (glibc only)" "nvidia470 (glibc only)" "nvidia390 (glibc only)")}" in
            nouveau)
                [ "$XORG" = "y" ] && export PACKAGES="${PACKAGES:+$PACKAGES }xf86-video-nouveau"
                ;;
            nvidia*)
                export NVIDIA_PKG="${nvidia_gpu_driver%% *}"
                ;;
            *) printf "${0##*/}: error: invalid operand $nvidia_gpu_driver to option nvidia_gpu_driver\n"; exit 1 ;;
        esac
        ;;
    [nN]|[nN]o)
        ;;
    *) printf "${0##*/}: error: invalid operand $nvidia_gfxdrivers to option nvidia_gfxdrivers\n"; exit 1 ;;
esac
