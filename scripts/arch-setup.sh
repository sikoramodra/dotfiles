#!/usr/bin/env bash

# nmtui
# git clone https://github.com/sikoramodra/dotfiles.git
# chmod +x ./dotfiles/scripts/arch-setup.sh
# ./dotfiles/scripts/arch-setup.sh

set -euo pipefail # Exit on error, undefined variables, and pipe failures

# Color codes for better output
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

confirm() {
    local prompt="$1"
    local response

    while true; do
        read -r -p "$prompt [Y/n] " response
        response=${response:-Y}
        case "$response" in
        [Yy] | [Yy]es) return 0 ;;
        [Nn] | [Nn]o) return 1 ;;
        *) echo "Please answer yes or no." ;;
        esac
    done
}

## Root check
if [ "$(id -u)" = 0 ]; then
    error "This script CAN'T be run as root user!"
    exit 1
fi

clear

## Packages
while confirm "Do you want to install system's packages?"; do
    info "Installing pacman packages..."
    sudo pacman -S --needed --noconfirm linux-lts hyprland kitty rofi-wayland rofi-calc fish nemo viewnior gimp mpv kdenlive obs-studio okular gnome-calculator gparted polkit-gnome hyprlock pipewire pipewire-audio pipewire-jack pipewire-pulse pulsemixer pavucontrol ark kvantum kvantum-qt5 tela-circle-icon-theme-blue brightnessctl power-profiles-daemon powertop cliphist hyprpaper fastfetch cava zoxide eza stow noto-fonts noto-fonts-cjk noto-fonts-emoji tree fzf ripgrep inetutils imagemagick wf-recorder pacman-contrib xdg-user-dirs xdg-desktop-portal-gtk xdg-desktop-portal-hyprland 7zip zed pnpm typescript typescript-language-server prettier eslint go go-tools gopls delve uv ruff nginx docker docker-compose docker-buildx act bash-language-server shellcheck shfmt postgresql valkey
    clear

    info "Installing paru..."
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si
    cd ..
    rm -rf paru-bin
    clear

    info "Installing AUR packages..."
    paru -S --needed --noconfirm brave-bin ags-hyprpanel-git arc-gtk-theme simplenote-electron-bin hyprpicker breezex-cursor-theme etcher-bin grimblast-git pipes.sh gotop-bin yaak-bin basedpyright
    clear
done

# git config --global init.defaultBranch main
# git config --global user.email "wojciechmodro@gmail.com"
# git config --global user.name "sikoramodra"

# git@github.com:sikoramodra/dotfiles.git

# git clone https://aur.archlinux.org/paru-bin
# cd paru-bin/
# makepkg -si
# xdg-user-dirs-update

# cd ~
# git clone https://github.com/sikoramodra/dotfiles
# cd dotfiles
# rm ~/.bash_profile
# stow .

# mkdir -p ~/.local/share/icons
# cp -r dotfiles/other/.local/share/icons/BreezeX-Dark-hyprcursor ~/.local/share/icons/

# sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
# sudo vim /etc/systemd/system/getty@tty1.service.d/skip-username.conf
# [Service]
# ExecStart=
# ExecStart=-/sbin/agetty -o '-p -- wm' --noclear --skip-login - $TERM

# nvim /etc/pacman.conf
# Color
# CheckSpace
# # ILoveCandy
# VerbosePkgLists
# ParallelDownloads = 7

# nvim /etc/paru.conf
# BatchInstall
# SudoLoop
# UpgradeMenu
# NewsOnUpgrade

# sudo nvim /etc/enviroment
# QT_QPA_PLATFORM=wayland
# QT_QPA_PLATFORMTHEME=qt5ct
# QT_WAYLAND_DISABLE_WINDOWDECORATION=1
# QT_AUTO_SCREEN_SCALE_FACTOR=1
# QT_STYLE_OVERRIDE=kvantum
# GTK_THEME=Arc-Dark

# sudo systemctl enable --now docker.service
# sudo systemctl enable --now nginx.service
# sudo systemctl enable --now bluetooth.service

# ~sudo systemctl enable --now cups.service
# https://developers.hp.com/hp-linux-imaging-and-printing/gethplip
# pac -S hplip pyqt5
# https://developers.hp.com/hp-linux-imaging-and-printing/install/install/index
# https://developers.hp.com/hp-linux-imaging-and-printing/install/install/index
# hp-setup

# cd ~
# rm -rf paru-bin/

# mkdir -p .local/share/rofi/themes
# cp -r dotfiles/.config/rofi/onedark.rasi ~/.local/share/rofi/themes/

# #### BRAVE, GITHUB
# ozone platform wayland

# sudo usermod -aG docker wm

# go install golang.org/x/vuln/cmd/govulncheck@latest
# go install github.com/daixiang0/gci@latest

# /etc/default/grub
# GRUB_TOP_LEVEL="/boot/vmlinuz-linux"

# sudo nvim /etc/systemd/system/hp-keycodes.service
# [Unit]
# Description=HP setkeycodes fix

# [Service]
# Type=oneshot
# Restart=no
# RemainAfterExit=no
# ExecStart=/usr/bin/setkeycodes e057 240 e058 240

# [Install]
# WantedBy=rescue.target
# WantedBy=multi-user.target
# WantedBy=graphical.target

# sudo systemctl daemon-reload
# sudo systemctl enable --now hp-keycodes.service
