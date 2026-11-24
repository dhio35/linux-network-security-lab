# Lab 01: Linux Filesystem Exploration

## 1. Overview

This laboratory explores the fundamental Linux
filesystem structure and system environment.

Environment:
- OS: Ubuntu 26.04.1 LTS
- Kernel: Linux 6.18.x WSL2
- Architecture: x86-64
- Virtualization: WSL2
- User: dhio35

## 2. Objectives

- Understand Linux filesystem hierarchy.
- Identify important system directories.
- Inspect user and group information.
- Examine storage and memory utilization.
- Understand running Linux processes.
- Inspect network interfaces and routing.

## 3. Commands Practiced

| Command | Purpose |
|---|---|
| hostnamectl | System information |
| whoami | Current username |
| id | User and group information |
| pwd | Current directory |
| ls -lah / | Root filesystem |
| df -hT | Filesystem usage |
| free -h | Memory information |
| ps -eo pid,ppid,user,stat,comm --sort=pid | Running processes |
| ip -brief address | Network interfaces |
| ip route | Network routing |
| findmnt / | Mounted filesystem |

## 4. Key Findings

### Filesystem

- Root filesystem uses ext4.
- Linux filesystem follows a hierarchical structure.
- Important directories include /etc, /home,
  /var, /tmp, /usr, /proc and /dev.

### User Management

- Current user: dhio35
- UID: 1000
- Primary GID: 1000
- User belongs to the sudo group.

### Process Management

- systemd operates as PID 1.
- System services are managed through systemd.

### Memory and Storage

- WSL memory available during the experiment:
  approximately 7.2 GiB.
- Swap capacity: 2 GiB.
- Root filesystem uses ext4.

### Network

- Loopback interface: lo.
- Main network interface: eth0.
- Network interface was UP during testing.
- A default gateway was configured.

## 5. Security Observations

1. Administrative privileges should be used carefully.
2. System logs are important for security investigations.
3. Linux filesystem permissions should be understood
   before performing system administration.
4. Network interfaces and routing information provide
   useful visibility into system connectivity.

## 6. Conclusion

The experiment successfully demonstrated basic
Linux filesystem exploration, system inspection,
process visibility, and network configuration.

## 7. Next Laboratory

Lab 02: Linux User and Group Management.

---

Author: Dhio35
Project: Linux & Network Security Lab
GitHub: https://github.com/dhio35
