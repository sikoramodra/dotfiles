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
    sudo pacman -S --needed --noconfirm linux-lts hyprland kitty rofi-wayland rofi-calc fish adobe-source-code-pro-fonts nemo nemo-share nemo-fileroller viewnior gimp mpv kdenlive obs-studio gnome-calculator gparted xorg-xhost polkit-gnome hyprlock pipewire pipewire-audio pipewire-jack pipewire-pulse pulsemixer pavucontrol kvantum kvantum-qt5 tela-circle-icon-theme-blue brightnessctl power-profiles-daemon cups powertop cliphist hyprpaper fastfetch cava zoxide eza fd stow noto-fonts noto-fonts-cjk noto-fonts-emoji tree fzf ripgrep inetutils imagemagick wf-recorder pacman-contrib fuse2 xdg-user-dirs xdg-desktop-portal-gtk xdg-desktop-portal-hyprland gvfs-mtp 7zip figlet zed pnpm typescript typescript-language-server prettier eslint go go-tools gopls delve uv ruff nginx docker docker-compose docker-buildx act bash-language-server shellcheck shfmt gdb postgresql valkey
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

xdg-user-dirs-update

## Stow
if confirm "Do you want to link dotfiles to system files?"; then
    rm ~/.bash_profile ~/.bashrc
    mkdir -p ~/.local/share/icons

    cd dotfiles
    stow .
    cd ..
    clear
fi

## tty1
if confirm "Do you want to skip username on tty1?"; then
    sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
    sudo tee /etc/systemd/system/getty@tty1.service.d/skip-username.conf >/dev/null <<'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -- wm' --noclear --skip-login - $TERM
EOF
    clear
fi

## QT/GTK
if confirm "Do you want to add QT/GTK environment variables?"; then
    sudo tee -a /etc/environment >/dev/null <<'EOF'
QT_QPA_PLATFORM=wayland
QT_QPA_PLATFORMTHEME=qt5ct
QT_WAYLAND_DISABLE_WINDOWDECORATION=1
QT_AUTO_SCREEN_SCALE_FACTOR=1
QT_STYLE_OVERRIDE=kvantum
GTK_THEME=Arc-Dark
EOF
    clear
fi

## Services
info "enabling system services..."
sudo systemctl enable --now docker.service
sudo systemctl enable --now nginx.service
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now cups.service
sudo usermod -aG docker wm
clear

## HP soft-block wifi fix
if confirm "Do you want to fix wifi soft-block on HP laptop?"; then
    sudo tee /etc/systemd/system/hp-keycodes.service >/dev/null <<'EOF'
[Unit]
Description=HP setkeycodes fix

[Service]
Type=oneshot
Restart=no
RemainAfterExit=no
ExecStart=/usr/bin/setkeycodes e057 240 e058 240

[Install]
WantedBy=rescue.target
WantedBy=multi-user.target
WantedBy=graphical.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable --now hp-keycodes.service

    clear
fi

## Other
mkdir ~/Projects
go telemetry off
clear

## Default apps
if confirm "Do you want to set default apps?"; then
    # xdg-mime query default [file/extension]
    # gio mime [file/extension]
    gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty
    sudo update-desktop-database
fi

## HP printer
# if confirm "Do you want to configure HP printers?"; then
#     # https://developers.hp.com/hp-linux-imaging-and-printing/gethplip
#     # https://developers.hp.com/hp-linux-imaging-and-printing/install/install/index
#     sudo pacman -S --needed --noconfirm hplip pyqt5
#     QT_QPA_PLATFORM=xcb hp-setup
#     # Select Network/Wireless (switch printer on)
# fi

#   __  __    _    _   _ _   _   _    _
#  |  \/  |  / \  | \ | | | | | / \  | |
#  | |\/| | / _ \ |  \| | | | |/ _ \ | |
#  | |  | |/ ___ \| |\  | |_| / ___ \| |___
#  |_|  |_/_/   \_\_| \_|\___/_/   \_\_____|
#

# sudo nvim /etc/pacman.conf
# Color
# CheckSpace
# VerbosePkgLists
# ParallelDownloads = 7

# sudo nvim /etc/default/grub
# GRUB_TOP_LEVEL="/boot/vmlinuz-linux"
# sudo grub-mkconfig -o /boot/grub/grub.cfg

#### SIMPLENOTE
# Login
# Theme: Dark
# Menu Bar: Hide Automatically
# Notify on remote changes: false

#### BRAVE
# brave://flags/
# Preferred Ozone platform: Auto
#
# Settings > Sync > I have a sync code
# Get through simplenote
# Check sync (all except: PWAs, reading list, tab groups)
# relaunch
#
# # Customize
# Show sponsored imgs: false
# Top sites: false
# Cards: false
# Search: false
# Scroll down > Brave news: false
#
# # Settings > Appearance
# colors: Dark
# # Settings > Toolbar
# home button: false
# bookmarks button: false
# show bookmarks: never
# news button: false
# ai button: false
# rewards button: false
# wallet button: false
# sidebar button: false
# autocomplete suggestions > ai assistant: false
# wide addres bar: true
# full URLs: true
# vertical tabs: true
# tab search button: false
# # Settings > Privacy and Security > Data collection: all false
# # Settings > Leo
# leo icon: false
# leo in context menus: false
# conversation history: false
# # Settings > Search engine
# google :/ searxng ;)
# improve search suggestions: false
# menage search engines - to add:
# pac: Arch packages
# aw: Arch Wiki
# aur: AUR packages
# # Settings > Extensions
# Widevine: true

#### GITHUB
# Settings > SSH keys > new
# ssh-keygen
# cat ~/.ssh/id_ed25519.pub
# git remote set-url origin git@github.com:sikoramodra/dotfiles.git

#### NEMO
# # Preview > for files smaller than 100MB
# Toolbar: [Prev, Next, Up, Refresh, Open in Terminal, Search]
# Context Menus > Selection:
# Without: [Duplicate, Pin, Favourite, Make Link, Copy to, Move to]
# # View
# Status bar: false
# Show hidden files: true
# Toolbar: Location Entry: true
