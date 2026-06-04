# VSCode Guide

## Objetivo

Este documento describe cómo configurar, utilizar y mantener Visual Studio Code dentro de la Workstation.

La filosofía seguida es:

```text
VSCode as Code
```

Es decir:

* Configuración versionada.
* Configuración reproducible.
* Configuración documentada.
* Configuración reconstruible en cualquier equipo.

---

# Arquitectura objetivo

```text
Windows
│
├── VSCode
│
└── WSL
    └── Ubuntu-24.04
```

VSCode se ejecuta en Windows.

Las herramientas de desarrollo se ejecutan en Ubuntu.

Ejemplos:

```text
Terraform
Azure CLI
kubectl
Helm
Ansible
Python
Git
```

Todo el desarrollo diario debe realizarse desde WSL.

---

# Primera conexión de VSCode con WSL

## Objetivo

Conectar Visual Studio Code instalado en Windows con la distribución Linux Ubuntu ejecutándose dentro de WSL.

Esta operación debe realizarse una única vez por cada instalación nueva de Windows o VSCode.

---

## ¿Por qué es necesario?

Aunque VSCode está instalado en Windows, el desarrollo diario se realiza dentro de WSL.

Cuando se realiza la primera conexión, VSCode instala automáticamente un componente adicional dentro de Ubuntu llamado:

```text
VSCode Server
```

Este componente permite:

* Abrir carpetas Linux directamente desde VSCode.
* Utilizar terminales Linux integradas.
* Ejecutar extensiones dentro de WSL.
* Trabajar con Terraform, Kubernetes, Azure CLI, Python y otras herramientas instaladas en Ubuntu.

---

## Requisitos previos

Verificar:

* VSCode instalado.
* Extensión Remote WSL instalada.
* Ubuntu-24.04 instalada y funcionando.

Comprobar:

```powershell
code --list-extensions
```

Debe aparecer:

```text
ms-vscode-remote.remote-wsl
```

---

## Procedimiento

Abrir Visual Studio Code.

Abrir la paleta de comandos:

```text
Ctrl + Shift + P
```

Buscar:

```text
WSL: Connect to WSL using Distro...
```

Seleccionar:

```text
Ubuntu-24.04
```

Esperar a que VSCode complete la instalación automática del servidor remoto.

Durante este proceso VSCode instalará:

```text
~/.vscode-server
```

dentro de Ubuntu.

La primera vez puede tardar varios minutos dependiendo de la conexión de red.

---

## Verificación

La conexión se considera correcta cuando en la esquina inferior izquierda aparece:

```text
WSL: Ubuntu-24.04
```

---

## Validación desde Ubuntu

Abrir una terminal WSL.

Ejecutar:

```bash
code .
```

Si VSCode se abre mostrando el contenido de la carpeta actual y mantiene el indicador:

```text
WSL: Ubuntu-24.04
```

la integración se ha realizado correctamente.

---

## ¿Qué ocurre internamente?

Durante la primera conexión VSCode:

1. Detecta la distribución Ubuntu.
2. Instala VSCode Server en:

```text
~/.vscode-server
```

3. Configura la comunicación entre Windows y WSL.
4. Registra el comando:

```bash
code .
```

para poder abrir proyectos Linux directamente desde la terminal.

---

## Cuándo repetir este procedimiento

Realizar nuevamente este procedimiento únicamente cuando:

* Se reinstale Windows.
* Se cambie de portátil.
* Se reinstale VSCode.
* Se elimine la distribución Ubuntu y se cree una nueva.

No es necesario repetirlo en el uso diario.

---

# Gestión de configuración de VSCode

## Filosofía

La configuración de VSCode no debe mantenerse manualmente.

La fuente de verdad es siempre el repositorio Workstation.

---

## Configuración versionada

Ubicación:

```text
workstation/
└── vscode/
    ├── settings.json
    ├── extensions-windows.txt
    ├── extensions-wsl.txt
    ├── keybindings.json
    └── snippets/
```

Todo cambio permanente debe realizarse aquí.

