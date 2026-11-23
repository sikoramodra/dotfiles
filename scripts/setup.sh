#!/bin/bash

# nmtui
# git clone https://github.com/sikoramodra/dotfiles.git
# chmod +x ./dotfiles/scripts/setup.sh
# ./dotfiles/scripts/setup.sh

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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT="$(dirname "$SCRIPT_DIR")/default"
ETC="$(dirname "$SCRIPT_DIR")/etc"

## Root check
if [ "$(id -u)" = 0 ]; then
  error "This script CAN'T be run as root user!"
  exit 1
fi

## Temporary passwordless sudo
sudo tee /etc/sudoers.d/99-install-nopasswd >/dev/null <<'EOF'
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
EOF

## AUR helper
if confirm "Do you want to install yay?"; then
  info "Installing yay..."
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si --noconfirm
  rm -rf yay-bin
fi

## Limine config
if confirm "Do you want to configure Snapper and Plymouth for Limine?"; then
  info "Configuring Limine..."
  sudo mkdir -p /boot/limine-entry-tool.d
  sudo cp -f "$DEFAULT/limine/limine.conf" /boot/limine.conf
  sudo cp -f "$ETC/limine-entry-tool.d/defaults.conf" /etc/limine-entry-tool.d/defaults.conf

  sudo pacman -Syy --needed --noconfirm snapper snap-pac plymouth
  yay -S --needed --noconfirm limine-mkinitcpio-hook limine-snapper-sync

  sudo mkdir -p /etc/mkinitcpio.conf.d
  sudo cp -f "$ETC/mkinitcpio.conf.d/00-hooks.conf" /etc/mkinitcpio.conf.d/00-hooks.conf

  sudo limine-install
  sudo limine-install --skip-uefi --fallback
  sudo limine-update

  # Snapper
  info "Configuring snapper..."
  sudo mkdir -p /etc/{snapper/configs,conf.d}
  sudo cp -f "$ETC/snapper/configs/root" /etc/snapper/configs/root
  sudo cp -f "$ETC/conf.d/snapper" /etc/conf.d/snapper

  sudo systemctl enable snapper-cleanup.timer limine-snapper-sync.service
  sudo limine-snapper-sync

  # Plymouth
  info "Configuring Plymouth..."
  sudo mkdir -p /usr/share/plymouth/themes/
  sudo cp -fr "$DEFAULT/plymouth/arch" /usr/share/plymouth/themes/
  sudo plymouth-set-default-theme arch
  sudo limine-mkinitcpio
fi

sudo rm -f /etc/sudoers.d/99-install-nopasswd

# LATER: uwsm

# ## Packages
# if confirm "Do you want to install system's packages?"; then
#   info "Installing pacman packages..."
#   # Desktop / Wayland
#   desktop=(hyprland *hyprlock *hyprpaper *cliphist *wf-recorder brightnessctl
#     xdg-xdg-terminal-exec xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xorg-xhost *polkit-gnome)
#
#   # Terminals / shell
#   shell=(kitty foot zsh zoxide eza fd fzf ripgrep tree stow figlet inetutils)
#
#   # Fonts
#   fonts=(adobe-source-code-pro-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji)
#
#   # Theming
#   theme=(*kvantum *kvantum-qt5 tela-circle-icon-theme-blue)
#
#   # Audio
#   audio=(pipewire pipewire-audio pipewire-jack pipewire-pulse *pulsemixer *pavucontrol cava)
#
#   # Files / system utilities
#   system=(nautilus gvfs-mtp gparted gnome-calculator 7zip fuse2 xdg-user-dirs
#     pacman-contrib fastfetch btop)
#
#   # Power / printing
#   power=(power-profiles-daemon powertop cups)
#
#   # Media / graphics
#   media=(imv imagemagick gimp mpv yt-dlp kdenlive obs-studio zbar)
#
#   # Dev
#   dev=(zed
#     pnpm typescript typescript-language-server prettier eslint
#     go go-tools gopls delve
#     python-pip uv ruff
#     bash-language-server shellcheck shfmt gdb
#     docker docker-compose docker-buildx act
#     nginx postgresql valkey)
#
#   sudo pacman -S --needed --noconfirm \
#     "${desktop[@]}" "${shell[@]}" "${fonts[@]}" "${theme[@]}" "${audio[@]}" \
#     "${system[@]}" "${power[@]}" "${media[@]}" "${dev[@]}"
#   clear
#
#   info "Installing AUR packages..."
#   yay -S --needed --noconfirm brave-origin-bin ags-hyprpanel-git arc-gtk-theme simplenote-electron-bin hyprpicker breezex-cursor-theme etcher-bin grimblast-git pipes.sh yaak-bin
#   clear
# fi
#
# xdg-user-dirs-update
#
# ## Stow
# if confirm "Do you want to link dotfiles to system files?"; then
#   cd dotfiles
#   stow . --adopt
#   cd ..
#   clear
# fi

