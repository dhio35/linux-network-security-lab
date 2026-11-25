#!/usr/bin/env bash

PROJECT="$HOME/projects/linux-network-security-lab"
REPORT="$PROJECT/evidence/lab-04-ssh-baseline.txt"

mkdir -p "$PROJECT/evidence"

{
    echo "=========================================="
    echo "DHIO35 | LAB 04 PHASE 01"
    echo "SSH SECURITY BASELINE AUDIT"
    date
    echo "=========================================="

    echo ""
    echo "===== 01. SYSTEM INFORMATION ====="
    hostnamectl
    uname -r

    echo ""
    echo "===== 02. SSH CLIENT ====="
    if command -v ssh >/dev/null 2>&1; then
        ssh -V 2>&1
    else
        echo "SSH client not installed."
    fi

    echo ""
    echo "===== 03. SSH SERVER PACKAGE ====="
    if dpkg-query -W -f='${Status} ${Version}\n' openssh-server 2>/dev/null; then
        :
    else
        echo "OpenSSH server package not installed."
    fi

    echo ""
    echo "===== 04. SSH DAEMON ====="
    if command -v sshd >/dev/null 2>&1; then
        sshd -V 2>&1
    else
        echo "sshd executable not found."
    fi

    echo ""
    echo "===== 05. SSH SERVICE STATUS ====="
    if systemctl is-active ssh >/dev/null 2>&1; then
        systemctl status ssh --no-pager
    else
        echo "SSH service is not active or not installed."
        systemctl is-enabled ssh 2>&1 || true
    fi

    echo ""
    echo "===== 06. PORT 22 LISTENING STATUS ====="
    if command -v ss >/dev/null 2>&1; then
        ss -tlnp | grep ':22 ' || echo "No SSH listener detected on port 22."
    fi

    echo ""
    echo "===== 07. FIREWALL STATUS ====="
    if command -v ufw >/dev/null 2>&1; then
        sudo ufw status verbose
    else
        echo "UFW is not installed."
    fi

    echo ""
    echo "===== 08. SSH CONFIGURATION FILE ====="
    if [ -f /etc/ssh/sshd_config ]; then
        ls -l /etc/ssh/sshd_config
        grep -nE '^(Port|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|PermitEmptyPasswords)' \
            /etc/ssh/sshd_config || true
    else
        echo "SSH server configuration not found."
    fi

    echo ""
    echo "===== 09. SSH DIRECTORY ====="
    if [ -d "$HOME/.ssh" ]; then
        ls -ld "$HOME/.ssh"
        find "$HOME/.ssh" -maxdepth 1 -type f \
            -printf '%f | %m | %u:%g\n'
    else
        echo "User SSH directory not found."
    fi

    echo ""
    echo "=========================================="
    echo "LAB 04 PHASE 01 COMPLETED"
    echo "=========================================="

} 2>&1 | tee "$REPORT"

echo ""
echo "Evidence saved: $REPORT"

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "Report copied to Windows clipboard."
fi
