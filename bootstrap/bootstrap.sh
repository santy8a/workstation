#!/usr/bin/env bash

set -euo pipefail

echo "======================================"
echo "WSL Bootstrap - Cloud / AI Architect"
echo "======================================"

if [[ "$EUID" -eq 0 ]]; then
  echo "No ejecutes este script como root. Ejecútalo con tu usuario normal."
  exit 1
fi

log() {
  echo ""
  echo "==> $1"
}

is_installed() {
  command -v "$1" >/dev/null 2>&1
}

is_linux_binary() {
  local tool="$1"
  local path

  path="$(command -v "$tool" 2>/dev/null || true)"

  [[ -n "$path" && "$path" != /mnt/c/* ]]
}

install_apt_package() {
  local package="$1"

  if dpkg -s "$package" >/dev/null 2>&1; then
    echo "[OK] $package ya está instalado"
  else
    echo "[INSTALL] $package"
    sudo apt-get install -y "$package"
  fi
}

log "Actualizando sistema base"
sudo apt-get update -y

log "Instalando utilidades base"
BASE_PACKAGES=(
  ca-certificates
  curl
  wget
  gnupg
  lsb-release
  apt-transport-https
  software-properties-common
  unzip
  zip
  git
  jq
  tree
  htop
  make
  build-essential
  dnsutils
  netcat-openbsd
  ripgrep
  fzf
  bat
  direnv
  postgresql-client
  python3
  python3-pip
  python3-venv
)

for package in "${BASE_PACKAGES[@]}"; do
  install_apt_package "$package"
done

# Ubuntu puede instalar bat como batcat. Creamos un wrapper compatible.
if ! is_installed bat && is_installed batcat; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  export PATH="$HOME/.local/bin:$PATH"
  echo "[OK] Alias binario bat -> batcat creado"
fi

log "Instalando Azure CLI Linux"

if is_linux_binary az; then
  echo "[OK] Azure CLI Linux ya está instalado: $(command -v az)"
else
  echo "[INSTALL] Azure CLI Linux"
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  hash -r
fi

log "Instalando Terraform"
if is_installed terraform; then
  echo "[OK] Terraform ya está instalado"
else
  wget -O- https://apt.releases.hashicorp.com/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

  sudo apt-get update -y
  sudo apt-get install -y terraform
fi

log "Instalando kubectl"
if is_linux_binary kubectl; then
  echo "[OK] kubectl Linux ya está instalado: $(command -v kubectl)"
else
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  rm -f kubectl
fi

log "Instalando kubelogin Linux"
if is_linux_binary kubelogin; then
  echo "[OK] kubelogin Linux ya está instalado: $(command -v kubelogin)"
else
  echo "[INSTALL] kubelogin Linux"

  KUBELOGIN_VERSION="$(curl -s https://api.github.com/repos/Azure/kubelogin/releases/latest | jq -r '.tag_name')"

  curl -Lo kubelogin.zip \
    "https://github.com/Azure/kubelogin/releases/download/${KUBELOGIN_VERSION}/kubelogin-linux-amd64.zip"

  unzip -o kubelogin.zip -d kubelogin-tmp

  sudo install -m 0755 \
    kubelogin-tmp/bin/linux_amd64/kubelogin \
    /usr/local/bin/kubelogin

  rm -rf kubelogin.zip kubelogin-tmp
fi

log "Instalando Helm"
if is_linux_binary helm; then
  echo "[OK] Helm Linux ya está instalado: $(command -v helm)"
else
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

log "Instalando GitHub CLI"
if is_linux_binary gh; then
  echo "[OK] GitHub CLI Linux ya está instalado: $(command -v gh)"
else
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

  sudo apt-get update -y
  sudo apt-get install -y gh
fi

log "Instalando yq"
if is_linux_binary yq; then
  echo "[OK] yq Linux ya está instalado: $(command -v yq)"
else
  sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    -O /usr/local/bin/yq
  sudo chmod +x /usr/local/bin/yq
fi

log "Instalando k9s"
if is_linux_binary k9s; then
  echo "[OK] k9s Linux ya está instalado: $(command -v k9s)"
else
  K9S_VERSION="$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq -r '.tag_name')"
  curl -Lo k9s.tar.gz "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz"
  tar -xzf k9s.tar.gz k9s
  sudo install -m 0755 k9s /usr/local/bin/k9s
  rm -f k9s k9s.tar.gz
fi

log "Instalando kubectx y kubens"
if is_linux_binary kubectx && is_linux_binary kubens; then
  echo "[OK] kubectx/kubens ya están instalados"
else
  if [[ ! -d /opt/kubectx ]]; then
    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
  fi
  sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
  sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens
fi

log "Instalando terraform-docs"
if is_linux_binary terraform-docs; then
  echo "[OK] terraform-docs ya está instalado: $(command -v terraform-docs)"
else
  curl -sSLo terraform-docs.tar.gz https://terraform-docs.io/dl/v0.19.0/terraform-docs-v0.19.0-linux-amd64.tar.gz
  tar -xzf terraform-docs.tar.gz
  sudo install -m 0755 terraform-docs /usr/local/bin/terraform-docs
  rm -f terraform-docs terraform-docs.tar.gz
fi

log "Instalando tflint"
if is_linux_binary tflint; then
  echo "[OK] tflint ya está instalado: $(command -v tflint)"
else
  curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
fi

log "Instalando pipx"
if is_installed pipx; then
  echo "[OK] pipx ya está instalado"
else
  install_apt_package pipx
fi

pipx ensurepath || true
export PATH="$HOME/.local/bin:$PATH"

log "Instalando uv"
if is_linux_binary uv; then
  echo "[OK] uv ya está instalado: $(command -v uv)"
else
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

log "Instalando Ansible mediante pipx"
if is_linux_binary ansible; then
  echo "[OK] Ansible ya está instalado: $(command -v ansible)"
else
  pipx install --include-deps ansible
fi

log "Instalando Azure Developer CLI azd"
if is_linux_binary azd; then
  echo "[OK] azd ya está instalado: $(command -v azd)"
else
  curl -fsSL https://aka.ms/install-azd.sh | bash
fi

log "Configurando shell profile"
WORKSTATION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! grep -q "workstation/shell/profile.sh" ~/.bashrc 2>/dev/null; then
  cat <<EOF >> ~/.bashrc

# Workstation shell profile
if [ -f "$WORKSTATION_DIR/shell/profile.sh" ]; then
  source "$WORKSTATION_DIR/shell/profile.sh"
fi
EOF
  echo "[OK] profile.sh añadido a ~/.bashrc"
else
  echo "[OK] profile.sh ya estaba referenciado en ~/.bashrc"
fi

hash -r

log "Verificación final"

TOOLS=(
  git
  gh
  az
  terraform
  kubectl
  kubelogin
  helm
  jq
  yq
  k9s
  kubectx
  kubens
  terraform-docs
  tflint
  psql
  python3
  pipx
  uv
  ansible
  azd
  docker
  bat
)

for tool in "${TOOLS[@]}"; do
  if is_installed "$tool"; then
    echo "[OK] $tool -> $(command -v "$tool")"
  else
    echo "[MISSING] $tool"
  fi
done

echo ""
echo "=== Linux Native Validation ==="

for tool in az kubectl kubelogin helm gh yq k9s terraform-docs tflint azd; do
  path="$(command -v "$tool" 2>/dev/null || true)"

  if [[ -z "$path" ]]; then
    echo "[MISSING] $tool"
  elif [[ "$path" == /mnt/c/* ]]; then
    echo "[WARN] $tool está usando binario Windows: $path"
  else
    echo "[OK] $tool usa binario Linux: $path"
  fi
done

echo ""
echo "Bootstrap Linux finalizado."
echo "Cierra y vuelve a abrir WSL para cargar PATH, pipx, uv y profile.sh."