# # Hidden desktop files
# if confirm "Do you want to set up a hidden desktop files?"; then
#   mkdir -p ~/.local/share/applications
#
#   list=(avahi-discover.desktop bssh.desktop btop.desktop bvnc.desktop cmake-gui.desktop hp-uiscan.desktop hplip.desktop kvantummanager.desktop qv4l2.desktop qvidcap.desktop lstopo.desktop org.gnome.FileRoller.desktop rofi.desktop rofi-theme-selector.desktop)
#
#   for item in "${list[@]}"; do
#     cp /usr/share/applications/"$item" ~/.local/share/applications/
#     printf '\nNoDisplay=true\n' >>~/.local/share/applications/"$item"
#   done
#
#   cp /usr/share/applications/cups.desktop ~/.local/share/applications/
#   sudo chmod 644 ~/.local/share/applications/cups.desktop
#   printf '\nNoDisplay=true\n' >>~/.local/share/applications/cups.desktop
# fi

# ## QT/GTK
# if confirm "Do you want to add QT/GTK environment variables?"; then
#   sudo tee -a /etc/environment >/dev/null <<'EOF'
# QT_QPA_PLATFORM=wayland
# QT_QPA_PLATFORMTHEME=qt5ct
# QT_WAYLAND_DISABLE_WINDOWDECORATION=1
# QT_AUTO_SCREEN_SCALE_FACTOR=1
# QT_STYLE_OVERRIDE=kvantum
# GTK_THEME=Arc-Dark
# EOF
#   clear
# fi

# ## Services
# info "enabling system services..."
#
# sudo systemctl enable --now sshd
# sudo systemctl enable --now docker.service
# sudo systemctl enable --now nginx.service
# sudo systemctl enable --now bluetooth.service
# sudo systemctl enable --now cups.service
# sudo usermod -aG docker wm
# clear

# ## HP soft-block wifi fix
# if confirm "Do you want to fix wifi soft-block on HP laptop?"; then
#   sudo tee /etc/systemd/system/hp-keycodes.service >/dev/null <<'EOF'
# [Unit]
# Description=HP setkeycodes fix
#
# [Service]
# Type=oneshot
# Restart=no
# RemainAfterExit=no
# ExecStart=/usr/bin/setkeycodes e057 240 e058 240
#
# [Install]
# WantedBy=rescue.target
# WantedBy=multi-user.target
# WantedBy=graphical.target
# EOF
#
#   sudo systemctl daemon-reload
#   sudo systemctl enable --now hp-keycodes.service
#
#   clear
# fi

## Other
# mkdir ~/Projects
# go telemetry off
# uv tool install nginx-language-server
# clear

# ## Default apps
# if confirm "Do you want to set default apps?"; then
#   # xdg-mime query default [file/extension]
#   # gio mime [file/extension]
#   gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty
#   sudo update-desktop-database
# fi

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
# brave://flags/#enable-webrtc-allow-input-volume-adjustment
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
