#!/bin/bash

set -e

ROOT_DIR="/opt/zt-firewall"
RULESET="zerotier-swarm"
INSTALL_LOG="/var/log/zt-firewall-install.log"

echo "[INFO] Starting ZeroTier Firewall Installer..." | tee -a "$INSTALL_LOG"

detect_os() {
    case "$(uname -s)" in
        Linux*)     OS=Linux ;;
        Darwin*)    OS=macOS ;;
        *)          OS="Unknown" ;;
    esac
    echo "[INFO] Detected OS: $OS" | tee -a "$INSTALL_LOG"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "[ERROR] Please run as root" | tee -a "$INSTALL_LOG"
        exit 1
    fi
}

create_dirs() {
    mkdir -p "$ROOT_DIR"/{bin,lib,rules,services,config}
}

install_dependencies() {
    echo "[INFO] Installing dependencies..." | tee -a "$INSTALL_LOG"
    if command -v apt-get > /dev/null; then
        apt-get update && apt-get install -y curl jq nftables
    elif command -v dnf > /dev/null; then
        dnf install -y curl jq nftables
    elif [ "$OS" == "macOS" ]; then
        if ! command -v brew > /dev/null; then
            echo "[INFO] Installing Homebrew..." | tee -a "$INSTALL_LOG"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh )"
        fi
        brew install jq
    fi
}

setup_zerotier_auth() {
    if [ -f "/var/lib/zerotier-one/authtoken.secret" ]; then
        cp /var/lib/zerotier-one/authtoken.secret /root/.zerotier-one-authtoken
        chmod 600 /root/.zerotier-one-authtoken
    else
        echo "[WARNING] ZeroTier authtoken not found. Some features may be limited." | tee -a "$INSTALL_LOG"
    fi
}

download_fwctl() {
    echo "[INFO] Downloading fwctl tool..." | tee -a "$INSTALL_LOG"
    cat << 'EOF' > "$ROOT_DIR/bin/fwctl"
$(cat bin/fwctl)
EOF
    chmod +x "$ROOT_DIR/bin/fwctl"
    ln -sf "$ROOT_DIR/bin/fwctl" /usr/local/bin/fwctl
}

setup_rule_sets() {
    echo "[INFO] Setting up rule sets..." | tee -a "$INSTALL_LOG"
    cp rules/*.nft "$ROOT_DIR/rules/"
    cp rules/*.pf "$ROOT_DIR/rules/"
}

setup_services() {
    echo "[INFO] Configuring boot service..." | tee -a "$INSTALL_LOG"

    if [ "$OS" == "Linux" ]; then
        cp services/nftables.service /etc/systemd/system/
        systemctl daemon-reexec
        systemctl enable zt-firewall.service
        systemctl start zt-firewall.service
    elif [ "$OS" == "macOS" ]; then
        cp services/org.zero.net.firewall.plist "$HOME/Library/LaunchAgents/"
        launchctl load "$HOME/Library/LaunchAgents/org.zero.net.firewall.plist"
        launchctl start org.zero.net.firewall
    fi
}

finalize_installation() {
    echo "[INFO] Installation complete!" | tee -a "$INSTALL_LOG"
    echo ""
    echo "✅ You can now manage your firewall using:"
    echo "   sudo fwctl set-rule <rule-name>"
    echo "   sudo fwctl list-rules"
    echo "   sudo fwctl status"
    echo ""
    echo "Boot integration is configured."
    echo "Rule set '$RULESET' applied."
    echo ""
}

# Run installation steps
check_root
detect_os
create_dirs
install_dependencies
setup_zerotier_auth
download_fwctl
setup_rule_sets
setup_services
finalize_installation