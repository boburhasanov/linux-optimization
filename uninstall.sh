#!/usr/bin/env bash
# ==============================================================================
# Linux Optimization Suite for ASUS Laptops
# Uninstaller Script
# ==============================================================================

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "[-] Error: This script must be run as root (e.g. sudo ./uninstall.sh)" >&2
    exit 1
fi

echo "[+] Disabling and removing systemd services..."
systemctl disable asus-battery-charge-threshold.service 2>/dev/null || true
rm -f /etc/systemd/system/asus-battery-charge-threshold.service
systemctl daemon-reload

echo "[+] Removing udev rules..."
rm -f /etc/udev/rules.d/60-ioscheduler.rules
rm -f /etc/udev/rules.d/98-powerprofile-switch.rules
rm -f /etc/udev/rules.d/99-asus-battery-charge-threshold.rules
udevadm control --reload-rules

echo "[+] Removing desktop entries..."
rm -f /usr/share/applications/asus-fan-control.desktop
rm -f /usr/share/applications/bat-limit.desktop
update-desktop-database /usr/share/applications/ 2>/dev/null || true

echo "[+] Removing binaries..."
rm -f /usr/local/bin/asus-fan-gui
rm -f /usr/local/bin/bat-limit-gui
rm -f /usr/local/bin/bat-limit
rm -f /usr/local/bin/auto-powerprofile

echo "[✓] Uninstallation complete."
