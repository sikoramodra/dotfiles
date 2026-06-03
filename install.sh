#!/bin/bash

# wifi
# update omarchy

# curl -LO https://raw.githubusercontent.com/sikoramodra/dotfiles/main/install.sh
# chmod +x install.sh
# ./install.sh

set -euo pipefail

STAGE="$1"

if [ "$STAGE" == 1 ]; then
    omarchy-install-terminal foot
    omarchy-install-terminal kitty
    omarchy-install-zed
    omarchy-install-browser brave-origin
    sudo pacman -S stow fish adobe-source-code-pro-fonts tela-circle-icon-theme-blue

    git clone https://github.com/sikoramodra/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    curl -fsSL https://raw.githubusercontent.com/tomhayes/omadot/main/install.sh | bash
fi

# Left-Top corner > System > Logout
# CTRL ALT F2

if [ "$STAGE" == 2 ]; then
    # for VAR in LIST; do
    #     omadot get hypr
    #     git reset
    #     omadot put hypr
    # done

    rm -rf ~/.config/hypr/
    omadot put hypr

    rm -rf ~/.config/xdg-terminals.list
    rm -rf ~/.config/wireplumber/
    rm -rf ~/.config/wiremix/
    rm -rf ~/.config/waybar/
    rm -rf ~/.config/walker/
    rm -rf ~/.config/uwsm/
    rm -rf ~/.config/user-dirs.dirs
    rm -rf ~/.config/systemd/
    rm -rf ~/.config/swayosd/
    rm -rf ~/.config/starship.toml
    rm -rf ~/.config/qalculate/
    rm -rf ~/.config/omarchy.ttf
    rm -rf ~/.config/omarchy/
    rm -rf ~/.config/nvim/
    rm -rf ~/.config/mise/
    rm -rf ~/.config/mimeapps.list
    rm -rf ~/.config/kitty/
    rm -rf ~/.config/imv/
    rm -rf ~/.config/hyprland-preview-share-picker/
    rm -rf ~/.config/gtk-3.0/
    rm -rf ~/.config/git/
    rm -rf ~/.config/foot/
    rm -rf ~/.config/fontconfig/
    rm -rf ~/.config/fcitx5/
    rm -rf ~/.config/fastfetch/
    rm -rf ~/.config/environment.d/
    rm -rf ~/.config/elephant/
    rm -rf ~/.config/chromium-flags.conf
    rm -rf ~/.config/btop/
    rm -rf ~/.bashrc
    rm -rf ~/.config/autostart/

    omadot put --all --exclude=applications

    rm ~/.local/share/applications/Alacritty.desktop
    rm ~/.local/share/applications/imv.desktop
    rm ~/.local/share/applications/typora.desktop
    omadot put applications

    # omarchy-theme-set Onedark

    # reboot
fi

if [ "$STAGE" == 3 ]; then
    omarchy-default-browser brave-origin
    # manual disable brave://flags/#enable-webrtc-allow-input-volume-adjustment
    # sync - have sync code - >I >localsend

    omarchy-remove-preinstalls
    sudo pacman -S cliamp pinta obs-studio kdenlive lazydocker
    # (https://github.com/bjarneo/cliamp/blob/main/docs/youtube-music.md)

    omarchy-tui-install Docker lazydocker float file:///usr/share/icons/Tela-circle-blue/scalable/apps/docker.svg

    sudo pacman -S gimp gparted xorg-xhost 7zip cava figlet
    # sudo pacman -Rns alacritty

    rm -rf .agents .claude .codex .pi Work

    omarchy-pkg-aur-add breezex-cursor-theme
    gsettings set org.gnome.desktop.interface cursor-theme 'BreezeX-Dark'
    # (dconf dump /org/gnome/desktop/interface)

    # [dev]
    sudo pacman -S nginx tree-sitter-cli valkey postgresql act delve go go-tools pgformatter
    omarchy-install-browser zen
    omarchy-pkg-aur-add beekeeper-studio-bin yaak-bin bruno-bin etcher-bina simplenote-electron-bin

    nvim :MasonInstallAll :TSInstallAll

    sudo pacman -Rns bruno-bin-debug simplenote-electron-bin-debug

    # copy cliamp ytmusic secret
fi
