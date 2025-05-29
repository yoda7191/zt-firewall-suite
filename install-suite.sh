#!/bin/bash

set -e

ROOT_DIR="/opt/zt-firewall-suite"
INSTALL_LOG="/var/log/zt-suite-install.log"

echo "[INFO] Installing zt-firewall-suite..." | tee -a "$INSTALL_LOG"

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "[ERROR] Please run as root"
        exit 1
    fi
}

detect_os() {
    case "$(uname -s)" in
        Linux*)     OS=Linux ;;
        Darwin*)    OS=macOS ;;
        *)          OS=Unknown ;;
    esac
}

setup_dirs() {
    mkdir -p "$ROOT_DIR"
    cp -r modules/* "$ROOT_DIR/"
}

setup_services() {
    if [ "$OS" == "Linux" ]; then
        cp "$ROOT_DIR/firewall/services/nftables.service" /etc/systemd/system/
        systemctl daemon-reexec
        systemctl enable nftables.service
        systemctl start nftables.service
    elif [ "$OS" == "macOS" ]; then
        cp "$ROOT_DIR/firewall/services/org.zero.net.firewall.plist" "$HOME/Library/LaunchAgents/"
        launchctl load "$HOME/Library/LaunchAgents/org.zero.net.firewall.plist"
        launchctl start org.zero.net.firewall
    fi
}

finalize_installation() {
    ln -sf "$ROOT_DIR/firewall/bin/fwctl" /usr/local/bin/fwctl
    ln -sf "$ROOT_DIR/cli/suitectl" /usr/local/bin/suitectl

    echo "[INFO] Installation complete!"
    echo ""
    echo "✅ You can now run:"
    echo "   sudo suitectl firewall zerotier-swarm"
    echo "   sudo suitectl swarm"
    echo "   sudo suitectl vnc"
    echo ""
}

# Run installation steps
check_root
detect_os
setup_dirs
setup_services
finalize_installation