#!/usr/bin/env bash

set -euo pipefail

ROOT="$HOME/projects/linux-network-security-lab"
REPORT="$ROOT/evidence/lab-05-firewall-rules.txt"

mkdir -p "$ROOT/evidence"

exec > >(tee "$REPORT") 2>&1

section() {
    echo
    echo "=================================================="
    echo "$1"
    echo "=================================================="
}

section "DHIO35 | LAB 05 PHASE 03"
echo "FIREWALL RULES CONFIGURATION"
date

section "01. INITIAL FIREWALL STATUS"
sudo ufw status verbose

section "02. CONFIGURE DEFAULT POLICIES"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny routed

section "03. CONFIGURE SSH ACCESS"
sudo ufw allow 22/tcp comment 'SSH management'

section "04. AVAILABLE APPLICATION PROFILES"
sudo ufw app list

section "05. CONFIGURED FIREWALL RULES"
sudo ufw status numbered

section "06. DEFAULT POLICY VERIFICATION"
grep -E '^(IPV6|DEFAULT_INPUT_POLICY|DEFAULT_OUTPUT_POLICY|DEFAULT_FORWARD_POLICY)=' \
    /etc/default/ufw || true

section "07. FIREWALL STATUS VERIFICATION"
sudo ufw status verbose

if [[ "$(sudo ufw status | head -n 1)" == "Status: inactive" ]]; then
    echo "PASS: Rules configured while firewall remains inactive."
else
    echo "WARNING: Firewall is active. Review current state."
fi

echo
echo "IMPORTANT: Firewall has NOT been enabled by this script."
echo "REPORT SAVED: $REPORT"

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "REPORT COPIED TO WINDOWS CLIPBOARD."
fi
