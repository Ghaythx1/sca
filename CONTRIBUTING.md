# Contributing to sca

Thank you for your interest in contributing to **sca**! We welcome community contributions, including new router vendor support, bug fixes, documentation improvements, and feature proposals.

---

## Code of Conduct

All contributors and participants are expected to adhere to friendly, constructive, and respectful collaboration standards. Please ensure that all research and tools are developed for lawful and authorized security testing.

---

## How Can I Contribute?

### 1. Adding Support for New Router Vendors or Firmwares
The primary goal of `sca` is expanding coverage across diverse CPE hardware and wireless routers. If you encounter a device that exposes diagnostic or configuration endpoints:

1. **Capture Diagnostic Endpoints**:
   - Identify unauthenticated HTTP endpoints (e.g., status pages, CGI scripts, JSON/XML APIs).
   - Document whether Wi-Fi SSID, WPA Pre-Shared Key (PSK), or client station lists are exposed.
   - Note if default credentials (such as `admin/admin` or `admin/password`) unlock specific management endpoints.

2. **Implement Parser Heuristics**:
   - Add a dedicated vendor discovery function in `sca` (e.g., `fetch_vendor()`).
   - Ensure timeouts are tight (`--connect-timeout` <= 1.5s, `--max-time` <= 5s) to preserve scanner concurrency.
   - Clean and sanitize extracted values using `clean()` to handle escaped characters and HTML entities.

3. **Validate Terminal Formatting**:
   - Verify that output columns align cleanly across standard widths.
   - Handle RTL/Arabic network names using `shape_arabic()`.

### 2. Reporting Bugs
- Use the [Issue Tracker](https://github.com/Ghaythx1/sca/issues) to report bugs.
- Provide the router vendor, firmware version, and sanitized output.
- Include terminal environment details (OS, shell, terminal emulator).

### 3. Submitting Pull Requests
1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/my-feature`.
3. Test your changes locally:
   ```bash
   bash -n install.sh
   python3 -m py_compile sca
   ./sca 175 175
   ```
4. Commit your changes with clear, descriptive commit messages.
5. Push to your branch and open a Pull Request against `main`.

---

## Style Guidelines

- Adhere to **PEP 8** standards for Python.
- Use explicit type annotations and docstrings where appropriate.
- Keep dependencies minimal to ensure ease of deployment on mobile environments (Termux).
