# Workstation

Personal Cloud, Platform & AI Architect Workstation.

The goal of this repository is to manage the entire development environment as code, making it reproducible, documented and version-controlled.

---

# Principles

This workstation follows four core principles:

* Infrastructure as Code
* Configuration as Code
* Documentation as Code
* Workstation as Code

Any configuration that is important should:

1. Be version-controlled.
2. Be documented.
3. Be reproducible.
4. Be automated whenever possible.

---

# Architecture

```text
Windows
│
├── VSCode
├── Windows Terminal
├── Git
└── WSL

WSL
│
├── Ubuntu 24.04
├── Terraform
├── Azure CLI
├── kubectl
├── Helm
├── Ansible
├── Python
└── GitHub CLI
```

Development is performed inside WSL.

VSCode acts as the primary IDE and connects to Ubuntu through Remote WSL.

---

# Components

## Windows

* Visual Studio Code
* Windows Terminal
* Git
* PowerShell 7
* Docker Desktop
* Azure CLI
* Storage Explorer
* GitHub CLI
* 1Password
* Draw.io
* Postman
* PowerToys
* Notepad++
* Greenshot
* PuTTY
* Wireshark

## WSL

* Ubuntu 24.04
* Terraform
* Azure CLI
* kubectl
* Helm
* Ansible
* Python
* pipx
* uv

---

# Repository Structure

```text
workstation/
├── bootstrap/
├── docs/
├── scripts/
├── shell/
├── vscode/
└── templates/
```

| Directory  | Purpose                                       |
| ---------- | --------------------------------------------- |
| bootstrap/ | Operating system and workstation provisioning |
| docs/      | Documentation and operational guides          |
| scripts/   | Reusable automation scripts                   |
| shell/     | Shell profile, aliases and functions          |
| vscode/    | VSCode settings, extensions and templates     |
| templates/ | Reusable project and workspace templates      |

---

# Quick Start

## Windows

Clone repository:

```powershell
mkdir C:\Dev\Personal
cd C:\Dev\Personal

git clone https://github.com/santy8a/workstation.git

cd workstation
```

Run Windows bootstrap:

```powershell
.\bootstrap\bootstrap.ps1
```

---

## Ubuntu / WSL

Install Ubuntu:

```powershell
.\bootstrap\install-wsl-ubuntu.ps1
```

Open Ubuntu and execute:

```bash
./bootstrap/bootstrap.sh
```

---

## VSCode

Connect VSCode to Ubuntu:

```text
Ctrl + Shift + P
WSL: Connect to WSL using Distro...
Ubuntu-24.04
```

Install VSCode WSL configuration:

```bash
./bootstrap/install-vscode-wsl.sh
```

---

# Documentation

The workstation is fully documented.

## Core Guides

| Document                                              | Purpose                                                                        |
| ----------------------------------------------------- | ------------------------------------------------------------------------------ |
| [migration-checklist.md](docs/migration-checklist.md) | Windows to Linux migration process and validation steps                        |
| [vscode-guide.md](docs/vscode-guide.md)               | VSCode, WSL integration, extensions and configuration management               |
| [naming-conventions.md](docs/naming-conventions.md)   | Naming standards for clients, repositories, scripts, directories and functions |

---

# Naming Standards

The workstation follows documented naming conventions.

Examples:

```text
Clients      → eco, mappre, telefonia
Directories  → kebab-case
Scripts      → kebab-case
Functions    → snake_case
Repositories → original repository name
```

See:

```text
docs/naming-conventions.md
```

for the complete standard.

---

# Current Status

Managed and versioned:

* Windows bootstrap
* Ubuntu bootstrap
* Shell profile
* Shell aliases
* Shell functions
* VSCode settings
* VSCode extensions
* Documentation
* Naming conventions

Future areas:

* Snippets
* Keybindings
* Client templates
* Terraform workspace templates
* AI development tooling

---

# Philosophy

The workstation itself is treated as a product.

Every improvement should be:

```text
Documented
Versioned
Automated
Reusable
```
