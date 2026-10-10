#!/usr/bin/env bash
set -Eeuo pipefail

# Optional macOS-style extras: auto-hide top bar, blur, window animations.
# Installs GNOME Extensions from extensions.gnome.org (user-local, no sudo).
# Usage: bash extras.sh

say() { printf '\n\033[1;36m%s\033[0m\n' "$*"; }
fail() { printf '\nERROR: %s\n' "$*" >&2; exit 1; }

EXT_DIR="$HOME/.local/share/gnome-shell/extensions"
API="https://extensions.gnome.org/extension-info/"

# uuid -> friendly name
declare -A EXTS=(
  ["hidetopbar@mathieu.bidon.ca"]="Auto-hide top bar"
  ["blur-my-shell@aunetx"]="Blur top bar / overview"
  ["burn-my-windows@schneegans.github.com"]="Window open/close animations"
)

# GNOME major version (e.g. 50)
GNOME_VER="$(gnome-shell --version 2>/dev/null | grep -oE '[0-9]+' | head -1)"
[ -n "$GNOME_VER" ] || fail "Could not detect GNOME version."

command -v curl >/dev/null 2>&1 || fail "curl is required."
command -v jq   >/dev/null 2>&1 || fail "jq is required (sudo apt install jq)."
command -v gnome-extensions >/dev/null 2>&1 || fail "gnome-extensions not found."

say "Installing macOS-style extras for GNOME $GNOME_VER"

for uuid in "${!EXTS[@]}"; do
  name="${EXTS[$uuid]}"
  echo
  say "$name ($uuid)"

  if gnome-extensions list 2>/dev/null | grep -qx "$uuid"; then
    echo "  Already installed — enabling."
    gnome-extensions enable "$uuid" 2>/dev/null || true
    continue
  fi

  echo "  Fetching from extensions.gnome.org ..."
  info="$(curl -fsSL "${API}?uuid=${uuid}&shell_version=${GNOME_VER}")" || {
    echo "  WARN: not available for GNOME $GNOME_VER — skipping."
    continue
  }
  url="$(jq -r '.download_url // empty' <<<"$info")"
  [ -n "$url" ] || { echo "  WARN: no download URL — skipping."; continue; }
  case "$url" in http*) ;; *) url="https://extensions.gnome.org${url}";; esac

  tmpzip="$(mktemp --suffix=.zip)"
  curl -fsSL "$url" -o "$tmpzip" || { echo "  WARN: download failed — skipping."; rm -f "$tmpzip"; continue; }

  mkdir -p "$EXT_DIR"
  gnome-extensions install -f "$tmpzip" 2>/dev/null || {
    echo "  WARN: install failed — skipping."; rm -f "$tmpzip"; continue
  }
  rm -f "$tmpzip"

  gnome-extensions enable "$uuid" 2>/dev/null || true
  echo "  Installed and enabled."
done

# hidetopbar: macOS-style auto-hide (reveal when mouse hits top edge)
if gsettings list-schemas 2>/dev/null | grep -qx "org.gnome.shell.extensions.hidetopbar"; then
  say "Configuring auto-hide top bar"
  gsettings set org.gnome.shell.extensions.hidetopbar mouse-sensitive true 2>/dev/null || true
fi

say "Done!"
echo "Extras installed: ${!EXTS[*]}"
echo "Log out and back in for animations/blur to fully apply."
echo
echo "Manage them in: Extensions app (or Tweaks → Extensions)"
