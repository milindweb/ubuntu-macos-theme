#!/usr/bin/env bash
set -Eeuo pipefail

# Remove WhiteSur theme, icons, and libadwaita override; restore Yaru defaults.
# Usage: bash uninstall.sh

say() { printf '\n\033[1;36m%s\033[0m\n' "$*"; }

sudo_setup() {
  if sudo -n true 2>/dev/null; then return 0; fi
  if command -v zenity >/dev/null 2>&1; then
    cat > /tmp/opencode-askpass.sh <<'EOF'
#!/usr/bin/env bash
zenity --password --title="Ubuntu macOS Theme — sudo password required"
EOF
    chmod +x /tmp/opencode-askpass.sh
    export SUDO_ASKPASS=/tmp/opencode-askpass.sh
    sudo -A true || { echo "Wrong password."; exit 1; }
  else
    sudo -v || { echo "sudo required."; exit 1; }
  fi
}

say "Removing Ubuntu macOS theme (WhiteSur)"

sudo_setup

say "Removing system themes"
sudo -A rm -rf /usr/share/themes/WhiteSur*

say "Removing system icons"
sudo -A rm -rf /usr/share/icons/WhiteSur*

say "Removing libadwaita override"
rm -rf ~/.config/gtk-4.0/{gtk.css,gtk-dark.css,gtk-Light.css,gtk-Dark.css,assets,windows-assets}

say "Restoring Yaru defaults"
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru' || true
gsettings set org.gnome.desktop.interface icon-theme 'Yaru' || true
gsettings set org.gnome.desktop.interface color-scheme 'default' || true
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close' || true

say "Done! Theme removed and defaults restored. Log out/in for full effect."
