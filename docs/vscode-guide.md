# Primera conexión de VSCode con WSL

## Objetivo

Conectar Visual Studio Code instalado en Windows con la distribución Linux Ubuntu ejecutándose dentro de WSL.

Esta operación debe realizarse una única vez por cada instalación nueva de Windows o VSCode.

---

# ¿Por qué es necesario?

Aunque VSCode está instalado en Windows, el desarrollo diario se realiza dentro de WSL.

La arquitectura objetivo es:

```text
Windows
│
├── VSCode
│
└── WSL
    └── Ubuntu-24.04
```

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

# Requisitos previos

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

# Procedimiento

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

# Verificación

La conexión se considera correcta cuando en la esquina inferior izquierda aparece:

```text
WSL: Ubuntu-24.04
```

Ejemplo:

```text
┌──────────────────────┐
│ WSL: Ubuntu-24.04    │
└──────────────────────┘
```

---

# Validación desde Ubuntu

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

# ¿Qué ocurre internamente?

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

# Cuándo repetir este procedimiento

Realizar nuevamente este procedimiento únicamente cuando:

* Se reinstale Windows.
* Se cambie de portátil.
* Se reinstale VSCode.
* Se elimine la distribución Ubuntu y se cree una nueva.

No es necesario repetirlo en el uso diario.

---

# Resultado esperado

Después de completar este procedimiento:

```text
VSCode (Windows)
        │
        ▼
WSL Remote
        │
        ▼
Ubuntu 24.04
        │
        ├── Terraform
        ├── Azure CLI
        ├── kubectl
        ├── Helm
        ├── Ansible
        └── Python
```

A partir de este momento todo el desarrollo debe realizarse desde WSL y no desde carpetas locales de Windows.
