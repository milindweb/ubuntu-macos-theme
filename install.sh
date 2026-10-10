#!/usr/bin/env bash
set -Eeuo pipefail

# Ubuntu macOS-style Theme Setup — system-wide installer
# Installs WhiteSur Dark GTK + icons system-wide, libadwaita override, and applies settings.
# Usage: bash install.sh

THEME_REPO="https://github.com/vinceliuice/WhiteSur-gtk-theme.git"
ICON_REPO="https://github.com/vinceliuice/WhiteSur-icon-theme.git"
WORK_DIR="$(mktemp -d)"
LOG_FILE="$HOME/ubuntu-macos-theme.log"

cleanup() { rm -rf "$WORK_DIR"; }
trap cleanup EXIT

say() { printf '\n\033[1;36m%s\033[0m\n' "$*"; }
fail() {
  printf '\nERROR: %s\n' "$*" >&2
  printf 'Log: %s\n' "$LOG_FILE" >&2
  exit 1
}

exec > >(tee -a "$LOG_FILE") 2>&1

# --- sudo helper: zenity password popup if needed ---
sudo_setup() {
  if sudo -n true 2>/dev/null; then return 0; fi
  if command -v zenity >/dev/null 2>&1; then
    cat > /tmp/opencode-askpass.sh <<'EOF'
#!/usr/bin/env bash
zenity --password --title="Ubuntu macOS Theme — sudo password required"
EOF
    chmod +x /tmp/opencode-askpass.sh
    export SUDO_ASKPASS=/tmp/opencode-askpass.sh
    sudo -A true || fail "Wrong password or sudo cancelled."
  else
    sudo -v || fail "sudo password required."
  fi
}

say "Ubuntu macOS-style Theme Setup (system-wide)"
echo "Installs: WhiteSur Dark GTK, WhiteSur icons, libadwaita override, dark mode,"
echo "window buttons :minimize,maximize,close (right), dock on right."
echo

# Pre-checks
command -v apt-get >/dev/null 2>&1 || fail "This script requires Ubuntu/Debian with apt."
command -v gsettings >/dev/null 2>&1 || fail "GNOME (gsettings) not found."

# sudo
say "Requesting sudo access"
sudo_setup

# --- Build dependencies ---
say "Installing build dependencies"
sudo -A apt-get update -qq
sudo -A apt-get install -y git sassc libglib2.0-dev-bin libxml2-utils >/dev/null

# --- Backup settings ---
BACKUP_DIR="$HOME/.local/share/ubuntu-macos-theme-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
dconf dump /org/gnome/ > "$BACKUP_DIR/gnome-settings.dconf" 2>/dev/null || true
echo "Settings backup: $BACKUP_DIR"

# --- WhiteSur GTK theme ---
say "Downloading and building WhiteSur Dark GTK theme"
git clone --depth=1 "$THEME_REPO" "$WORK_DIR/WhiteSur-gtk-theme"
(
  cd "$WORK_DIR/WhiteSur-gtk-theme"
  sudo -A ./install.sh -c dark -o normal -d /usr/share/themes
) || fail "WhiteSur GTK install failed."

# --- Libadwaita override (user-local, no sudo) ---
say "Installing libadwaita override (GTK4 apps)"
(
  cd "$WORK_DIR/WhiteSur-gtk-theme"
  ./install.sh -l -c dark -o normal
) || fail "Libadwaita override failed."

# --- WhiteSur icons ---
say "Downloading and installing WhiteSur icons"
git clone --depth=1 "$ICON_REPO" "$WORK_DIR/WhiteSur-icon-theme"
(
  cd "$WORK_DIR/WhiteSur-icon-theme"
  sudo -A ./install.sh -d /usr/share/icons
) || fail "WhiteSur icons install failed."

# --- Apply settings ---
say "Applying appearance settings"
gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark' || true
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur' || true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close' || true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'RIGHT' 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false 2>/dev/null || true

# --- Done ---
say "Done!"
cat <<EOF

Installed:
  • WhiteSur Dark GTK theme  → /usr/share/themes/WhiteSur-Dark
  • WhiteSur icons           → /usr/share/icons/WhiteSur
  • Libadwaita override      → ~/.config/gtk-4.0/
  • Dark mode, right-side buttons (:minimize,maximize,close), dock on right

Backup: $BACKUP_DIR
Log:    $LOG_FILE

NEXT:
  1. Log out and log back in for the full effect.
  2. Optional macOS-style extras (auto-hide top bar, blur, window animations):
       bash extras.sh
EOF
