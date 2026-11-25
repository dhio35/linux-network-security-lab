#!/usr/bin/env bash

set -uo pipefail

ROOT="$HOME/projects/linux-network-security-lab"
REPORT="$ROOT/evidence/lab-05-final-security-audit.txt"

mkdir -p "$ROOT/evidence"
exec > >(tee "$REPORT") 2>&1

PASS=0
FAIL=0

check() {
    local description="$1"
    shift

    if "$@"; then
        echo "PASS: $description"
        ((PASS+=1))
    else
        echo "FAIL: $description"
        ((FAIL+=1))
    fi
}

section() {
    echo
    echo "=================================================="
    echo "$1"
    echo "=================================================="
}

section "DHIO35 | LAB 05 PHASE 06"
echo "FINAL LINUX FIREWALL SECURITY AUDIT"
date

section "01. FIREWALL STATUS"
sudo ufw status verbose

check "UFW is active" \
    bash -c 'sudo ufw status | grep -q "^Status: active$"'

section "02. DEFAULT FIREWALL POLICIES"
grep -E '^(IPV6|DEFAULT_INPUT_POLICY|DEFAULT_OUTPUT_POLICY|DEFAULT_FORWARD_POLICY)=' \
    /etc/default/ufw

check "Incoming default is DROP" \
    grep -q '^DEFAULT_INPUT_POLICY="DROP"' /etc/default/ufw

check "Outgoing default is ACCEPT" \
    grep -q '^DEFAULT_OUTPUT_POLICY="ACCEPT"' /etc/default/ufw

check "Forwarded default is DROP" \
    grep -q '^DEFAULT_FORWARD_POLICY="DROP"' /etc/default/ufw

section "03. SSH FIREWALL RULE"
sudo ufw status numbered

check "SSH TCP 22 is allowed" \
    sudo ufw status | grep -qE '22/tcp[[:space:]]+ALLOW IN'

section "04. SSH SERVICE"
check "SSH service is active" systemctl is-active --quiet ssh

check "SSH configuration syntax is valid" \
    sudo sshd -t

check "SSH local port 22 is reachable" \
    timeout 5 bash -c '</dev/tcp/127.0.0.1/22'

section "05. SSH KEY AUTHENTICATION"
if ssh -o BatchMode=yes \
       -o StrictHostKeyChecking=yes \
       -o ConnectTimeout=5 \
       dhio35@127.0.0.1 \
       'echo SSH_KEY_AUTHENTICATION_SUCCESS'; then
    echo "PASS: SSH key authentication works."
    ((PASS+=1))
else
    echo "FAIL: SSH key authentication failed."
    ((FAIL+=1))
fi

section "06. OUTBOUND CONNECTIVITY"
check "DNS resolution works" getent hosts archive.ubuntu.com

check "Outbound HTTPS TCP 443 works" \
    timeout 5 bash -c ':</dev/tcp/archive.ubuntu.com/443'

section "07. FIREWALL LOGGING"
sudo ufw status verbose | grep -E 'Logging:|Default:'

section "08. AUDIT SUMMARY"
echo "Passed checks: $PASS"
echo "Failed checks: $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
    echo "FINAL RESULT: PASS"
else
    echo "FINAL RESULT: REVIEW REQUIRED"
fi

echo
echo "REPORT SAVED: $REPORT"

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "REPORT COPIED TO WINDOWS CLIPBOARD."
fi

[[ "$FAIL" -eq 0 ]]
