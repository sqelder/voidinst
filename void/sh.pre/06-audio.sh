#!/bin/sh

# choose the audio setup
case "${audio_setup:-$(chmenu "Which audio interface do you want to use?" "ALSA" "PipeWire" "PulseAudio" "sndio" "none")}" in
    [aA][lL][sS][aA])
        export PACKAGES="${PACKAGES:+$PACKAGES }alsa-utils"
        export SERVICES="${SERVICES:+$SERVICES }alsa"
        btpkg="bluez-alsa"
        ;;
    [pP][iI][pP][eE][wW][iI][rR][eE]|[pP][iI][pP][eE])
        export PACKAGES="${PACKAGES:+$PACKAGES }wireplumber pipewire pipewire-pulse"
        export SERVICES="${SERVICES:+$SERVICES }"
        btpkg="libspa-bluetooth"
        ;;
    [pP][uU][lL][sS][eE][aA][uU][dD][iI][oO]|[pP][uU][lL][sS][eE])
        export PACKAGES="${PCAKAGES:+$PACKAGES }piulseaudio alsa-plugins-pulseaudio"
        ;;
    [sS][nN][dD][iI][oO])
        export PACKAGES="${PACKAGES:+$PACKAGES }sndio aucatctl"
        export SERVICES="${SERVICES:+$SERVICES }sndiod"
        ;;
    [nN]|[nN][oO][nN][eE])
        ;;
    *) printf "${0##*/}: error: invalid operand $audio_setup to option audio_setup\n"; exit 1 ;;
esac
