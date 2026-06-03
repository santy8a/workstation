# Workstation Migration Checklist

Guía para reconstruir mi workstation profesional desde cero.

Este repositorio define mi entorno base como Arquitecto Cloud / IA, usando Windows, WSL Ubuntu, VS Code, Azure, Terraform, AKS, Docker y herramientas de automatización.

---

## 1. Objetivo

El objetivo de este repositorio es poder reconstruir mi entorno de trabajo de forma:

* Repetible
* Documentada
* Controlada
* Segura
* Lo más automatizada posible

La idea principal es:

```text
Windows = plataforma base
WSL Ubuntu = entorno principal de trabajo Cloud/IA
VS Code = editor principal conectado a WSL
GitHub = fuente de verdad del entorno
1Password = gestión de credenciales y secretos
```

---

## 2. Flujo general de instalación

El proceso completo se divide en fases:

```text
Fase 0 - Instalar Git manualmente
Fase 1 - Clonar repositorio workstation
Fase 2 - Ejecutar bootstrap.ps1 para preparar Windows
Fase 3 - Reiniciar Windows si WSL/Docker lo requiere
Fase 4 - Ejecutar install-wsl-ubuntu.ps1 para instalar Ubuntu 24.04
Fase 5 - Abrir Ubuntu y crear usuario Linux
Fase 6 - Ejecutar bootstrap.sh dentro de WSL
Fase 7 - Configurar VS Code, Git, Azure y accesos
```

---

## 3. Fase 0 - Instalar Git manualmente

Git es el único paso manual inicial necesario para poder clonar este repositorio.

Abrir PowerShell y ejecutar:

```powershell
winget install --id Git.Git -e --source winget
```

Cerrar y volver a abrir PowerShell.

Verificar:

```powershell
git --version
```

---

## 4. Fase 1 - Clonar repositorio workstation

Crear estructura base local:

```powershell
mkdir C:\Dev\Personal
cd C:\Dev\Personal
```

Clonar el repositorio:

```powershell
git clone https://github.com/santy8a/workstation.git
cd workstation
```

---

## 5. Fase 2 - Ejecutar bootstrap.ps1

Este script prepara Windows como plataforma base.

Instala, si no existen:

* Git
* VS Code
* Windows Terminal
* PowerShell 7
* Google Chrome
* Azure CLI
* Azure Storage Explorer
* Docker Desktop
* 1Password
* 1Password CLI
* GitHub CLI
* Draw.io Desktop
* Postman
* Microsoft PowerToys

También crea carpetas estándar:

```text
C:\Dev
C:\Dev\Personal
C:\Dev\Cliente
C:\Dev\IA
C:\Dev\Labs
C:\Dev\OpenSource
```

Ejecutar desde la raíz del repositorio:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\bootstrap\bootstrap.ps1
```

---

## 6. Fase 3 - Reiniciar si es necesario

Si durante la instalación de WSL o Docker Desktop Windows solicita reinicio, reiniciar el equipo antes de continuar.

Después del reinicio, volver al repositorio:

```powershell
cd C:\Dev\Personal\workstation
```

---

## 7. Fase 4 - Instalar Ubuntu 24.04 en WSL

Ejecutar:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\bootstrap\install-wsl-ubuntu.ps1
```

Este script:

* Verifica que WSL esté disponible
* Configura WSL2 como versión por defecto
* Instala Ubuntu 24.04 si no existe
* Define Ubuntu 24.04 como distribución por defecto
* Muestra el estado final de WSL

Verificar:

```powershell
wsl -l -v
```

Resultado esperado:

```text
NAME            STATE      VERSION
Ubuntu-24.04    Running    2
```

---

## 8. Fase 5 - Primer arranque de Ubuntu

Abrir Ubuntu 24.04 desde el menú inicio o ejecutar:

```powershell
wsl
```

Crear usuario Linux cuando lo solicite.

Verificar versión:

```bash
cat /etc/os-release
```

Resultado esperado:

```text
Ubuntu 24.04 LTS
```

---

## 9. Fase 6 - Preparar repositorio dentro de WSL

Opción recomendada: trabajar dentro del filesystem Linux, no desde `/mnt/c`.

