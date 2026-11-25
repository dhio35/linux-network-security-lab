#!/usr/bin/env bash
set -uo pipefail

REPORT="evidence/lab-04-attack-simulation.txt"
mkdir -p evidence

exec > >(tee "$REPORT") 2>&1

echo "=========================================="
echo "DHIO35 | LAB 04 PHASE 04"
echo "SSH SECURITY ATTACK SIMULATION"
date
echo "=========================================="

echo ""
echo "===== 01. VALID SSH AUTHENTICATION ====="

if ssh -o BatchMode=yes \
    -o ConnectTimeout=5 \
    -o IdentitiesOnly=yes \
    localhost 'whoami'; then
    echo "PASS: Authorized user authenticated."
else
    echo "FAIL: Authorized authentication failed."
    exit 1
fi

echo ""
echo "===== 02. UNAUTHORIZED USER TEST ====="

set +e
ssh -o BatchMode=yes \
    -o ConnectTimeout=5 \
    -o PreferredAuthentications=publickey \
    -o IdentitiesOnly=yes \
    nobody@localhost true

UNAUTHORIZED_CODE=$?
set -e

if [[ "$UNAUTHORIZED_CODE" -ne 0 ]]; then
    echo "PASS: Unauthorized user rejected."
else
    echo "FAIL: Unauthorized user authenticated."
    exit 1
fi

echo ""
echo "===== 03. ROOT LOGIN TEST ====="

set +e
ssh -o BatchMode=yes \
    -o ConnectTimeout=5 \
    -o PreferredAuthentications=publickey \
    root@localhost true

ROOT_CODE=$?
set -e

if [[ "$ROOT_CODE" -ne 0 ]]; then
    echo "PASS: Root login rejected."
else
    echo "FAIL: Root login succeeded."
    exit 1
fi

echo ""
echo "===== 04. PASSWORD AUTHENTICATION TEST ====="

set +e
ssh -o BatchMode=yes \
    -o ConnectTimeout=5 \
    -o PreferredAuthentications=password \
    -o PubkeyAuthentication=no \
    dhio35@localhost true

PASSWORD_CODE=$?
set -e

if [[ "$PASSWORD_CODE" -ne 0 ]]; then
    echo "PASS: Password authentication rejected."
else
    echo "FAIL: Password authentication succeeded."
    exit 1
fi

echo ""
echo "===== 05. SSH SECURITY LOGS ====="

sudo journalctl -u ssh \
    --since "10 minutes ago" \
    --no-pager | tail -n 35

echo ""
echo "===== 06. FINAL VALIDATION ====="

sudo sshd -t && echo "PASS: SSH configuration valid."

systemctl is-active ssh
systemctl is-enabled ssh

echo ""
echo "=========================================="
echo "LAB 04 PHASE 04 COMPLETED"
echo "=========================================="

echo ""
echo "Evidence saved: $REPORT"

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "Report copied to Windows clipboard."
fi
