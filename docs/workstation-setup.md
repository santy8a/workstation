# Configuración inicial de Git

## Configuración global

Configurar la identidad personal por defecto para todos los repositorios:

```bash
git config --global user.name "Santiago Ochoa"
git config --global user.email "sr.santiochoa@gmail.com"

git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.editor "code --wait"

git config --global core.autocrlf input
```

Verificar la configuración:

```bash
git config --global --list
```

Resultado esperado:

```text
core.autocrlf=input
core.editor=code --wait
user.name=Santiago Ochoa
user.email=sr.santiochoa@gmail.com
init.defaultbranch=main
pull.rebase=false
```

---

## Autenticación GitHub

La workstation utiliza GitHub CLI para autenticación.

Comprobar instalación:

```bash
gh --version
```

Iniciar sesión:

```bash
gh auth login
```

Opciones recomendadas:

```text
GitHub.com
HTTPS
Login with a web browser
```

Verificar autenticación:

```bash
gh auth status
```

---

## Estrategia de identidades Git

Configuración global:

* Identidad personal por defecto.

Repositorios corporativos o de clientes:

```bash
git config user.name "Nombre deseado"
git config user.email "correo@empresa.com"
```

Sin utilizar `--global`.

Esto permite utilizar distintas identidades según el repositorio.

---

## Configuración de finales de línea

La workstation utiliza:

```bash
git config --global core.autocrlf input
```

y el fichero:

```text
.gitattributes
```

para garantizar:

* Scripts Linux (`.sh`) → LF
* PowerShell (`.ps1`) → CRLF

Evita errores del tipo:

```text
$'\r': command not found
```

al ejecutar scripts desde WSL.
