# 🚀 Linux Optimization Suite for ASUS Laptops

[![OS - Linux](https://img.shields.io/badge/OS-Linux%20%28Mint%20%2F%20Ubuntu%20%2F%20Debian%29-E95420?logo=linux&logoColor=white)](https://kernel.org)
[![Platform - ASUS](https://img.shields.io/badge/Platform-ASUS%20Laptops-00539B?logo=asus&logoColor=white)](https://www.asus.com)
[![Python - 3.10+](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python&logoColor=white)](https://www.python.org)
[![UI - GTK3 Native](https://img.shields.io/badge/GUI-GTK3%20Native-4A90E2?logo=gnome&logoColor=white)](https://www.gtk.org)
[![License - MIT](https://img.shields.io/badge/License-MIT-22c55e.svg)](LICENSE)
[![Zero Background Daemons](https://img.shields.io/badge/Resource%20Impact-0%25%20Idle%20CPU%20%7C%200%20MB%20RAM-emerald)](https://github.com/bobuhasanov/linux-optimization)

A lightweight, production-grade optimization suite and graphical management center designed specifically for ASUS laptops running Linux (Linux Mint, Ubuntu, Debian, Cinnamon, GNOME). 

Engineered with a strict **Zero-Resource Background Policy**: no heavy polling daemons, no CPU wakeups, and no battery-draining loops. All hardware interactions are handled natively via kernel `sysfs`, event-driven `udev` triggers, and responsive GTK3 interfaces.

---

## 📸 Screenshots

| ❄️ ASUS Thermal & Cooling Center | 🔋 Battery Health & Charge Limiter |
| :---: | :---: |
| ![ASUS Thermal & Cooling Center](assets/fan_control.png) | ![Battery Health Limiter](assets/battery_limiter.png) |

---

## ✨ Features

### 1. ❄️ ASUS Thermal & Cooling Center (`asus-fan-gui`)
- **Real-Time Telemetry:** Live CPU package temperature and cooling fan RPM readings.
- **Hardware Fan Profiles:** Instant 1-click switching between ASUS firmware fan curves:
  - 🍃 **Quiet (Silent):** Minimal acoustic noise, optimized fan profile for office and reading.
  - ⚖️ **Balanced (Standard):** Dynamic curve responding to workload demands.
  - ⚡ **Performance (Overboost):** Aggressive thermal dissipation for compiling, gaming, and heavy computing.
- **Visual Status Badges:** Dynamic color-coded indicators for hardware health and profile status.

### 2. 🔋 Battery Health & Charge Threshold (`bat-limit-gui` & `bat-limit`)
- **Hardware Protection:** Configures ASUS hardware charge threshold (`charge_control_end_threshold`) to stop charging at **60%**, **80%**, or **100%**.
- **Prolonged Lifespan:** Protects lithium-ion battery chemistry against degradation when plugged in for long periods.
- **Dual Interface:** Accessible via an intuitive desktop GUI or a fast CLI utility (`bat-limit`).
- **Persistence Across Reboots & Sleep:** Backed by automated systemd units and udev rules so your selected threshold survives reboot, suspend, and hibernate states.

### 3. ⚡ Zero-Resource Event-Driven Power Switcher
- Automatically shifts desktop power profiles between **Performance** and **Balanced** when the AC adapter is plugged in or unplugged.
- Powered entirely by kernel **udev events** (`98-powerprofile-switch.rules`) — absolutely zero background daemons consuming CPU cycles.

### 4. 🚀 Storage I/O Responsiveness
- Configures latency-optimized I/O schedulers (e.g. `bfq` / `mq-deadline`) for NVMe and SSD drives.
- Eliminates desktop micro-stutter during background file operations and heavy package upgrades.

---

## 📂 Repository Structure

```text
linux-optimization/
├── README.md               # Documentation and usage guide
├── LICENSE                 # MIT License
├── install.sh              # Automated one-step system installer
├── uninstall.sh            # Complete uninstallation script
├── assets/                 # UI screenshots and documentation images
│   ├── fan_control.png
│   └── battery_limiter.png
├── bin/                    # Core executable utilities
│   ├── asus-fan-gui        # Thermal monitoring and profile switcher (GTK3)
│   ├── bat-limit-gui       # Battery threshold configuration GUI (GTK3)
│   ├── bat-limit           # Battery threshold CLI tool (Bash)
│   └── auto-powerprofile   # Event-driven AC/Battery switcher
├── desktop/                # System application menu integrations (.desktop)
│   ├── asus-fan-control.desktop
│   └── bat-limit.desktop
├── systemd/                # Persistence unit files
│   └── asus-battery-charge-threshold.service
└── udev/                   # Kernel hardware event rules
    ├── 60-ioscheduler.rules
    ├── 98-powerprofile-switch.rules
    └── 99-asus-battery-charge-threshold.rules
```

---

## 📥 Installation

Clone the repository and run the automated installer:

```bash
# 1. Clone repository
git clone git@github.com:bobuhasanov/linux-optimization.git
cd linux-optimization

# 2. Run installer with sudo
sudo ./install.sh
```

The installer will automatically:
1. Copy executable binaries to `/usr/local/bin/`
2. Install `.desktop` entries into your application menu
3. Enable the persistent systemd battery service
4. Reload kernel `udev` hardware rules

---

## 🖥️ Usage

### Graphical Interface (GUI)
Simply search your application menu for:
- **ASUS Thermal & Cooling Center**
- **Battery Health Limiter**

Or launch them directly from your terminal:
```bash
asus-fan-gui &
bat-limit-gui &
```

### Command Line (CLI)
Query or change the battery charge limit directly:
```bash
# Check current battery limit
bat-limit

# Set battery charge limit to 80%
sudo bat-limit 80
```

---

## 🧹 Uninstallation

To completely remove all installed scripts, systemd units, and desktop shortcuts:

```bash
sudo ./uninstall.sh
```

---

## 👤 Author

**Bobur Hasanov**
- GitHub: [@bobuhasanov](https://github.com/bobuhasanov)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
