#!/usr/bin/env bash
# ==============================================================================
# Linux Optimization Suite for ASUS Laptops
# Installer Script
#   sudo ./install.sh            install everything
#   sudo ./install.sh --no-zram  skip the zram swap setup
# ==============================================================================

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "[-] Error: This installation script must be run as root (e.g. sudo ./install.sh)" >&2
    exit 1
fi

WITH_ZRAM=1
[ "${1:-}" = "--no-zram" ] && WITH_ZRAM=0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[+] Installing binaries to /usr/local/bin/..."
for b in asus-fan-gui bat-limit-gui bat-limit asus-battery-apply auto-powerprofile; do
    install -m 755 "$SCRIPT_DIR/bin/$b" "/usr/local/bin/$b"
done

echo "[+] Saving default battery limit (80%) if none is set..."
[ -f /etc/asus-battery-limit.conf ] || printf 'LIMIT=80\n' > /etc/asus-battery-limit.conf

echo "[+] Installing polkit policy (password dialog for the GUI)..."
install -m 644 "$SCRIPT_DIR/polkit/io.github.boburhasanov.bat-limit.policy" /usr/share/polkit-1/actions/

echo "[+] Installing desktop applications..."
install -m 644 "$SCRIPT_DIR/desktop/asus-fan-control.desktop" /usr/share/applications/
install -m 644 "$SCRIPT_DIR/desktop/bat-limit.desktop" /usr/share/applications/
update-desktop-database /usr/share/applications/ 2>/dev/null || true

echo "[+] Installing systemd service..."
install -m 644 "$SCRIPT_DIR/systemd/asus-battery-charge-threshold.service" /etc/systemd/system/
systemctl daemon-reload
systemctl enable asus-battery-charge-threshold.service
systemctl start asus-battery-charge-threshold.service || true

echo "[+] Installing udev rules..."
install -m 644 "$SCRIPT_DIR/udev/60-ioscheduler.rules" /etc/udev/rules.d/
install -m 644 "$SCRIPT_DIR/udev/98-powerprofile-switch.rules" /etc/udev/rules.d/
install -m 644 "$SCRIPT_DIR/udev/99-asus-battery-charge-threshold.rules" /etc/udev/rules.d/
udevadm control --reload-rules
udevadm trigger --subsystem-match=block --action=change
udevadm trigger --subsystem-match=power_supply --action=change

if [ "$WITH_ZRAM" -eq 1 ]; then
    echo "[+] Setting up zram compressed swap..."
    if ! [ -e /usr/lib/systemd/system-generators/zram-generator ] && command -v apt-get >/dev/null; then
        apt-get install -y systemd-zram-generator
    fi
    if [ -e /usr/lib/systemd/system-generators/zram-generator ]; then
        install -m 644 "$SCRIPT_DIR/zram/zram-generator.conf" /etc/systemd/zram-generator.conf
        install -m 644 "$SCRIPT_DIR/sysctl/99-zram-tuning.conf" /etc/sysctl.d/
        systemctl daemon-reload
        systemctl restart systemd-zram-setup@zram0.service || true
        systemctl start dev-zram0.swap || true
        sysctl -q --load=/etc/sysctl.d/99-zram-tuning.conf
    else
        echo "    [!] systemd-zram-generator not available, skipping zram."
    fi
fi

echo ""
echo "[✓] Installation complete!"
echo "    Battery limit : $(cat /sys/class/power_supply/*/charge_control_end_threshold 2>/dev/null | head -n1)%"
echo "    Launch 'ASUS Cooling & Fan Control' and 'ASUS Battery Charge Limiter' from your application menu."
