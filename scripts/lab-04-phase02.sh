#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT="$HOME/projects/linux-network-security-lab"
REPORT="$PROJECT/evidence/lab-04-ssh-installation.txt"

mkdir -p "$PROJECT/evidence"

echo "===== DHIO35 LAB 04 PHASE 02 ====="
echo "Installing OpenSSH Server..."

# 1. Update package repository
sudo apt-get update

# 2. Install OpenSSH Server
sudo apt-get install -y openssh-server

# 3. Enable and start SSH service
sudo systemctl enable --now ssh

# 4. Generate audit report
{
    echo "=========================================="
    echo "DHIO35 | LAB 04 PHASE 02"
    echo "OPENSSH SERVER INSTALLATION"
    date
    echo "=========================================="

    echo ""
    echo "===== 01. PACKAGE STATUS ====="
    dpkg-query -W -f='${Status} ${Version}\n' openssh-server

    echo ""
    echo "===== 02. SSH DAEMON VERSION ====="
    sudo /usr/sbin/sshd -V 2>&1 || true

    echo ""
    echo "===== 03. SSH SERVICE STATUS ====="
    systemctl is-active ssh
    systemctl is-enabled ssh

    echo ""
    echo "===== 04. PORT 22 STATUS ====="
    sudo ss -tlnp | grep -E 'LISTEN.*:22([[:space:]]|$)' || true

    echo ""
    echo "===== 05. SSH HOST KEYS ====="
    sudo ls -lh /etc/ssh/ssh_host_*_key.pub

    echo ""
    echo "===== 06. SSH CONFIGURATION ====="
    sudo ls -lh /etc/ssh/sshd_config

    echo ""
    echo "===== 07. SSH CONFIG VALIDATION ====="
    sudo sshd -t
    echo "Configuration syntax: VALID"

    echo ""
    echo "===== 08. SSH LISTENING CONFIGURATION ====="
    sudo sshd -T | grep -E '^(port|listenaddress|permitrootlogin|passwordauthentication|pubkeyauthentication) '

    echo ""
    echo "=========================================="
    echo "LAB 04 PHASE 02 COMPLETED"
    echo "=========================================="

} 2>&1 | tee "$REPORT"

echo ""
echo "Evidence saved: $REPORT"

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "Report copied to Windows clipboard."
fi
