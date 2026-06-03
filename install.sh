#!/bin/bash

# wifi
# update omarchy

# curl -LO https://raw.githubusercontent.com/sikoramodra/dotfiles/main/install.sh
# chmod +x install.sh
# ./install.sh 1

set -euo pipefail

STAGE="$1"

if [ "$STAGE" == 1 ]; then
    omarchy-install-terminal foot
    omarchy-install-terminal kitty
    omarchy-install-zed
    omarchy-install-browser brave-origin
    sudo pacman -S --noconfirm stow fish adobe-source-code-pro-fonts tela-circle-icon-theme-blue

    git clone https://github.com/sikoramodra/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    curl -fsSL https://raw.githubusercontent.com/tomhayes/omadot/main/install.sh | bash
fi

# Left-Top corner > System > Logout
# CTRL ALT F2
# ./install.sh 2

if [ "$STAGE" == 2 ]; then
    rm -f ~/.local/share/applications/{Alacritty,imv,typora}.desktop
    rm -f ~/.config/{chromium-flags.conf,mimeapps.list,omarchy.ttf,starship.toml,user-dirs.dirs,xdg-terminals.list,brave-origin-beta-flags.conf}
    rm -f ~/.bashrc

    for dir in autostart environment.d fastfetch fcitx5 fontconfig foot git \
        gtk-3.0 hypr hyprland-preview-share-picker imv kitty mise nvim omarchy \
        qalculate swayosd uwsm walker waybar wiremix wireplumber zed; do
        rm -rf "$HOME/.config/$dir"
    done

    # preserve:
    # ~/.config/btop/themes/
    # ~/.config/elephant/menus/
    rm -f ~/.config/btop/btop.conf
    rm -f ~/.config/elephant/{calc,desktopapplications,symbols}.toml

    cd ~/.dotfiles
    omadot put --all

    omarchy-theme-set Onedark
fi

# Reboot
# ./install.sh 3

if [ "$STAGE" == 3 ]; then
    omarchy-default-browser brave-origin

    omarchy-remove-preinstalls
    sudo pacman -S --noconfirm cliamp lazydocker pinta obs-studio kdenlive gimp gparted xorg-xhost 7zip cava figlet
    # https://github.com/bjarneo/cliamp/blob/main/docs/youtube-music.md
    omarchy-tui-install Docker lazydocker float file:///usr/share/icons/Tela-circle-blue/scalable/apps/docker.svg

    rm -rf ~/.agents ~/.claude ~/.codex ~/.pi ~/Work

    omarchy-pkg-aur-add breezex-cursor-theme
    gsettings set org.gnome.desktop.interface cursor-theme 'BreezeX-Dark'
    # dconf dump /org/gnome/desktop/interface

    # [dev]
    sudo pacman -S --noconfirm nginx tree-sitter-cli valkey postgresql act delve go go-tools pgformatter
    omarchy-install-browser zen
    omarchy-pkg-aur-add beekeeper-studio-bin yaak-bin bruno-bin etcher-bina simplenote-electron-bin
    sudo pacman -Rns --noconfirm alacritty bruno-bin-debug simplenote-electron-bin-debug
fi

# Manual:
# nvim :MasonInstallAll :TSInstallAll
#
# copy cliamp ytmusic secret
#
# brave://flags/#enable-webrtc-allow-input-volume-adjustment
# sync - have sync code -> Localsend
