# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export SUDO_EDITOR="$EDITOR"
export PATH="$PATH:$HOME/go/bin"
