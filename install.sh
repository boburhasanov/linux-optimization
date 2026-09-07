#!/usr/bin/env bash
# ==============================================================================
# Linux Optimization Suite for ASUS Laptops
# Installer Script
# ==============================================================================

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "[-] Error: This installation script must be run as root (e.g. sudo ./install.sh)" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[+] Installing binaries to /usr/local/bin/..."
install -m 755 "$SCRIPT_DIR/bin/asus-fan-gui" /usr/local/bin/asus-fan-gui
install -m 755 "$SCRIPT_DIR/bin/bat-limit-gui" /usr/local/bin/bat-limit-gui
install -m 755 "$SCRIPT_DIR/bin/bat-limit" /usr/local/bin/bat-limit
install -m 755 "$SCRIPT_DIR/bin/auto-powerprofile" /usr/local/bin/auto-powerprofile

echo "[+] Installing desktop applications..."
install -m 644 "$SCRIPT_DIR/desktop/asus-fan-control.desktop" /usr/share/applications/
install -m 644 "$SCRIPT_DIR/desktop/bat-limit.desktop" /usr/share/applications/
update-desktop-database /usr/share/applications/ 2>/dev/null || true

echo "[+] Installing systemd services..."
install -m 644 "$SCRIPT_DIR/systemd/asus-battery-charge-threshold.service" /etc/systemd/system/
systemctl daemon-reload
systemctl enable asus-battery-charge-threshold.service

echo "[+] Installing udev rules..."
install -m 644 "$SCRIPT_DIR/udev/60-ioscheduler.rules" /etc/udev/rules.d/
install -m 644 "$SCRIPT_DIR/udev/98-powerprofile-switch.rules" /etc/udev/rules.d/
install -m 644 "$SCRIPT_DIR/udev/99-asus-battery-charge-threshold.rules" /etc/udev/rules.d/
udevadm control --reload-rules
udevadm trigger

echo ""
echo "[✓] Installation complete!"
echo "You can now launch 'ASUS Thermal & Cooling Center' and 'Battery Health Limiter' from your application menu."
