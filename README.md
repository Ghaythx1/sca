<div align="center">

# ⚡ sca

### High-Speed CPE Router Scanner & Credential Disclosure Auditor

[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/Ghaythx1/sca)
[![Python 3.8+](https://img.shields.io/badge/python-3.8%2B-blue.svg)](https://www.python.org/)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Termux%20(Android)-lightgrey.svg)](#installation)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Code Style: Black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

<p align="center">
  A fast, concurrent subnet reconnaissance tool engineered for network auditing, customer premises equipment (CPE) fingerprinting, unauthenticated Wi-Fi credential disclosure, client inventory, and active surveillance camera stream detection.
</p>

</div>

---

## 📌 Overview

**sca** audits routers and access points across local IPv4 subnets. It leverages low-latency socket pre-flight probes, multi-threaded HTTP heuristics, and vendor-specific API querying to discover:

- **Wireless Network Names (SSID)** with native bidirectional Arabic/Unicode shaping.
- **Exposed Wi-Fi Passwords** retrieved from unauthenticated diagnostic and backup endpoints.
- **Connected Client Counts** from station associations, repeater links, and DHCP lease allocations.
- **Traffic Telemetry & Camera Indicators** analyzing TX/RX counters and active LAN streams for surveillance gear.
- **Default Credential Verification** with targeted, single-shot fallback authentication (`admin/admin`).

> **⚠️ Notice**: This software is intended strictly for authorized security auditing, authorized penetration testing, and educational research on owned or authorized infrastructure.

---

## ✨ Features

- **⚡ High-Throughput Concurrency**: Multi-threaded execution (`ThreadPoolExecutor`) with fast pre-flight TCP port 80 / ICMP ping alive detection.
- **🔑 Credential Disclosure Engine**: Extracts plain-text WPA/WPA2 pre-shared keys from vulnerable CPE devices without administrative authentication.
- **📹 NVR & Camera Traffic Detection**: Real-time packet telemetry flags active streaming loads characteristic of IP cameras and NVR units.
- **🌐 Broad Hardware Matrix**: Tailored heuristics for **Realtek**, **Netis / Netcore**, **Tenda**, **TP-Link** (both modern CGI and classic web interfaces), and **ipTIME**.
- **🔤 Terminal-Width & RTL Engine**: Accurate cell-width alignment via `wcwidth` with bidirectional shaping for Arabic SSIDs in terminals without native BiDi support.
- **📱 True Cross-Platform**: Optimized for **Kali Linux**, **Debian/Ubuntu**, and mobile auditing in **Termux (Android)**.
- **📊 Structured JSON Export**: Save discovery results to structured JSON files (`-o / --output`) for automated tooling and reporting pipelines.
- **🎯 Flexible Target Syntax**: Supports start/end octets, single host targets, IP ranges (`192.168.1.10-50`), and CIDR notation (`192.168.1.0/24`).

---

## 🖥️ Terminal Preview

```text
#    | IP              | SSID                 | CLIENTS | TRAFFIC              | PASSWORD             | STATUS          
------------------------------------------------------------------------------------------------------------------------
01   | 192.168.1.1     | HomeNet              | 4       | 0 / 0                | MyWiFiPassword       | ❌ No Cameras   
02   | 192.168.1.20    | TP-Link_81           | 1       | 0 / 0                | A98765432@@          | ❌ No Cameras   
03   | 192.168.1.33    | Office-5G            | 3       | 25179 / 46216        | 11223344             | 📷 Cameras      
04   | 192.168.1.45    | شبكة_المنزل          | 6       | 0 / 0                | SecretKey2026        | ❌ No Cameras   
05   | 192.168.1.100   | Archer_C6            | N/A     | 0 / 0                | 🔒 login req.        | ❌ No Cameras   

✔ Scan Completed — 5 host(s), 1 camera(s)
```

---

## 📡 Supported Vendors & Capabilities

| Vendor / Chipset | SSID Extraction | Password Disclosure | Client Count | Heuristic & Endpoint Mechanisms |
| :--- | :---: | :---: | :---: | :--- |
| **Realtek** | Yes | Yes | Yes | `wlbasic.htm`, `wlsecurity_all.htm`, `status.htm` (sums radios + virtual SSIDs + repeaters) |
| **Netis / Netcore** | Yes | Yes | Yes | `netcore_get.cgi` mode payload; parses DHCP leases with ARP fallback |
| **Tenda** | Yes | Yes* | Yes* | `/goform/WifiBasicGet`, unauthenticated station endpoint probes |
| **TP-Link (Modern Web UI)** | Yes | Yes* | Yes* | Automated cookie-authenticated `/cgi` API query; station MAC association count |
| **TP-Link (Classic Web UI)** | Yes | Yes* | Yes* | HTTP Basic Auth querying `WlanNetworkRpm.htm` and `WlanSecurityRpm.htm` |
| **ipTIME** | Yes | Yes* | Yes* | Form-based session authentication (`login_handler.cgi`), wireless configuration scraping |
| **Generic / Other** | Partial | No | No | Identified via HTTP server headers and realm banners; marked as `🔒 login req.` |

> `*` **Best-Effort Authentication**: Credential extraction on modern TP-Link and ipTIME units utilizes single-shot default credentials (`admin/admin`). If credentials have been modified, the tool gracefully reports `🔒 login req.`.

---

## 🚀 Installation

### Option 1: Automated Installer (Termux & Linux)

The official installer detects your environment, installs dependencies, and creates the executable link in your binary directory (`$PREFIX/bin` on Termux, `~/.local/bin` on Linux):

#### Termux (Android)
```bash
pkg update -y && pkg install -y python curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/install.sh)"
```

#### Kali Linux / Debian / Ubuntu
```bash
sudo apt update && sudo apt install -y python3 python3-pip curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/install.sh)"
```

Ensure `~/.local/bin` is on your path (if not already):
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

### Option 2: Python PIP / Git

Install directly using `pip` or `pipx`:

```bash
# Recommended for CLI isolation:
pipx install git+https://github.com/Ghaythx1/sca.git

# Or via standard pip:
pip install git+https://github.com/Ghaythx1/sca.git
```

---

### Option 3: Instant Run (No Installation)

```bash
curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/sca -o /tmp/sca
chmod +x /tmp/sca
/tmp/sca
```

---

## 📖 Usage & Syntax

```text
sca [target] [end] [-s SUBNET] [-t THREADS] [-T TIMEOUT] [-o OUTPUT] [--realtek-only] [-v]
```

### Common Commands

```bash
# 1. Default subnet scan (15.15.15.175 - 15.15.15.254)
sca

# 2. Scan entire subnet
sca 1 254

# 3. Scan a custom subnet with custom threads
sca 1 254 -s 192.168.1 -t 32

# 4. CIDR notation scan
sca 192.168.1.0/24

# 5. IP range scan
sca 192.168.1.10-100

# 6. Single IP scan
sca 192.168.1.1

# 7. Audit Realtek hardware exclusively
sca --realtek-only

# 8. Export structured results to JSON
sca 192.168.1.0/24 -o scan_results.json
```

### CLI Arguments

| Argument | Short | Description | Default |
| :--- | :---: | :--- | :--- |
| `target` | | Starting host octet, CIDR (`192.168.1.0/24`), or range (`192.168.1.1-254`) | `175` |
| `end` | | Ending host octet | `254` |
| `--subnet` | `-s` | Subnet prefix (IPv4) | `15.15.15` |
| `--threads` | `-t` | Number of concurrent worker threads | `18` |
| `--timeout` | `-T` | Host alive probe timeout in seconds | `0.35` |
| `--output` | `-o` | Export scan records to a JSON file | `None` |
| `--realtek-only` | | Restrict scanner heuristics to Realtek chipsets | `False` |
| `--version` | `-v` | Show program version number and exit | |
| `--help` | `-h` | Display help screen and command examples | |

---

## 🔍 How It Works

```
   [ Target Subnet ]
           │
           ▼
┌──────────────────────┐
│  Host Pre-Flight     │ ──> TCP Port 80 SYN Check ──> ICMP Ping Fallback
└──────────────────────┘
           │ (Alive)
           ▼
┌──────────────────────┐
│ Vendor Fingerprint   │ ──> Realtek / Netis / Tenda / TP-Link / ipTIME
└──────────────────────┘
           │
           ▼
┌──────────────────────┐
│ Telemetry Extraction │ ──> Parse SSID, WPA Key, Station Count & Packet Stats
└──────────────────────┘
           │
           ▼
┌──────────────────────┐
│ Stream Formatted Row │ ──> Live Thread-Safe Output (Terminal / JSON export)
└──────────────────────┘
```

1. **Host Pre-Flight Verification**: Scans destination addresses with sub-second TCP:80 socket connection attempts. Dead hosts are pruned immediately without spawning external curl sub-processes.
2. **Vendor Identification**: Inspects root headers, web page signatures, and common CGI paths to identify hardware vendor and firmware build.
3. **Data Parsing & Shaping**: Extracts SSID, client counts, and cryptographic keys. Arabic and complex Unicode SSIDs are visually reshaped for correct terminal presentation.
4. **Targeted Authentication Fallback**: Only when an authenticated administrative interface is confirmed, a single non-intrusive `admin/admin` handshake is attempted.

---

## 📋 Dependencies

- **Python**: `>= 3.8`
- **System**: `curl` (or `wget`)
- **Optional Python Libraries** *(automatically handled by installer)*:
  - `wcwidth` — Accurate terminal cell measurements
  - `arabic-reshaper` — Connected letter rendering
  - `python-bidi` — Bidirectional text algorithms

---

## 🛡️ Responsible Disclosure & Legal Disclaimer

This utility is provided strictly for authorized security auditing, infrastructure reconnaissance, and defensive network posture validation. 

Users are legally bound to obtain explicit written consent before auditing third-party networks. The authors and maintainers of this repository assume no liability and are not responsible for any misuse, damage, or illegal actions resulting from the use of this software.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
