#!/usr/bin/env bash

set -uo pipefail

ROOT="$HOME/projects/linux-network-security-lab"
REPORT="$ROOT/evidence/lab-05-ufw-installation.txt"

mkdir -p "$ROOT/evidence"

exec > >(tee "$REPORT") 2>&1

section() {
    echo
    echo "=================================================="
    echo "$1"
    echo "=================================================="
}

section "DHIO35 | LAB 05 PHASE 02"
echo "UFW INSTALLATION & FUNDAMENTALS"
date
echo "Hostname: $(hostname)"
echo "User: $(whoami)"

section "01. INSTALLATION"
sudo apt-get update
sudo apt-get install -y ufw

section "02. UFW VERSION"
ufw version

section "03. UFW STATUS"
sudo ufw status verbose

section "04. DEFAULT FIREWALL CONFIGURATION"
grep -E '^(IPV6|DEFAULT_INPUT_POLICY|DEFAULT_OUTPUT_POLICY|DEFAULT_FORWARD_POLICY|MANAGE_BUILTINS)=' \
    /etc/default/ufw || true

section "05. FIREWALL BACKEND"
if command -v iptables >/dev/null 2>&1; then
    iptables --version
else
    echo "iptables command unavailable."
fi

if command -v nft >/dev/null 2>&1; then
    nft --version
else
    echo "nft command unavailable."
fi

section "06. UFW SERVICE STATUS"
if command -v systemctl >/dev/null 2>&1; then
    systemctl is-active ufw 2>&1 || true
    systemctl is-enabled ufw 2>&1 || true
else
    echo "systemctl unavailable."
fi

section "07. CURRENT FIREWALL RULES"
sudo ufw show added

section "08. SECURITY VERIFICATION"
STATUS="$(sudo ufw status | head -n 1)"
echo "UFW status: $STATUS"

if [[ "$STATUS" == "Status: inactive" ]]; then
    echo "PASS: UFW installed and remains inactive."
else
    echo "WARNING: UFW is not inactive. Review before proceeding."
fi

echo
echo "No firewall activation or policy changes were performed."

echo
echo "REPORT SAVED: $REPORT"

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "REPORT COPIED TO WINDOWS CLIPBOARD."
fi

