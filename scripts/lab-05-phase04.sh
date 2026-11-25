#!/usr/bin/env bash

set -uo pipefail

ROOT="$HOME/projects/linux-network-security-lab"
REPORT="$ROOT/evidence/lab-05-pre-activation-security-test.txt"

mkdir -p "$ROOT/evidence"
exec > >(tee "$REPORT") 2>&1

section() {
    echo
    echo "=================================================="
    echo "$1"
    echo "=================================================="
}

section "DHIO35 | LAB 05 PHASE 04"
echo "FIREWALL PRE-ACTIVATION SECURITY TEST"
date

section "01. UFW CONFIGURED RULES"
sudo ufw show added

section "02. UFW DEFAULT POLICIES"
sudo ufw status verbose

section "03. SSH SERVICE STATUS"
systemctl is-active ssh || true

section "04. SSH CONFIGURATION VALIDATION"
sudo sshd -t
if [[ $? -eq 0 ]]; then
    echo "PASS: SSH configuration syntax is valid."
else
    echo "FAIL: SSH configuration syntax is invalid."
fi

section "05. SSH LISTENING PORT"
ss -tlnp | grep -E '(:22[[:space:]]|:22$)' || true

section "06. LOCAL SSH PORT CONNECTIVITY"
if timeout 5 bash -c '</dev/tcp/127.0.0.1/22' 2>/dev/null; then
    echo "PASS: TCP port 22 is reachable locally."
else
    echo "FAIL: TCP port 22 is not reachable locally."
fi

section "07. SSH KEY AUTHENTICATION TEST"
if ssh -o BatchMode=yes -o ConnectTimeout=5 \
    dhio35@127.0.0.1 'echo SSH_KEY_AUTHENTICATION_SUCCESS' 2>&1; then
    echo "PASS: SSH key authentication succeeded."
else
    echo "WARNING: SSH key authentication test failed."
    echo "Check SSH agent and authorized_keys before firewall activation."
fi

section "08. FIREWALL ACTIVATION STATUS"
sudo ufw status verbose

if [[ "$(sudo ufw status | head -n 1)" == "Status: inactive" ]]; then
    echo "PASS: Firewall remains inactive during pre-activation testing."
else
    echo "WARNING: Firewall is already active."
fi

echo
echo "No firewall activation was performed."
echo "REPORT SAVED: $REPORT"

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "REPORT COPIED TO WINDOWS CLIPBOARD."
fi
