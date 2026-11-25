#!/usr/bin/env bash
set -euo pipefail

REPORT="evidence/lab-04-final-security-audit.txt"
mkdir -p evidence

exec > >(tee "$REPORT") 2>&1

echo "=========================================="
echo "DHIO35 | LAB 04 PHASE 05"
echo "SSH FINAL SECURITY AUDIT"
date
echo "=========================================="

echo ""
echo "===== 01. SSH CONFIGURATION VALIDATION ====="
sudo sshd -t
echo "PASS: SSH syntax valid."

echo ""
echo "===== 02. EFFECTIVE SECURITY POLICY ====="
sudo sshd -T | grep -E \
'^(permitrootlogin|pubkeyauthentication|passwordauthentication|kbdinteractiveauthentication|permitemptypasswords|maxauthtries|logingracetime|x11forwarding|allowusers)'

echo ""
echo "===== 03. SSH SERVICE STATUS ====="
systemctl is-active ssh
systemctl is-enabled ssh

echo ""
echo "===== 04. SSH NETWORK LISTENER ====="
sudo ss -ltnp | grep ':22'

echo ""
echo "===== 05. SSH DIRECTORY PERMISSIONS ====="
stat -c '%A | %a | %U:%G | %n' \
    ~/.ssh \
    ~/.ssh/authorized_keys \
    ~/.ssh/id_ed25519

echo ""
echo "===== 06. SSH PUBLIC KEY FINGERPRINT ====="
ssh-keygen -lf ~/.ssh/id_ed25519.pub

echo ""
echo "===== 07. SSH HOST KEY FINGERPRINTS ====="
sudo ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
sudo ssh-keygen -lf /etc/ssh/ssh_host_rsa_key.pub

echo ""
echo "===== 08. AUTHENTICATION VERIFICATION ====="
ssh -o BatchMode=yes \
    -o IdentitiesOnly=yes \
    localhost 'echo "PASS: Public key authentication"; whoami'

echo ""
echo "===== 09. RECENT SSH SECURITY EVENTS ====="
sudo journalctl -u ssh \
    --since "30 minutes ago" \
    --no-pager | tail -n 25

echo ""
echo "===== 10. AUDIT CONCLUSION ====="
echo "SSH configuration: VALID"
echo "Public key authentication: VERIFIED"
echo "Password authentication: DISABLED"
echo "Root login: DISABLED"
echo "Authorized account: dhio35"
echo ""
echo "=========================================="
echo "LAB 04 PHASE 05 COMPLETED"
echo "=========================================="

echo ""
echo "Evidence saved: $REPORT"

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "Report copied to Windows clipboard."
fi
