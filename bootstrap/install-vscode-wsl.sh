#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

EXTENSIONS_FILE="$REPO_ROOT/vscode/extensions-wsl.txt"

echo "Installing VSCode WSL extensions..."

while read -r extension; do

    [ -z "$extension" ] && continue

    echo "Installing: $extension"

    code --install-extension "$extension"

done < "$EXTENSIONS_FILE"

echo ""
echo "VSCode WSL extensions installed."