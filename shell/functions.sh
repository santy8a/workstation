#!/usr/bin/env bash

# ------------------------------------------------------------
# Navigation
# ------------------------------------------------------------

croot() {
  cd "$HOME/dev/clients" || return
}

personal() {
  cd "$HOME/dev/personal" || return
}

ia() {
  cd "$HOME/dev/ia" || return
}

labs() {
  cd "$HOME/dev/labs" || return
}

# ------------------------------------------------------------
# Client workspace
# ------------------------------------------------------------

new-client() {
  local name="${1:-}"

  if [ -z "$name" ]; then
    echo "Usage: new-client <client-name>"
    echo "Example: new-client contoso"
    return 1
  fi

  local base="$HOME/dev/clients/$name"

  mkdir -p "$base"/{00_context,01_repos,02_iac,03_kubernetes,04_scripts,05_docs,06_diagrams,07_pocs,08_meetings,09_operations,99_archive}

  cat > "$base/README.md" <<EOF
# $name

Client technical workspace.

## Structure

- 00_context
- 01_repos
- 02_iac
- 03_kubernetes
- 04_scripts
- 05_docs
- 06_diagrams
- 07_pocs
- 08_meetings
- 09_operations
- 99_archive
EOF

  echo "Client workspace created: $base"
}

validate-client() {
  local client="${1:-}"
  local client_dir="$HOME/dev/clients/$client"

  if [ -z "$client" ]; then
    echo "[ERROR] Client name is required"
    return 1
  fi

  if [ ! -d "$client_dir" ]; then
    echo "[ERROR] Client not found: $client"
    echo ""
    echo "Available clients:"
    ls "$HOME/dev/clients" 2>/dev/null || true
    return 1
  fi
}

# ------------------------------------------------------------
# Azure / AKS
# ------------------------------------------------------------

az-whoami() {
  az account show --output table
}

az-sub() {
  az account list --output table
  echo ""
  echo "Usage to change subscription:"
  echo "az account set --subscription <subscription-id-or-name>"
}

aks-creds() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: aks-creds <resource-group> <aks-name>"
    return 1
  fi

  az aks get-credentials \
    --resource-group "$1" \
    --name "$2" \
    --overwrite-existing

  kubelogin convert-kubeconfig -l azurecli
}

kctx() {
  kubectl config get-contexts
}

kns() {
  kubectl get namespaces
}

kpods() {
  kubectl get pods -A
}

# ------------------------------------------------------------
# Terraform
# ------------------------------------------------------------

tf-clean() {
  rm -rf .terraform
  rm -f terraform.tfstate.backup
  rm -f tfplan
  echo "Terraform local files cleaned."
}

tf-reinit() {
  tf-clean
  terraform init
}

tf-plan-save() {
  terraform plan -out=tfplan
}

# ------------------------------------------------------------
# Runbooks
# ------------------------------------------------------------

runbook() {
  local name="${1:-}"

  if [ -z "$name" ]; then
    echo "Usage: runbook <name>"
    echo "Example: runbook ssh-setup"
    return 1
  fi

  local logs_dir="$HOME/dev/personal/notes/runbooks/logs"
  mkdir -p "$logs_dir"

  local timestamp
  timestamp="$(date +%F-%H%M%S)"

  local logfile="$logs_dir/${name}-${timestamp}.log"
  local rcfile
  rcfile="$(mktemp)"

  cat > "$rcfile" <<EOF
source ~/.bashrc
PS1="[RUNBOOK:${name}] \u@\h:\w\$ "
EOF

  echo ""
  echo "Starting runbook session:"
  echo "$logfile"
  echo ""
  echo "You are about to enter a recorded shell session."
  echo "Type 'exit' to finish and save the log."
  echo ""

  script "$logfile" -c "bash --rcfile $rcfile"

  rm -f "$rcfile"
}

# ------------------------------------------------------------
# SSH identities
# ------------------------------------------------------------

ssh-load() {
  local key="${1:-}"

  if [ -z "$key" ]; then
    echo "Usage: ssh-load <key>"
    echo "Example: ssh-load id_ed25519_contoso"
    return 1
  fi

  local key_path="$HOME/.ssh/$key"

  if [ ! -f "$key_path" ]; then
    echo "[ERROR] SSH key not found:"
    echo "  $key_path"
    return 1
  fi

  ssh-add "$key_path"
}

ssh-client() {
  local client="${1:-}"

  if [ -z "$client" ]; then
    echo "Usage: ssh-client <client>"
    echo "Example: ssh-client contoso"
    return 1
  fi

  ssh-load "id_ed25519_${client}"
}

sshc() {
  ssh-client "$@"
}

ssh-keys() {
  ssh-add -l
}

# ------------------------------------------------------------
# Client VPN helpers
# ------------------------------------------------------------

vpn-up() {
  local client="${1:-}"

  if [ -z "$client" ]; then
    echo "Usage: vpn-up <client>"
    echo "Example: vpn-up contoso"
    return 1
  fi

  validate-client "$client" || return 1

  local client_dir="$HOME/dev/clients/$client"

  "$client_dir/04_scripts/vpn/apply-hosts.sh"
  "$client_dir/04_scripts/vpn/start-wsl-tunnel.sh"
}

vpn-down() {
  local client="${1:-}"

  if [ -z "$client" ]; then
    echo "Usage: vpn-down <client>"
    echo "Example: vpn-down contoso"
    return 1
  fi

  validate-client "$client" || return 1

  local client_dir="$HOME/dev/clients/$client"

  "$client_dir/04_scripts/vpn/stop-wsl-tunnel.sh"
  "$client_dir/04_scripts/vpn/remove-hosts.sh"
}

vpn-status() {
  local client="${1:-}"

  if [ -z "$client" ]; then
    echo "Usage: vpn-status <client>"
    echo "Example: vpn-status contoso"
    return 1
  fi

  validate-client "$client" || return 1

  local client_dir="$HOME/dev/clients/$client"

  "$client_dir/04_scripts/vpn/status-wsl-tunnel.sh"
}
