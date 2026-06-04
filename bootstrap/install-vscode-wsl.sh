#!/usr/bin/env bash

set -euo pipefail

echo ""
echo "======================================="
echo "VSCode WSL Configuration"
echo "======================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

SETTINGS_FILE="$REPO_ROOT/vscode/settings.json"
EXTENSIONS_FILE="$REPO_ROOT/vscode/extensions-wsl.txt"

#
# Install extensions
#

echo "Installing VSCode extensions..."

while read -r extension; do

    [ -z "$extension" ] && continue

    echo "Installing: $extension"

    code --install-extension "$extension"

done < "$EXTENSIONS_FILE"

#
# Settings
#

echo ""
echo "Installing VSCode settings..."

mkdir -p ~/.vscode-server/data/Machine

cp \
    "$SETTINGS_FILE" \
    ~/.vscode-server/data/Machine/settings.json

echo ""
echo "VSCode WSL configuration completed."