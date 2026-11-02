# sca

[![Python 3.8+](https://img.shields.io/badge/python-3.8%2B-blue.svg)](https://www.python.org/)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Termux-lightgrey.svg)](#installation)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

**sca** is a fast, threaded scanner for routers on a local subnet. It discovers
access points, reads exposed Wi-Fi credentials, counts connected clients, and
flags devices that look like camera/NVR traffic.

> Use this tool only on networks you own or are explicitly authorized to test.

---

## Features

- Fast multi-threaded subnet scan with live, numbered output.
- Discovers SSID, client count, traffic counters, and Wi-Fi password where the
  router exposes them without authentication.
- Supports **Realtek**, **Netis**, **Tenda**, **TP-Link**, and **ipTIME** devices.
- Best-effort `admin/admin` login for devices that hide their settings behind a
  login page (TP-Link modern/classic UI and ipTIME).
- Accurate, width-aware column alignment using `wcwidth`.
- Correct on-screen rendering of Arabic SSIDs on terminals without BiDi support.
- Works on **Kali/Debian Linux** and **Termux (Android)**.

---

## Supported devices

| Vendor | SSID | Password | Clients | Notes |
| --- | --- | --- | --- | --- |
| Realtek | Yes | Yes | Yes | `wlbasic.htm`, `wlsecurity_all.htm`, `status.htm` |
| Netis / Netcore | Yes | Yes | Yes | `netcore_get.cgi`; DHCP leases with ARP fallback |
| Tenda | Yes | Yes* | Yes* | Depends on firmware exposing unauthenticated endpoints |
| TP-Link (modern UI) | Yes | Yes | Yes | Uses `/cgi` API after `admin/admin` login |
| TP-Link (classic UI) | Yes | Yes* | Yes* | HTTP Basic auth with `admin/admin` |
| ipTIME | Yes | Yes* | Yes* | Form login with `admin/admin` |
| Other | Sometimes | No | No | Shown as `login req.` when authentication is required |

`*` Best-effort: results depend on firmware, credentials, and whether the
router exposes the relevant page/API.

---

## Installation

### Termux (Android)

```bash
pkg update -y && pkg install -y python curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/install.sh)"
```

### Kali Linux / Debian

```bash
sudo apt update && sudo apt install -y python3 python3-pip curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/install.sh)"
```

If `~/.local/bin` is not on your `PATH`:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Run without installing

```bash
curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/sca -o /tmp/sca
chmod +x /tmp/sca
/tmp/sca
```

The installer downloads `sca`, installs the optional Python helpers
(`wcwidth`, `arabic-reshaper`, `python-bidi`), and places the executable in
`$PREFIX/bin` on Termux or `~/.local/bin` on Linux.

---

## Usage

```text
sca [start] [end] [-t THREADS] [-s SUBNET] [--realtek-only]
```

| Command | Description |
| --- | --- |
| `sca` | Scan `15.15.15.175` through `15.15.15.254` (default) |
| `sca 1 254` | Scan the full subnet |
| `sca 175 254 -s 192.168.1` | Scan a different subnet |
| `sca -t 32` | Increase the number of worker threads |
| `sca --realtek-only` | Scan Realtek devices only |

### Example output

```text
#    | IP              | SSID                 | CLIENTS | TRAFFIC              | PASSWORD             | STATUS
----------------------------------------------------------------------------------------------------------------
01   | 192.168.1.1     | HomeNet              | 4       | 0 / 0                | MyWiFiPassword       | ❌ No Cameras
02   | 192.168.1.20    | TP-Link_81           | 1       | 0 / 0                | A98765432@@          | ❌ No Cameras
03   | 192.168.1.33    | Office-5G            | 2       | 25179 / 46216        | 11223344             | 📷 Cameras
```

### Columns

| Column | Meaning |
| --- | --- |
| `#` | Discovery order |
| `IP` | Router address |
| `SSID` | Wireless network name (Arabic is rendered correctly) |
| `CLIENTS` | Connected clients, or `N/A` when unavailable |
| `TRAFFIC` | TX / RX counters, or active LAN count |
| `PASSWORD` | Wi-Fi password when exposed; never truncated |
| `STATUS` | Camera/NVR traffic indicator |

---

## How it works

1. Checks whether port 80 is open (falling back to ICMP ping).
2. Identifies the vendor and fetches the relevant status pages.
3. Extracts SSID, password, traffic counters, and client counts.
4. If the device requires authentication, attempts `admin/admin` with the
   vendor-specific login flow.
5. Streams formatted rows to the terminal as workers finish.

No brute force or credential guessing is performed beyond the single
`admin/admin` attempt.

---

## Requirements

- Python 3.8+
- `curl` (or `wget` for installation)
- Optional Python packages:
  - `wcwidth` — exact terminal column widths
  - `arabic-reshaper` and `python-bidi` — Arabic SSID shaping

The tool still runs if the optional packages are missing, but alignment and
Arabic rendering may be less accurate.

---

## Notes and limitations

- Client counts vary by vendor: some report wireless stations only, others
  include wired DHCP leases.
- Password disclosure depends entirely on the router exposing the value without
  authentication. Devices that require a non-default login are reported as
  `login req.`.
- The scanner is intended for IPv4 `/24`-style local subnets.
- Some routers respond slowly or intermittently; re-run the scan if a host is
  missing.

---

## Disclaimer

This project is provided for educational and authorized security testing only.
You are responsible for complying with all applicable laws and for obtaining
permission before scanning any network. The authors accept no liability for
misuse or damage.

---

## License

Released under the [MIT License](LICENSE).
