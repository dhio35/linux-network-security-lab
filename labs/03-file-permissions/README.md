# Lab 03: Linux File Permissions & Ownership

## 1. Overview

This laboratory explores Linux filesystem permissions,
ownership management, special permission bits,
and security access control.

## 2. Environment

- OS: Ubuntu 26.04.1 LTS
- Kernel: Linux 6.18.x WSL2
- Architecture: x86-64
- Administrator: dhio35
- Lab User: dhio35_lab02
- Lab Group: dhio35_lab02

## 3. Learning Objectives

- Understand Linux permission models.
- Configure file and directory permissions.
- Manage file and group ownership.
- Understand SUID, SGID, and Sticky Bit.
- Validate authorized and unauthorized access.
- Identify potentially dangerous permissions.

## 4. Phase 01: File Permissions Audit

Created test objects with different permissions.

| Object | Permission | Description |
|---|---:|---|
| public.txt | 644 | Standard readable file |
| executable.sh | 755 | Executable file |
| private.txt | 700 | Owner-only access |
| suid-demo.txt | 4750 | SUID demonstration |
| sgid-demo | 2770 | SGID directory |
| sticky-demo | 1777 | Sticky Bit directory |

### Concepts Practiced

- chmod
- stat
- ls -l
- Numeric permissions
- SUID
- SGID
- Sticky Bit

## 5. Phase 02: Ownership & Security Audit

Configured test directory:

`/var/tmp/dhio35-lab03-sgid`

Directory ownership:

- Owner: root
- Group: dhio35_lab02
- Permission: 2770

### Group Inheritance

Created a file using the authorized lab user.

| Attribute | Result |
|---|---|
| File owner | dhio35_lab02 |
| File group | dhio35_lab02 |
| File permission | 664 |
| Group inheritance | PASS |

### Security Validation

| Test | Result |
|---|---|
| SGID group inheritance | PASS |
| Unauthorized read | PASS |
| Unauthorized write | PASS |
| SUID identification | PASS |
| SGID identification | PASS |
| World-writable audit | No files found |

## 6. Security Concepts

### Standard Permissions

Linux permissions consist of:
- Read (r)
- Write (w)
- Execute (x)

### Special Permissions

- SUID: Sets effective user ID for eligible executable files.
- SGID: Sets group ID behavior and enables group inheritance on directories.
- Sticky Bit: Restricts deletion of files in shared directories.

### Principle of Least Privilege

Users should receive only the permissions
necessary to perform their assigned tasks.

### Security Auditing

Permission audits help identify:
- Excessive access permissions.
- Unexpected SUID files.
- Unexpected SGID configurations.
- World-writable files.
- Incorrect ownership.

## 7. Conclusion

The laboratory successfully demonstrated Linux
file permissions, ownership management,
special permission bits, and access control.

The experiments verified SGID group inheritance
and confirmed that unauthorized users were
prevented from accessing restricted resources.

These concepts are fundamental to Linux
system hardening and security operations.

## 8. Evidence

- `../../evidence/lab-03-permissions-audit.txt`
- `../../evidence/lab-03-ownership-audit.txt`

## 9. Next Laboratory

Lab 04: SSH Security & Hardening.

---

Author: Dhio35
Project: Linux & Network Security Lab
GitHub: https://github.com/dhio35
