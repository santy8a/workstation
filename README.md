# Workstation

Personal Cloud & AI Architect workstation configuration.

## Objectives

- Reproducible workstation
- VS Code configuration
- WSL bootstrap
- Terraform tooling
- Kubernetes tooling
- Azure CLI tooling
- AI development environment

## Components

- Windows
- WSL Ubuntu
- VS Code
- Terraform
- Kubectl
- Helm
- Ansible
- Azure CLI
- Docker Desktop
- 1Password

## Quick Start

### Windows

```powershell
# Install Git
winget install --id Git.Git -e --source winget

# Verify installation:
git --version

# Clone Repository
mkdir C:\Dev\Personal
cd C:\Dev\Personal
git clone https://github.com/santy8a/workstation.git
```

### Run bootstrap (Windows)

```powershell
cd workstation
.\bootstrap\bootstrap.ps1
```

### Run bootstrap (WSL):

./bootstrap/bootstrap.sh
