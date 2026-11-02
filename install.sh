#!/usr/bin/env bash
#
# sca installer for Termux (Android) and Kali/Debian Linux.
#
#   curl -fsSL https://raw.githubusercontent.com/Ghaythx1/sca/main/install.sh | bash
#
# Environment variables:
#   SCA_RAW        Override the raw repository base URL.
#   SCA_SKIP_DEPS  Set to 1 to skip the optional Python dependencies.
#
set -euo pipefail

RAW="${SCA_RAW:-https://raw.githubusercontent.com/Ghaythx1/sca/main}"
SKIP_DEPS="${SCA_SKIP_DEPS:-0}"

info() { printf '[*] %s\n' "$*"; }
ok()   { printf '[+] %s\n' "$*"; }
warn() { printf '[!] %s\n' "$*" >&2; }
die()  { printf '[-] %s\n' "$*" >&2; exit 1; }

# Termux installs into $PREFIX/bin; regular Linux uses ~/.local/bin.
if [ -n "${PREFIX:-}" ] && [ -d "$PREFIX/bin" ]; then
    BIN="$PREFIX/bin"
else
    BIN="$HOME/.local/bin"
fi

command -v python3 >/dev/null 2>&1 || die "python3 is required."

mkdir -p "$BIN"

fetch() {
    local url="$1" out="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$out"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$out" "$url"
    else
        die "curl or wget is required."
    fi
}

info "Downloading sca..."
fetch "$RAW/sca" "$BIN/sca"
chmod 0755 "$BIN/sca"

if [ "$SKIP_DEPS" != "1" ]; then
    info "Installing optional Python dependencies..."
    if ! python3 -m pip install --quiet --disable-pip-version-check \
            wcwidth arabic-reshaper python-bidi 2>/dev/null; then
        if ! python3 -m pip install --quiet --disable-pip-version-check --user \
                wcwidth arabic-reshaper python-bidi 2>/dev/null; then
            python3 -m pip install --quiet --disable-pip-version-check \
                --break-system-packages wcwidth arabic-reshaper python-bidi \
                2>/dev/null \
                || warn "Could not install optional packages; sca will still run."
        fi
    fi
fi

echo
ok "Installed: $BIN/sca"

case ":$PATH:" in
    *":$BIN:"*) ;;
    *) warn "Add this to your shell profile: export PATH=\"$BIN:\$PATH\"" ;;
esac

ok "Run: sca"
printf '    Default range:  sca          # 175-254\n'
printf '    Custom range:   sca 175 254\n'
