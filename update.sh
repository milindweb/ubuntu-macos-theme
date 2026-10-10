#!/usr/bin/env bash
set -Eeuo pipefail

# Update WhiteSur theme & icons to latest from GitHub (system-wide).
# Usage: bash update.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Running full reinstall with latest sources..."
bash "$SCRIPT_DIR/install.sh"
echo
echo "Update complete. Log out and back in if the theme looks unchanged."
