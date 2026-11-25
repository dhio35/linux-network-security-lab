#!/usr/bin/env bash

set -uo pipefail

ROOT="$HOME/projects/linux-network-security-lab"
REPORT="$ROOT/evidence/lab-05-network-firewall-baseline.txt"

mkdir -p "$ROOT/evidence"

exec > >(tee "$REPORT") 2>&1

section() {
    echo
    echo "=================================================="
    echo "$1"
    echo "=================================================="
}

section "DHIO35 | LAB 05 PHASE 01"
echo "LINUX FIREWALL & NETWORK TRAFFIC CONTROL"
date
echo "Hostname: $(hostname)"
echo "User: $(whoami)"

section "01. OPERATING SYSTEM"
cat /etc/os-release
uname -a

section "02. NETWORK INTERFACES"
ip -brief address

section "03. IP ROUTING TABLE"
ip route

section "04. LISTENING PORTS"
ss -tuln

section "05. NETWORK CONNECTIONS"
ss -tun

section "06. FIREWALL SOFTWARE"

for cmd in ufw nft iptables; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd: INSTALLED"
        "$cmd" --version 2>/dev/null | head -n 2 || true
    else
        echo "$cmd: NOT INSTALLED"
    fi
done

section "07. UFW STATUS"

if command -v ufw >/dev/null 2>&1; then
    sudo ufw status verbose || true
else
    echo "UFW is not installed."
fi

section "08. IPTABLES RULES"

if command -v iptables >/dev/null 2>&1; then
    sudo iptables -S 2>&1 || true
else
    echo "iptables is not installed."
fi

section "09. NFTABLES RULESET"

if command -v nft >/dev/null 2>&1; then
    sudo nft list ruleset 2>&1 || true
else
    echo "nftables is not installed."
fi

section "10. DNS CONFIGURATION"
cat /etc/resolv.conf

section "11. BASELINE SUMMARY"
echo "OS: $(. /etc/os-release && echo "$PRETTY_NAME")"
echo "Kernel: $(uname -r)"
echo "Firewall baseline inspection completed."
echo "No firewall configuration was changed."

echo
echo "REPORT SAVED: $REPORT"

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "REPORT COPIED TO WINDOWS CLIPBOARD."
fi

