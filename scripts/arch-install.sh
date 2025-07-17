#!/usr/bin/env bash

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

check_uefi() {
    if [[ ! -d "/sys/firmware/efi/efivars" ]]; then
        error "This script requires UEFI boot mode. Legacy BIOS is not supported."
        exit 1
    fi
}

check_internet() {
    if ! ping -c 1 archlinux.org &>/dev/null; then
        error "No internet connection. Please connect to the internet first."
        return 1
    fi
    info "Internet connection confirmed"
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

validate_partition() {
    local partition="$1"

    if [[ ! -b "/dev/$partition" ]]; then
        error "Partition /dev/$partition does not exist!"
        return 1
    fi
    return 0
}

get_partition() {
    local prompt="$1"
    local partition

    while true; do
        lsblk
        echo
        read -r -p "$prompt: " partition
        if validate_partition "$partition"; then
            echo "$partition"
            return 0
        fi
        echo "Please enter a valid partition."
    done
}

## Root check
if [ "$(id -u)" != 0 ]; then
    error "This script MUST be run as root user!"
    exit 1
fi

## Initial setup
check_uefi
loadkeys pl
clear

## Network
while confirm "Do you want to configure WiFi with iwd?"; do
    info "Available network interfaces:"
    ip link show
    echo
    info "iwd commands:"
    echo "  device list"
    echo "  station <INTERFACE> scan"
    echo "  station <INTERFACE> get-networks"
    echo "  station <INTERFACE> connect <NETWORK_NAME>"
    echo "  exit"
    echo
    printf "Press any key to launch iwd..."
    read -n 1 -s -r

    iwctl

    if check_internet; then
        clear
        break
    else
        error "No internet connection. Please try again."
    fi
done

## System clock
info "Updating system clock..."
timedatectl set-ntp true && sleep 2
clear

## Partitioning
while confirm "Do you want to partition the disk with cfdisk?"; do
    info "Available storage devices:"
    lsblk
    echo
    read -r -p "Enter your drive (e.g., sda, nvme0n1): " DRIVE_TYPE

    if [[ ! -b "/dev/$DRIVE_TYPE" ]]; then
        clear
        error "Drive /dev/$DRIVE_TYPE does not exist!"
        continue
    fi

    clear
    info "Partition scheme:"
    echo "1. EFI System Partition (/boot) - 512M - Type: EFI System"
    echo "2. Linux Swap - 8G (or RAM/2 if >16GB RAM) - Type: Linux swap"
    echo "3. Linux Root (/) - Remaining space - Type: Linux filesystem"
    echo
    warning "This will modify /dev/$DRIVE_TYPE. Make sure you have backup!"
    echo
    printf "Press any key to launch cfdisk..."
    read -n 1 -s -r

    cfdisk "/dev/$DRIVE_TYPE"

    clear
done

## Filesystem
while confirm "Do you want to format partitions and set up filesystems?"; do
    PART_ROOT=$(get_partition "Enter root partition (e.g., sda3, nvme0n1p3)")
    PART_SWAP=$(get_partition "Enter swap partition (e.g., sda2, nvme0n1p2)")
    PART_BOOT=$(get_partition "Enter boot partition (e.g., sda1, nvme0n1p1)")

    echo
    warning "This will format the following partitions:"
    echo "  Root: /dev/$PART_ROOT (ext4)"
    echo "  Swap: /dev/$PART_SWAP (swap)"
    echo "  Boot: /dev/$PART_BOOT (FAT32)"
    echo
    if ! confirm "Continue with formatting? This will destroy all data on these partitions!"; then
        error "Filesystem setup cancelled."
        exit 1
    fi

    info "Formatting root partition..."
    mkfs.ext4 /dev/"$PART_ROOT"
    mount /dev/"$PART_ROOT" /mnt/
    clear

    info "Setting up swap..."
    mkswap /dev/"$PART_SWAP"
    swapon /dev/"$PART_SWAP"
    clear

    info "Formatting boot partition..."
    mkfs.fat -F 32 /dev/"$PART_BOOT"
    mkdir -p /mnt/boot
    mount /dev/"$PART_BOOT" /mnt/boot
    clear
done

## Pacstrap
while confirm "Do you want to run pacstrap?"; do
    info "Updating pacman mirrors..."
    reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    clear

    info "Installing base packages..."
    pacstrap /mnt base base-devel git linux linux-firmware linux-headers networkmanager neovim man-db man-pages texinfo dosfstools e2fsprogs grub efibootmgr
    clear

    info "Installing drivers..."
    pacstrap /mnt amd-ucode mesa vulkan-radeon
    clear
done

## Fstab
if confirm "Do you want to generate fstab?"; then
    genfstab -U /mnt >>/mnt/etc/fstab
    clear
fi

## Chroot
while confirm "Do you want to chroot and configure the system?"; do
    localtime="Warsaw"
    locale1="en_US.UTF-8 UTF-8"
    locale2="pl_PL.UTF-8 UTF-8"
    lang="en_US.UTF-8"
    hostname="Arch"
    user="wm"
    keymap="pl"

    # Timezone setup
    info "Setting up timezone..."
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/"$localtime" /etc/localtime
    arch-chroot /mnt hwclock --systohc

    # Locale setup
    info "Configuring locales..."
    arch-chroot /mnt bash -c "echo '$locale1' >> /etc/locale.gen"
    arch-chroot /mnt bash -c "echo '$locale2' >> /etc/locale.gen"
    arch-chroot /mnt locale-gen
    arch-chroot /mnt bash -c "echo 'LANG=$lang' > /etc/locale.conf"

    # Keymap setup
    info "Setting up keymap..."
    arch-chroot /mnt bash -c "echo 'KEYMAP=$keymap' > /etc/vconsole.conf"

    # Hostname setup
    info "Configuring hostname..."
    arch-chroot /mnt bash -c "echo '$hostname' > /etc/hostname"
    arch-chroot /mnt bash -c "echo '127.0.0.1    localhost' >> /etc/hosts"
    arch-chroot /mnt bash -c "echo '::1          localhost' >> /etc/hosts"
    arch-chroot /mnt bash -c "echo '127.0.1.1    ${hostname}.localdomain    ${hostname}' >> /etc/hosts"

    # User setup
    info "Setting up users..."
    info "Setting root password"
    arch-chroot /mnt passwd root

    info "Creating user: $user"
    arch-chroot /mnt useradd -m -G wheel video -s /bin/bash "$user"

    info "Setting password for user: $user"
    arch-chroot /mnt passwd "$user"

    # Sudo setup
    info "Configuring sudo access..."
    arch-chroot /mnt bash -c "echo '%wheel ALL=(ALL:ALL) ALL' >> /etc/sudoers"

    # Network setup
    info "Enabling network services..."
    arch-chroot /mnt systemctl enable NetworkManager

    # Bootloader setup
    info "Installing GRUB bootloader..."
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

    clear
done

## Post Install
umount -R /mnt
swapoff /dev/"$PART_SWAP"

info "Installation completed successfully!"
info "The system will reboot in 5 seconds"
info "Press Ctrl+C to cancel reboot and stay in live environment"

for i in {5..1}; do
    echo -ne "\rRebooting in $i seconds..."
    sleep 1
done

reboot
