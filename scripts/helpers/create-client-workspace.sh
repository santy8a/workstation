#!/usr/bin/env bash

set -euo pipefail

CLIENT_NAME="${1:-}"

if [[ -z "$CLIENT_NAME" ]]; then
  echo "Usage: $0 <client-name>"
  echo "Example: $0 cliente-actual"
  exit 1
fi

BASE_DIR="$HOME/dev/clients/$CLIENT_NAME"

echo "Creating client workspace: $BASE_DIR"

mkdir -p "$BASE_DIR"/{
  00_context,
  01_repos,
  02_iac,
  03_kubernetes,
  04_scripts,
  05_docs,
  06_diagrams,
  07_pocs,
  08_meetings,
  09_operations,
  99_archive
}

cat > "$BASE_DIR/README.md" <<EOF
# $CLIENT_NAME

Client technical workspace.

## Structure

- \`00_context\` - General technical context, environments, naming, access notes without secrets.
- \`01_repos\` - Cloned client repositories.
- \`02_iac\` - Terraform, Bicep, Ansible and infrastructure analysis.
- \`03_kubernetes\` - AKS, kubectl, Helm, manifests and troubleshooting.
- \`04_scripts\` - Helper scripts for this client.
- \`05_docs\` - Technical markdown notes.
- \`06_diagrams\` - Local diagrams and drafts.
- \`07_pocs\` - Proofs of concept and experiments.
- \`08_meetings\` - Technical meeting notes.
- \`09_operations\` - Operational commands, runbooks and known issues.
- \`99_archive\` - Deprecated or old material.

## Important

Do not store secrets, kubeconfigs, private keys, tokens or customer-sensitive data here unless the location is private and properly protected.
EOF

touch "$BASE_DIR/00_context/environments.md"
touch "$BASE_DIR/00_context/access-notes.md"
touch "$BASE_DIR/05_docs/notes.md"
touch "$BASE_DIR/09_operations/commands.md"
touch "$BASE_DIR/09_operations/known-issues.md"

echo "Client workspace created successfully:"
echo "$BASE_DIR"
