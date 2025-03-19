#
# ~/.bash_profile
#

if [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
fi

export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1

[[ -f ~/.bashrc ]] && . ~/.bashrc
