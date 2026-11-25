# Lab 04: SSH Security & Hardening

## 1. Overview

This laboratory explores OpenSSH server installation,
public key authentication, SSH security hardening,
attack simulation, and security auditing.

## 2. Environment

- OS: Ubuntu 26.04.1 LTS
- Kernel: Linux 6.18.x WSL2
- Architecture: x86-64
- SSH Server: OpenSSH 10.2p1
- User: dhio35

## 3. Phase 01: SSH Baseline Audit

Inspected:
- SSH client and server installation
- SSH daemon availability
- SSH service status
- Port 22 listener
- Firewall status
- SSH configuration
- SSH directory permissions

Finding: SSH server was initially not installed.

## 4. Phase 02: OpenSSH Installation

Successfully installed OpenSSH server.

Validated:
- SSH daemon installation
- SSH service active
- SSH service enabled
- Port 22 listening
- Host key generation
- SSH configuration syntax

## 5. Phase 03: SSH Key Authentication & Hardening

Generated an ED25519 SSH key pair.

Configured:
- PermitRootLogin no
- PubkeyAuthentication yes
- PasswordAuthentication no
- KbdInteractiveAuthentication no
- PermitEmptyPasswords no
- MaxAuthTries 3
- LoginGraceTime 30
- X11Forwarding no
- AllowUsers dhio35

SSH Agent was configured to manage
the encrypted private key.

## 6. Phase 04: Attack Simulation

Performed local authentication tests.

| Test | Result |
|---|---|
| Authorized user authentication | PASS |
| Unauthorized user | DENIED |
| Root login | DENIED |
| Password authentication | DENIED |
| SSH configuration | VALID |
| SSH service | ACTIVE |

Security logs were inspected using journalctl.

## 7. Phase 05: Final Security Audit

Validated:
- Effective SSH security configuration
- SSH service status
- Network listener
- SSH directory permissions
- Private key permissions
- Authorized keys permissions
- Public key fingerprint
- SSH host key fingerprints
- Public key authentication
- SSH security logs

Permission baseline:
- ~/.ssh: 700
- authorized_keys: 600
- id_ed25519: 600

## 8. Security Concepts

- SSH Protocol
- Public Key Cryptography
- ED25519
- SSH Agent
- Authentication and Authorization
- SSH Hardening
- Least Privilege
- Authentication Logs
- Security Auditing

## 9. Evidence

- ../../evidence/lab-04-attack-simulation.txt
- ../../evidence/lab-04-final-security-audit.txt

## 10. Conclusion

The laboratory successfully demonstrated
OpenSSH installation, key-based authentication,
SSH security hardening, access restriction,
and security validation.

All final authentication and configuration
tests passed in the local WSL2 environment.

## 11. Next Laboratory

Lab 05: Network Fundamentals & Analysis.

---

Author: Dhio35
Project: Linux & Network Security Lab
GitHub: https://github.com/dhio35
