<div align="center">

# 🍎 Ubuntu macOS Theme

**Make Ubuntu look and feel like macOS — in one command.**

[![Platform](https://img.shields.io/badge/platform-Ubuntu%20%7C%20GNOME-orange)](https://ubuntu.com)
[![Theme](https://img.shields.io/badge/theme-WhiteSur-darkgreen)](https://github.com/vinceliuice/WhiteSur-gtk-theme)
[![Shell](https://img.shields.io/badge/script-bash-green)](#)

*Screenshot placeholder — add a screenshot of your themed desktop here.*

</div>

---

## ✨ Features

- ✅ **WhiteSur Dark GTK theme** — macOS Big Sur/Monterey style windows & controls
- ✅ **Traffic-light buttons** — red/yellow/green close/min/max with hover symbols
- ✅ **WhiteSur icon set** — macOS-style app icons (light & dark variants)
- ✅ **Libadwaita override** — modern GNOME apps (Files, Settings, Text Editor) follow the theme
- ✅ **Dark mode** enabled by default
- ✅ **Right-side window buttons** (`:minimize,maximize,close`)
- ✅ **Dock on the right** (Ubuntu Dock, macOS-like)
- ✅ **One-click uninstall** — restores Yaru defaults
- ✅ **Optional extras** — auto-hide top bar, blur, window animations

## 📋 Requirements

- Ubuntu (tested on **26.04 LTS** / GNOME 50) or any Ubuntu-based distro with GNOME
- Internet connection (downloads WhiteSur from GitHub)
- Your password (sudo — installs system-wide for all users + login screen)

## 🚀 Quick Start

```bash
git clone https://github.com/milindweb/ubuntu-macos-theme.git
cd ubuntu-macos-theme
bash install.sh
```

Then **log out and log back in**. That's it.

> A password popup appears if `zenity` is installed; otherwise type your password in the terminal.

## 🔧 What it does

| Component | Location | Scope |
|-----------|----------|-------|
| WhiteSur Dark GTK theme | `/usr/share/themes/WhiteSur-Dark` | All users + login screen |
| WhiteSur icons | `/usr/share/icons/WhiteSur*` | All users |
| Libadwaita override | `~/.config/gtk-4.0/` | Current user |
| Dark mode | `prefer-dark` | Current user |
| Window buttons | `:minimize,maximize,close` (right) | Current user |
| Dock position | Right | Current user |

Your GNOME settings are **backed up** before any change (`~/.local/share/ubuntu-macos-theme-backup-*/`).

## 📦 Files

| File | Purpose |
|------|---------|
| `install.sh` | Full setup — theme, icons, libadwaita, settings |
| `extras.sh` | **Optional** — auto-hide top bar, blur, window animations |
| `update.sh` | Re-fetch latest WhiteSur from GitHub and reinstall |
| `uninstall.sh` | Remove everything and restore Yaru defaults |

## 🎨 Optional macOS-style extras

Adds the finishing touches (auto-hide top bar, blur behind the bar/overview, window open/close animations):

```bash
bash extras.sh
```

Installs these GNOME Extensions (user-local, no sudo):

| Extension | What it does |
|-----------|--------------|
| [hidetopbar](https://extensions.gnome.org/extension/545/hide-top-bar/) | Top bar auto-hides; reveal by moving mouse to the top edge |
| [blur-my-shell](https://extensions.gnome.org/extension/3193/blur-my-shell/) | macOS-style blur behind the top bar and overview |
| [burn-my-windows](https://extensions.gnome.org/extension/3760/burn-my-windows/) | Fancy window open/close animations |

Manage them later in the **Extensions** app.

## 🗑️ Uninstall

```bash
bash uninstall.sh
```

Removes the theme, icons, and libadwaita override; restores the default Yaru theme.

## 🎛️ Customization

The installer uses WhiteSur **Dark** + **normal opacity** by default. To customize, run the WhiteSur installer directly:

```bash
cd /tmp
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
./install.sh --dialog          # GUI popups — easiest for beginners
```

Popular options:

| Option | Effect |
|--------|--------|
| `-c light` / `-c dark` | Light or dark theme |
| `-t blue` / `-t pink` / `-t green` … | Accent color |
| `-o solid` | No transparency |
| `-m` | macOS Monterey style |
| `--round` | Rounded maximized windows |
| `-a alt` | Alternative button style |

See all options: `./install.sh --help`

## 🛠️ Troubleshooting

### Theme doesn't fully apply
**Log out and log back in.** GNOME caches themes aggressively.

### GNOME Tweaks (manual control)
Open **Tweaks → Appearance**:
- **Themes** → GTK = `WhiteSur-Dark`, Icons = `WhiteSur`
- **Window Titlebars** → toggle button position

### Top bar / shell theme (menus, overview)
1. Install the **User Themes** extension: https://extensions.gnome.org/extension/19/user-themes/
2. **Tweaks → Appearance → Shell** → select **WhiteSur-Dark**

### Buttons don't show hover symbols (× − +)
Reinstall all button variants:
```bash
cd /tmp/WhiteSur-gtk-theme
./install.sh -a all -c dark -o normal -l
```
Then log out/in.

### Snap / Flatpak apps not themed
Snaps and Flatpaks sandbox their themes. Install the theme inside the sandbox or use the deb/flatpak native version of the app.

### Electron / Firefox apps
These use their own titlebars and won't fully match. This is a known limitation.

## 🙏 Credits

This project packages the incredible work of:

- **[WhiteSur GTK](https://github.com/vinceliuice/WhiteSur-gtk-theme)** by [vinceliuice](https://github.com/vinceliuice)
- **[WhiteSur Icons](https://github.com/vinceliuice/WhiteSur-icon-theme)** by [vinceliuice](https://github.com/vinceliuice)
- **[GNOME Extensions](https://extensions.gnome.org)** community — hidetopbar, blur-my-shell, burn-my-windows

Please star those projects if you like this theme!

## 📄 License

Free to use, modify, and share. A star on the repo is appreciated!
