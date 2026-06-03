#!/usr/bin/env bash

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

new-client() {
  local name="$1"

  if [ -z "$name" ]; then
    echo "Uso: new-client <client-name>"
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

az-whoami() {
  az account show --output table
}

az-sub() {
  az account list --output table
  echo ""
  echo "Uso para cambiar:"
  echo "az account set --subscription <subscription-id-or-name>"
}

aks-creds() {
  if [ "$#" -ne 2 ]; then
    echo "Uso: aks-creds <resource-group> <aks-name>"
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
