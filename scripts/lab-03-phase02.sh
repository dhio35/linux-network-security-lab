#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT="$HOME/projects/linux-network-security-lab"
LAB_USER="dhio35_lab02"
LAB_GROUP="dhio35_lab02"
SGID_DIR="/var/tmp/dhio35-lab03-sgid"
REPORT="$PROJECT/evidence/lab-03-ownership-audit.txt"

cd "$PROJECT"
mkdir -p evidence

echo "[1/6] Checking authorized user..."

id "$LAB_USER" >/dev/null
getent group "$LAB_GROUP" >/dev/null

echo "[2/6] Verifying SGID inheritance..."

sudo -u "$LAB_USER" bash -c '
umask 0002
echo "DHIO35 SGID inheritance test" \
> "$1/inherited-file.txt"
' _ "$SGID_DIR"

ACTUAL_GROUP=$(sudo stat -c '%G' "$SGID_DIR/inherited-file.txt")

echo "[3/6] Testing unauthorized access..."

if sudo -u nobody test -r "$SGID_DIR"; then
    READ_RESULT="FAIL"
else
    READ_RESULT="PASS"
fi

if sudo -u nobody test -w "$SGID_DIR"; then
    WRITE_RESULT="FAIL"
else
    WRITE_RESULT="PASS"
fi

echo "[4/6] Generating security report..."

{
    echo "=========================================="
    echo "DHIO35 | LAB 03 PHASE 02"
    echo "OWNERSHIP & SECURITY AUDIT"
    date
    echo "=========================================="

    echo ""
    echo "===== 01. SGID DIRECTORY ====="
    sudo stat -c '%A | %a | %U:%G | %n' "$SGID_DIR"

    echo ""
    echo "===== 02. INHERITED FILE ====="
    sudo stat -c '%A | %a | %U:%G | %n' \
        "$SGID_DIR/inherited-file.txt"

    echo ""
    echo "===== 03. GROUP INHERITANCE ====="
    echo "Expected: $LAB_GROUP"
    echo "Actual: $ACTUAL_GROUP"

    if [[ "$ACTUAL_GROUP" == "$LAB_GROUP" ]]; then
        echo "RESULT: PASS"
    else
        echo "RESULT: FAIL"
    fi

    echo ""
    echo "===== 04. UNAUTHORIZED ACCESS ====="
    echo "Unauthorized read: $READ_RESULT"
    echo "Unauthorized write: $WRITE_RESULT"

    echo ""
    echo "===== 05. SUID AUDIT ====="
    find labs/03-file-permissions/workspace \
        -type f -perm -4000 \
        -printf '%m %u:%g %p\n' || true

    echo ""
    echo "===== 06. SGID AUDIT ====="
    find labs/03-file-permissions/workspace \
        \( -type f -o -type d \) -perm -2000 \
        -printf '%m %u:%g %p\n' || true

    echo ""
    echo "===== 07. WORLD-WRITABLE AUDIT ====="
    find labs/03-file-permissions/workspace \
        -type f -perm -0002 \
        -printf '%m %u:%g %p\n' || true

    echo ""
    echo "===== 08. VALIDATION SUMMARY ====="
    echo "SGID inheritance: $([[ "$ACTUAL_GROUP" == "$LAB_GROUP" ]] && echo PASS || echo FAIL)"
    echo "Unauthorized read: $READ_RESULT"
    echo "Unauthorized write: $WRITE_RESULT"

    echo ""
    echo "=========================================="
    echo "LAB 03 PHASE 02 COMPLETED"
    echo "=========================================="
} > "$REPORT" 2>&1

echo "[5/6] Displaying report..."
cat "$REPORT"

echo ""
echo "[6/6] Saving evidence..."

if command -v clip.exe >/dev/null 2>&1; then
    clip.exe < "$REPORT"
    echo "Report copied to Windows clipboard."
fi

echo "Evidence: $REPORT"