---

## Configuración activa

Cuando VSCode está conectado a WSL utiliza:

```text
~/.vscode-server/data/Machine/settings.json
```

Por ejemplo:

```text
/home/santiago/.vscode-server/data/Machine/settings.json
```

Este fichero es el que realmente utiliza VSCode.

---

# Extensiones VSCode

## Extensiones Windows

Se instalan mediante:

```powershell
bootstrap.ps1
```

Archivo de referencia:

```text
vscode/extensions-windows.txt
```

Extensiones actuales:

```text
ms-vscode-remote.remote-wsl
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-containers
ms-vscode.remote-explorer
```

Estas extensiones permiten la conexión con WSL.

---

## Extensiones WSL

Se instalan mediante:

```bash
bootstrap/install-vscode-wsl.sh
```

Archivo de referencia:

```text
vscode/extensions-wsl.txt
```

Extensiones actuales:

```text
eamodio.gitlens
github.vscode-github-actions
hashicorp.terraform
ms-azuretools.vscode-azureresourcegroups
oderwat.indent-rainbow
```

Estas extensiones se ejecutan dentro de Ubuntu.

---

# Instalación automática

Script:

```text
bootstrap/install-vscode-wsl.sh
```

Responsabilidades:

1. Instalar extensiones WSL.
2. Aplicar settings.
3. Preparar entorno VSCode remoto.

Ejecución:

```bash
./bootstrap/install-vscode-wsl.sh
```

---

# Verificación de configuración

## Comparar configuración activa y versionada

```bash
diff \
  ~/dev/personal/workstation/vscode/settings.json \
  ~/.vscode-server/data/Machine/settings.json
```

Resultado esperado:

```text
Sin salida
```

Si no aparece ninguna diferencia ambos ficheros son idénticos.

---

## Comprobar configuración activa

Abrir:

```text
Ctrl + Shift + P
Preferences: Open Settings (JSON)
```

El contenido debe coincidir con:

```text
~/.vscode-server/data/Machine/settings.json
```

---

## Verificar VSCode Server

```bash
code --status
```

Permite comprobar:

* Estado del servidor remoto.
* Procesos asociados.
* Extensiones cargadas.
* Conexión Windows ↔ WSL.

---

# Validaciones funcionales

## Format On Save

Abrir un fichero.

Modificar formato.

Guardar.

Resultado esperado:

```text
VSCode reformatea automáticamente el fichero.
```

---

## Terraform

Abrir:

```text
main.tf
```

Verificar:

* Autocompletado.
* Validación.
* Navegación.
* Ayuda contextual.

---

## Terminal Linux

Abrir:

```text
Terminal → New Terminal
```

Resultado esperado:

```bash
bash
```

---

# Terraform y terraform-docs

## Configuración global

La configuración global de VSCode debe mantenerse mínima.

No se ejecutará automáticamente:

```text
terraform-docs
```

desde el settings global.

---

## Configuración por proyecto

Los repositorios que requieran:

```text
terraform fmt
terraform-docs
```

automáticos deben definirlo mediante:

```text
.vscode/settings.json
```

dentro del propio repositorio.

Esto evita afectar a proyectos que no siguen la misma estructura.

---

# Buenas prácticas

## Nunca modificar directamente

```text
~/.vscode-server/data/Machine/settings.json
```

Los cambios permanentes deben realizarse en:

```text
workstation/vscode/settings.json
```

Posteriormente:

```bash
git add .
git commit
git push
```

y volver a ejecutar:

```bash
./bootstrap/install-vscode-wsl.sh
```

---

## Automatizar todo lo posible

Automatizar:

* Instalación de extensiones.
* Aplicación de settings.
* Snippets.
* Keybindings.

Documentar claramente cualquier paso manual.

---

# Regla de la Workstation

Si una configuración es importante:

```text
No debe vivir únicamente en VSCode.
Debe vivir en Git.
```

De esta forma cualquier portátil nuevo puede reconstruirse completamente a partir del repositorio Workstation.
