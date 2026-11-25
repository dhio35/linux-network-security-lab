#!/usr/bin/env bash

set -uo pipefail

ROOT="$HOME/projects/linux-network-security-lab"
REPORT="$ROOT/evidence/lab-05-firewall-activation-audit.txt"

mkdir -p "$ROOT/evidence"
exec > >(tee "$REPORT") 2>&1

section() {
    echo
    echo "=================================================="
    echo "$1"
    echo "=================================================="
}

section "DHIO35 | LAB 05 PHASE 05"
echo "FIREWALL ACTIVATION & ACCESS CONTROL TESTING"
date

section "01. PRE-ACTIVATION RULES"
sudo ufw show added
sudo ufw status verbose

section "02. ACTIVATE UFW"
if ! sudo ufw --force enable; then
    echo "FAIL: UFW activation command failed."
    exit 1
fi

section "03. ACTIVE FIREWALL RULES"
sudo ufw status numbered
sudo ufw status verbose

section "04. SSH SERVICE CHECK"
if systemctl is-active --quiet ssh; then
    echo "PASS: SSH service is active."
else
    echo "FAIL: SSH service is not active."
fi

section "05. SSH PORT CHECK"
if timeout 5 bash -c '</dev/tcp/127.0.0.1/22' 2>/dev/null; then
    echo "PASS: Local TCP port 22 is reachable."
else
    echo "FAIL: Local TCP port 22 is unreachable."
fi

section "06. SSH KEY AUTHENTICATION"
if ssh -o BatchMode=yes \
       -o StrictHostKeyChecking=yes \
       -o ConnectTimeout=5 \
       dhio35@127.0.0.1 \
       'echo SSH_KEY_AUTHENTICATION_SUCCESS'; then
    echo "PASS: SSH key authentication succeeded."
else
    echo "FAIL: SSH authentication failed."
    echo "ROLLBACK: Disabling UFW to restore previous firewall state."
    sudo ufw disable
    echo "Firewall rollback executed."
    exit 1
fi

section "07. OUTBOUND DNS TEST"
if getent hosts archive.ubuntu.com; then
    echo "PASS: DNS resolution succeeded."
else
    echo "WARNING: DNS resolution failed."
fi

section "08. OUTBOUND HTTPS CONNECTIVITY"
if timeout 5 bash -c ':</dev/tcp/archive.ubuntu.com/443' 2>/dev/null; then
    echo "PASS: Outbound TCP 443 is reachable."
else
    echo "WARNING: Outbound TCP 443 test failed."
fi

section "09. FINAL FIREWALL STATUS"
sudo ufw status verbose

if [[ "$(sudo ufw status | head -n 1)" == "Status: active" ]]; then
    echo "PASS: UFW is active."
else
    echo "FAIL: UFW is not active."
fi

echo
echo "REPORT SAVED: $REPORT"

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "REPORT COPIED TO WINDOWS CLIPBOARD."
fi
