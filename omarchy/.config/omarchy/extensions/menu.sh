# Overwrite parts of the omarchy-menu with user-specific submenus.
# See $OMARCHY_PATH/bin/omarchy-menu for functions that can be overwritten.
#
# WARNING: Overwritten functions will obviously not be updated when Omarchy changes.
#
# Example of minimal system menu:

show_main_menu() {
  go_to_menu "$(menu "Go" "󰀻  Apps\n󱓞  Trigger\n  Setup\n󰉉  Install\n󰭌  Remove\n  Update\n  Keybindings\n  About\n  System")"
}

go_to_menu() {
  case "${1,,}" in
  *apps*) walker -p "Launch…" ;;
  *learn*) show_learn_menu ;;
  *trigger*) show_trigger_menu ;;
  *toggle*) show_toggle_menu ;;
  *hardware*) show_hardware_menu ;;
  *share*) show_share_menu ;;
  *reminder-set*) show_custom_reminder_input ;;
  *reminder*) show_reminder_menu ;;
  *background*) show_background_menu ;;
  *capture*) show_capture_menu ;;
  *style*) show_style_menu ;;
  *theme*) show_theme_menu ;;
  *screenrecord*) show_screenrecord_menu ;;
  *setup*) show_setup_menu ;;
  *power*) show_setup_power_menu ;;
  *install*) show_install_menu ;;
  *remove*) show_remove_menu ;;
  *update*) show_update_menu ;;
  *about*) show_about ;;
  *system*) show_system_menu ;;
  *keybindings*) omarchy-menu-keybindings ;;
  esac
}

show_trigger_menu() {
  case $(menu "Trigger" "󰔛  Reminder\n  Capture\n  Share\n󰔎  Toggle\n  Hardware") in
  *Reminder*) show_reminder_menu ;;
  *Capture*) show_capture_menu ;;
  *Share*) show_share_menu ;;
  *Toggle*) show_toggle_menu ;;
  *Hardware*) show_hardware_menu ;;
  *) show_main_menu ;;
  esac
}

show_toggle_menu() {
  local options="󱄄  Screensaver\n󰔎  Nightlight\n󱫖  Idle Lock\n󰂛  Notifications\n󰍜  Top Bar\n  Direct Boot\n󰟵  Passwordless Sudo"

  case $(menu "Toggle" "$options") in
  *Screensaver*) omarchy-toggle-screensaver ;;
  *Nightlight*) omarchy-toggle-nightlight ;;
  *Idle*) omarchy-toggle-idle ;;
  *Notifications*) omarchy-toggle-notification-silencing ;;
  *Bar*) omarchy-toggle-waybar ;;
  *"Direct Boot"*) present_terminal omarchy-config-direct-boot ;;
  *"Passwordless Sudo"*) present_terminal omarchy-sudo-passwordless ;;
  *) back_to show_trigger_menu ;;
  esac
}

show_setup_menu() {
  local options="  Audio\n  Wifi\n󰂯  Bluetooth\n󱐋  Power Profile\n  System Sleep\n󰍹  Monitors"

  case $(menu "Setup" "$options") in
  *Audio*) omarchy-launch-audio ;;
  *Wifi*) omarchy-launch-wifi ;;
  *Bluetooth*) omarchy-launch-bluetooth ;;
  *Power*) show_setup_power_menu ;;
  *System*) show_setup_system_menu ;;
  *Monitors*) open_in_editor ~/.config/hypr/monitors.conf ;;
  *) show_main_menu ;;
  esac
}

show_install_menu() {
  case $(menu "Install" "󰣇  Package\n󰣇  AUR\n  Web App\n  TUI") in
  *Package*) terminal omarchy-pkg-install ;;
  *AUR*) terminal omarchy-pkg-aur-install ;;
  *Web*) present_terminal omarchy-webapp-install ;;
  *TUI*) present_terminal omarchy-tui-install ;;
  *) show_main_menu ;;
  esac
}

show_remove_menu() {
  case $(menu "Remove" "󰣇  Package\n  Web App\n  TUI") in
  *Package*) terminal omarchy-pkg-remove ;;
  *Web*) present_terminal omarchy-webapp-remove ;;
  *TUI*) present_terminal omarchy-tui-remove ;;
  *) show_main_menu ;;
  esac
}

show_update_menu() {
  case $(menu "Update" "  Omarchy\n󰇅  Hardware\n  Firmware") in
  *Omarchy*) present_terminal omarchy-update ;;
  *Hardware*) show_update_hardware_menu ;;
  *Firmware*) present_terminal omarchy-update-firmware ;;
  *) show_main_menu ;;
  esac
}

show_system_menu() {
  local options="  Lock"
  ! omarchy-toggle-enabled suspend-off && options="$options\n󰒲  Suspend"
  options="$options\n󰍃  Logout\n󰜉  Restart\n󰐥  Shutdown"

  case $(menu "System" "$options") in
  *Lock*) omarchy-system-lock ;;
  *Suspend*) systemctl suspend ;;
  *Logout*) omarchy-system-logout ;;
  *Restart*) omarchy-system-reboot ;;
  *Shutdown*) omarchy-system-shutdown ;;
  *) back_to show_main_menu ;;
  esac
}

# Example of overriding just the about menu action: (Using zsh instead of bash (default))
#
# show_about() {
#   exec omarchy-launch-or-focus-tui "zsh -c 'fastfetch; read -k 1'"
# }
