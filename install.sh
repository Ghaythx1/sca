#!/usr/bin/env bash
# sca installer - works on Termux (Android) and Kali/Debian Linux.
# Usage: curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/install.sh | bash
set -eu

RAW="${SCA_RAW:-https://raw.githubusercontent.com/Ghaythx1/sca/main}"

# Pick the right bin directory.
if [ -n "${PREFIX:-}" ] && [ -d "$PREFIX/bin" ]; then
    BIN="$PREFIX/bin"          # Termux
else
    BIN="$HOME/.local/bin"     # Kali / normal Linux
fi

mkdir -p "$BIN"

fetch() {
    url="$1"
    out="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$out"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$out" "$url"
    else
        echo "[-] curl or wget is required." >&2
        exit 1
    fi
}

echo "[*] Downloading sca..."
fetch "$RAW/sca" "$BIN/sca"
chmod +x "$BIN/sca"

# Optional Python helpers: exact column widths + Arabic shaping.
echo "[*] Installing Python helpers (optional)..."
if command -v python3 >/dev/null 2>&1; then
    python3 -m pip install --quiet --upgrade wcwidth arabic-reshaper python-bidi 2>/dev/null \
        || python3 -m pip install --quiet --user wcwidth arabic-reshaper python-bidi 2>/dev/null \
        || python3 -m pip install --quiet --break-system-packages wcwidth arabic-reshaper python-bidi 2>/dev/null \
        || echo "[!] Could not install optional Python packages; sca will still run."
else
    echo "[!] python3 was not found. Install it first." >&2
    exit 1
fi

echo
echo "[+] Installed: $BIN/sca"
case ":$PATH:" in
    *":$BIN:"*) ;;
    *) echo "[!] Add this to your shell profile: export PATH=\"$BIN:\$PATH\"" ;;
esac
echo "[+] Run it with:  sca"
echo "    Examples:      sca          # scans 175-254"
echo "                   sca 175 254  # explicit range"
