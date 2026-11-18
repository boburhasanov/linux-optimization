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

echo "[+] Disabling and removing systemd service..."
systemctl disable asus-battery-charge-threshold.service 2>/dev/null || true
rm -f /etc/systemd/system/asus-battery-charge-threshold.service

echo "[+] Removing udev rules..."
rm -f /etc/udev/rules.d/60-ioscheduler.rules
rm -f /etc/udev/rules.d/98-powerprofile-switch.rules
rm -f /etc/udev/rules.d/99-asus-battery-charge-threshold.rules
udevadm control --reload-rules

echo "[+] Removing zram configuration..."
rm -f /etc/systemd/zram-generator.conf /etc/sysctl.d/99-zram-tuning.conf
systemctl daemon-reload

echo "[+] Removing desktop entries and polkit policy..."
rm -f /usr/share/applications/asus-fan-control.desktop
rm -f /usr/share/applications/bat-limit.desktop
rm -f /usr/share/polkit-1/actions/io.github.boburhasanov.bat-limit.policy
update-desktop-database /usr/share/applications/ 2>/dev/null || true

echo "[+] Restoring full 100% charging..."
for t in /sys/class/power_supply/*/charge_control_end_threshold; do
    if [ -w "$t" ]; then echo 100 > "$t"; fi
done
rm -f /etc/asus-battery-limit.conf

echo "[+] Removing binaries..."
for b in asus-fan-gui bat-limit-gui bat-limit asus-battery-apply auto-powerprofile; do
    rm -f "/usr/local/bin/$b"
done

echo "[✓] Uninstallation complete. Reboot to drop zram and restore default sysctl values."
