#
# ~/.bash_profile
#

if [ "$(tty)" = "/dev/tty1" ]; then
  exec start-hyprland
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