Crear estructura:

```bash
mkdir -p ~/dev/personal
cd ~/dev/personal
```

Clonar el repositorio:

```bash
git clone https://github.com/santy8a/workstation.git
cd workstation
```

Dar permisos al bootstrap Linux:

```bash
chmod +x bootstrap/bootstrap.sh
```

Ejecutar:

```bash
./bootstrap/bootstrap.sh
```

---

## 10. Fase 7 - Herramientas que instala bootstrap.sh

El script Linux prepara la Landing Zone WSL para trabajo Cloud/IA.

Herramientas principales:

```text
git
azure-cli
terraform
kubectl
kubelogin
helm
gh
jq
yq
k9s
kubectx
kubens
terraform-docs
tflint
python3
pipx
uv
ansible
azd
psql
docker-cli
tree
htop
ripgrep
fzf
bat
direnv
make
curl
wget
zip
unzip
dnsutils
netcat
```

---

## 11. Fase 8 - Configuración Git

Configurar identidad Git:

```bash
git config --global user.name "Santiago Raúl Ochoa"
git config --global user.email "TU_EMAIL"
```

Verificar:

```bash
git config --global --list
```

---

## 12. Fase 9 - VS Code con WSL

Abrir el repositorio desde WSL:

```bash
code .
```

Si no funciona, abrir VS Code en Windows e instalar la extensión:

```text
Remote - WSL
```

Después abrir desde VS Code:

```text
Remote Explorer → WSL → Ubuntu-24.04
```

---

## 13. Fase 10 - Docker Desktop + WSL

Verificar que Docker Desktop tenga integración con Ubuntu 24.04.

En Docker Desktop:

```text
Settings → Resources → WSL Integration → Enable Ubuntu-24.04
```

Desde WSL verificar:

```bash
docker --version
docker ps
```

---

## 14. Fase 11 - Azure CLI

Login:

```bash
az login --use-device-code
```

Verificar:

```bash
az account show
```

Para AKS:

```bash
az aks get-credentials --resource-group <RESOURCE_GROUP> --name <AKS_NAME> --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
kubectl get nodes
```

---

## 15. Fase 12 - Auditoría del entorno

Ejecutar:

```bash
chmod +x scripts/helpers/audit-workstation.sh
./scripts/helpers/audit-workstation.sh
```

Esto genera:

```text
workstation-audit.txt
```

Sirve para revisar qué herramientas están instaladas y sus versiones.

---

## 16. Buenas prácticas

### No instalar herramientas manualmente sin documentarlas

Si necesito una nueva herramienta:

```text
1. Añadirla a bootstrap.sh
2. Documentarla en bootstrap/packages.md
3. Ejecutar bootstrap.sh
4. Probar
5. Hacer commit y push
```

---

### No guardar secretos en Git

Nunca subir:

```text
.env
*.pem
*.key
*.pfx
*.p12
VPN configs
kubeconfig
Azure tokens
SSH private keys
IPs privadas de cliente
DNS internos de cliente
```

Los secretos van en:

```text
1Password
```

---

### No trabajar habitualmente en /mnt/c

Preferencia:

```text
~/dev/personal
~/dev/cliente
~/dev/ia
~/dev/labs
```

Evitar trabajar en:

```text
/mnt/c/...
```

salvo casos puntuales.

---

### Actualizaciones

No actualizar justo antes de una demo, workshop o despliegue importante.

Ciclo recomendado:

```text
Ubuntu packages: mensual
Azure CLI: cada 1-2 meses
Terraform: cada 2-3 meses
kubectl: alineado con versión AKS
Python tooling: según necesidad
```

---

## 17. Comandos Git para guardar cambios

Después de modificar scripts o documentación:

```bash
git status
git add .
git commit -m "Update workstation setup"
git push
```

---

## 18. Filosofía

Este repositorio representa mi workstation como código.

La idea no es recordar cómo configuré mi portátil.

La idea es que el proceso esté versionado, documentado y sea repetible.

```text
Git
↓
workstation
↓
bootstrap.ps1
↓
install-wsl-ubuntu.ps1
↓
bootstrap.sh
↓
Entorno Cloud/IA listo
```
