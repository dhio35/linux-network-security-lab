# Lab 02: Linux User & Group Management

## 1. Overview

This laboratory explores Linux user management,
group administration, and access control.

## 2. Environment

- OS: Ubuntu 26.04.1 LTS
- Kernel: Linux 6.18.x WSL2
- User: dhio35
- Lab user: dhio35_lab02
- Lab group: dhio35_lab02

## 3. Lab 02.1: User & Group Management

Successfully created:
- Dedicated Linux user
- Dedicated Linux group
- User home directory
- Locked password authentication

UID: 1001
GID: 1001

## 4. Lab 02.2: Access Control

Configured secure directory:

`/var/tmp/dhio35-lab02-secure`

Ownership:
- Owner: root
- Group: dhio35_lab02

Permission:
- Numeric: 2770
- SETGID: Enabled

## 5. Security Validation

| Test | Result |
|---|---|
| Authorized user write | PASS |
| Authorized user read | PASS |
| Unauthorized user access | DENIED |
| Non-member access restriction | PASS |
| SETGID group inheritance | PASS |

## 6. Key Security Concepts

- Linux UID and GID
- Primary groups
- Linux file permissions
- SETGID
- Group-based access control
- Principle of Least Privilege
- Discretionary Access Control (DAC)

## 7. Conclusion

The laboratory successfully demonstrated
Linux account management and group-based
directory access restrictions.

The experiments verified that authorized
users can access protected resources while
non-members are restricted by filesystem
permissions.

## 8. Evidence

See:

`../../evidence/lab-02-2-access-control.txt`

Author: Dhio35
GitHub: https://github.com/dhio35
