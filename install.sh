#!/bin/bash

# wifi
# update omarchy

# curl -LO https://raw.githubusercontent.com/sikoramodra/dotfiles/main/install.sh
# chmod +x install.sh
# ./install.sh

set -euo pipefail

omarchy-install-terminal kitty
omarchy-install-terminal foot

omarchy-install-editor-zed

omarchy-install-browser brave-origin
omarchy-default-browser brave-origin

sudo pacman -S --noconfirm stow zsh adobe-source-code-pro-fonts
omarchy-font-set "Source Code Pro"
omarchy-pkg-aur-add zimfw

git clone https://github.com/sikoramodra/dotfiles.git ~/.dotfiles

omarchy-remove-preinstalls
sudo pacman -S --noconfirm tela-circle-icon-theme-blue cliamp lazydocker pinta obs-studio kdenlive gimp gparted xorg-xhost 7zip cava figlet gnome-calculator
omarchy-tui-install Docker lazydocker float file:///usr/share/icons/Tela-circle-blue/scalable/apps/docker.svg
omarchy-setup-security-sudoless-docker

omarchy-pkg-aur-add breezex-cursor-theme
gsettings set org.gnome.desktop.interface cursor-theme 'BreezeX-Dark'

cd ~/.dotfiles
stow --adopt .

omarchy-theme-set Onedark

rm -rf ~/.claude ~/.codex ~/Work

sudo pacman -S --noconfirm nginx valkey postgresql act delve uv go go-tools pgformatter usbutils meson mkcert
omarchy-pkg-aur-add beekeeper-studio-bin yaak-bin bruno-bin etcher-bin simplenote-electron-bin
mkcert -install

go telemetry off
sudo pacman -S --noconfirm bitwarden
omarchy-pkg-aur-add ente-auth-bin
# n ~/.local/share/keyrings/Default_keyring.keyring - ente auth secret in single line

mise prune

nvim --headless -c "autocmd User LazyDone MasonInstallAll" -c "TSInstallAll" +qall

# Reboot

# Manual:
#
# Balena Etcher > Settings > turn off anonymous reports
#
# Bitwarden > Timeout > Never
# Bitwarden > unlock with system authentication > on
# Bitwarden > clear clipboard > 2min
# Bitwarden > minimize when copying > off
# Bitwarden > allow browser integration > on
# Bitwarden > start automatically on login > off
#
# Bruno > Theme > Dark Monochrome
# Bruno > Editor Font > Source Code Pro
# Bruno > turn off automatic updates, ~telemetry
#
# Files > show hidden files
# Files > Preferences > turn on sort folders before files
#
# LocalSend > Color > System
# LocalSend > Minimize to tray > on
# LocalSend > Autostart after login > off
# LocalSend > Auto Finish > on
#
# Cliamp > ytmusic secret
#
# SimpleNote > Login > turn on menu bar hide automatically, turn off notify on remote changes, zoom in/out
#
# Yaak > Dark Theme > Atom One Dark
# Yaak > Manual update behavior, turn off check for notifications
# Yaak > Editor Font > Source Code Pro
# Yaak > Vim Keymap, turn off wrap lines, turn on colorize HTTP methods
# Yaak > turn on hide window controls
#
# Brave
#
# ssh-keygen && cat ~/.ssh/id_ed25519.pub
# brave-origin https://github.com/settings/ssh/new
# git remote set-url origin git@github.com:sikoramodra/dotfiles.git
#
# rm ~/install.sh
