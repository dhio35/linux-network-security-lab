# Lab 05: Linux Firewall & Network Traffic Control

## Overview
Implementation of Linux host-based firewall security using UFW
on Ubuntu 26.04.1 LTS running under WSL2.

## Learning Objectives
- Understand Linux firewall fundamentals.
- Install and configure UFW.
- Configure incoming and outgoing traffic policies.
- Control SSH access through TCP port 22.
- Activate firewall and validate network connectivity.
- Perform a final security audit.

## Environment
| Component | Configuration |
|---|---|
| OS | Ubuntu 26.04.1 LTS |
| Kernel | Linux 6.18.58.1-microsoft-standard-WSL2 |
| Architecture | x86_64 |
| UFW | 0.36.2 |
| Backend | iptables (nf_tables) |
| Framework | nftables |

## Lab Phases
1. Network and Firewall Baseline
2. UFW Installation and Fundamentals
3. Firewall Rules Configuration
4. Pre-Activation Security Testing
5. Firewall Activation and Access Control Testing
6. Final Security Audit
7. Documentation and GitHub Publication

## Firewall Configuration
| Policy | Configuration |
|---|---|
| Incoming | DENY |
| Outgoing | ALLOW |
| Routed | DENY |
| SSH TCP 22 | ALLOW |
| IPv6 | Enabled |
| Logging | Low |

## Active Rules
- TCP 22: ALLOW IN Anywhere
- TCP 22 IPv6: ALLOW IN Anywhere (v6)

## Security Validation
- UFW active.
- Incoming default policy DROP.
- Outgoing default policy ACCEPT.
- Forwarded default policy DROP.
- SSH service active.
- SSH configuration syntax valid.
- Local TCP port 22 reachable.
- SSH key authentication successful.
- DNS resolution successful.
- Outbound HTTPS successful.

Final audit: 10 checks passed, 0 failed.

## Evidence
- lab-05-network-firewall-baseline.txt
- lab-05-ufw-installation.txt
- lab-05-firewall-rules.txt
- lab-05-pre-activation-security-test.txt
- lab-05-firewall-activation-audit.txt
- lab-05-final-security-audit.txt

All evidence is stored in the repository evidence directory.

## Scope and Limitations
This lab validates firewall configuration and local connectivity
inside Ubuntu WSL2. It does not establish external network
inaccessibility or validate Windows Firewall configuration.

## Conclusion
Successfully installed, configured, activated, and audited
a Linux host-based firewall using UFW.

Final result: 10 passed, 0 failed.
