# Git SSH Multi Identity Guide

## Objetivo

Esta guía explica cómo configurar Git y SSH para trabajar con múltiples cuentas y clientes desde WSL/Linux.

Está pensada para escenarios donde existen varias identidades:

```text
Personal
Empresa
Cliente A
Cliente B
```

El ejemplo de esta guía usa un cliente ficticio llamado:

```text
contoso
```

---

# Qué problema resuelve

Cuando se trabaja con varios clientes, Git necesita saber dos cosas diferentes:

## 1. Cómo autenticarse

Esto lo gestiona SSH.

Ejemplo:

```text
¿Qué clave SSH uso para conectarme a GitHub del cliente?
```

## 2. Con qué identidad firmar commits

Esto lo gestiona Git.

Ejemplo:

```text
¿Qué email debe aparecer en mis commits?
```

Son dos cosas distintas:

```text
SSH  → Autenticación
Git  → Identidad de commits
```

---

# Estructura objetivo

Para el cliente `contoso` queremos terminar con algo así:

```text
~/.ssh/
├── id_ed25519_contoso
├── id_ed25519_contoso.pub
└── config
```

Y:

```text
~/.gitconfig
~/.gitconfig-contoso
```

Además, los repositorios del cliente estarán en:

```text
~/dev/clients/contoso/01_repos
```

---

# 1. Crear workspace del cliente

Crear el árbol del cliente:

```bash
new-client contoso
```

Entrar en la carpeta de repositorios:

```bash
cd ~/dev/clients/contoso/01_repos
```

---

# 2. Crear carpeta SSH

Si no existe:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

## Qué significa

```bash
mkdir -p ~/.ssh
```

Crea la carpeta `.ssh`, donde Linux guarda claves y configuración SSH.

```bash
chmod 700 ~/.ssh
```

Hace que solo tu usuario pueda leer, escribir y entrar en esa carpeta.

Esto es importante porque SSH rechaza configuraciones inseguras.

---

# 3. Crear clave SSH del cliente

Crear una clave específica para `contoso`:

```bash
ssh-keygen -t ed25519 -C "santiago.contoso" -f ~/.ssh/id_ed25519_contoso
```

## Qué hace cada parte

```bash
ssh-keygen
```

Herramienta para generar claves SSH.

```bash
-t ed25519
```

Tipo de clave moderna, segura y recomendada.

```bash
-C "santiago.contoso"
```

Comentario descriptivo para identificar la clave.

```bash
-f ~/.ssh/id_ed25519_contoso
```

Ruta donde se guardará la clave.

---

# 4. Passphrase

Durante la creación preguntará:

```text
Enter passphrase
```

Recomendación:

```text
Sí, usar passphrase.
```

La passphrase protege la clave privada.

Resultado:

```text
~/.ssh/id_ed25519_contoso      → clave privada
~/.ssh/id_ed25519_contoso.pub  → clave pública
```

Nunca compartir:

```text
id_ed25519_contoso
```

Sí se puede registrar en GitHub:

```text
id_ed25519_contoso.pub
```

---

# 5. Verificar claves creadas

```bash
ls -la ~/.ssh
```

Resultado esperado:

```text
id_ed25519_contoso
id_ed25519_contoso.pub
```

Comprobar permisos:

```bash
stat -c "%a %n" ~/.ssh ~/.ssh/id_ed25519_contoso ~/.ssh/id_ed25519_contoso.pub
```

Resultado esperado:

```text
700 /home/santiago/.ssh
600 /home/santiago/.ssh/id_ed25519_contoso
644 /home/santiago/.ssh/id_ed25519_contoso.pub
```

---

# 6. Registrar clave pública en GitHub/GitHub Enterprise

Mostrar clave pública:

```bash
cat ~/.ssh/id_ed25519_contoso.pub
```

Copiar toda la línea.

Ejemplo:

```text
ssh-ed25519 AAAAC3... santiago.contoso
```

Registrar en GitHub:

```text
GitHub
↓
Settings
↓
SSH and GPG keys
↓
New SSH key
```

Título sugerido:

```text
WSL-Ubuntu24-Contoso
```

---

# 7. Autorizar SAML SSO si aplica

Algunas organizaciones tienen SAML SSO obligatorio.

Si al clonar aparece:

```text
The organization has enabled or enforced SAML SSO
```

hay que autorizar la clave.

Ruta habitual:

```text
GitHub
↓
Settings
↓
SSH and GPG keys
↓
Clave SSH
↓
Configure SSO
↓
Authorize organization
```

---

# 8. Configurar ~/.ssh/config

Editar:

```bash
nano ~/.ssh/config
```

Añadir:

```sshconfig
Host github-contoso
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_contoso
    IdentitiesOnly yes
```

Guardar.

Corregir permisos:

```bash
chmod 600 ~/.ssh/config
```

## Qué conseguimos

Cuando usemos:

```text
github-contoso
```

SSH sabrá que realmente debe conectarse a:

```text
github.com
```

usando esta clave:

```text
~/.ssh/id_ed25519_contoso
```

---

# 9. Probar conexión SSH

```bash
ssh -T git@github-contoso
```

La primera vez puede preguntar:

```text
Are you sure you want to continue connecting?
```

Responder:

```text
yes
```

Resultado esperado:

```text
Hi <usuario>! You've successfully authenticated...
```

---

# 10. Configurar identidad Git del cliente

Crear fichero específico:

```bash
nano ~/.gitconfig-contoso
```

Contenido:

```ini
[user]
    name = Santiago Ochoa
    email = santiago@contoso.com
```

Sustituir:

```text
santiago@contoso.com
```

por el email real usado en el cliente.

---

# 11. Configurar includeIf en Git global

Editar:

```bash
nano ~/.gitconfig
```

Añadir:

```ini
[includeIf "gitdir:/home/santiago/dev/clients/contoso/"]
    path = /home/santiago/.gitconfig-contoso
```

## Qué hace

Cuando Git detecta que estás trabajando dentro de:

```text
/home/santiago/dev/clients/contoso/
```

carga automáticamente:

```text
/home/santiago/.gitconfig-contoso
```

Así los commits usan el email del cliente.

---

# 12. Probar identidad Git

Importante:

`includeIf` se activa correctamente dentro de repositorios Git.

Clonar o entrar en un repo:

```bash
cd ~/dev/clients/contoso/01_repos
git clone git@github-contoso:contoso-org/example-repo.git
cd example-repo
```

Comprobar:

```bash
git config user.name
git config user.email
```

Resultado esperado:

```text
Santiago Ochoa
santiago@contoso.com
```

Ver de dónde sale la configuración:

```bash
git config --show-origin user.email
```

Resultado esperado:

```text
file:/home/santiago/.gitconfig-contoso santiago@contoso.com
```

---

# 13. Clonar repositorios usando alias SSH

GitHub puede mostrar una URL así:

```text
git@github.com:contoso-org/example-repo.git
```

Pero para usar la clave correcta se debe cambiar a:

```text
git@github-contoso:contoso-org/example-repo.git
```

Ejemplo:

```bash
git clone git@github-contoso:contoso-org/example-repo.git
```

## Regla

Para repos del cliente `contoso`:

```text
Usar github-contoso
```

No usar:

```text
github.com
```

---

# 14. Configurar ssh-agent

## Problema

Si la clave tiene passphrase, Git puede pedirla muchas veces:

```text
git pull
git push
git clone
```

Para evitarlo se usa:

```text
ssh-agent
```

El agente guarda la clave desbloqueada en memoria durante la sesión.

---

# 15. Arrancar ssh-agent automáticamente

En:

```text
shell/profile.sh
```

añadir:

```bash
#
# SSH Agent
#

if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" >/dev/null
fi
```

Recargar:

```bash
source ~/.bashrc
```

Comprobar:

```bash
ssh-add -l
```

Resultado esperado si no hay claves cargadas:

```text
The agent has no identities.
```

Eso es correcto.

Significa:

```text
ssh-agent activo
pero sin claves cargadas
```

---

# 16. Crear funciones para cargar claves

En:

```text
shell/functions.sh
```

añadir:

```bash
ssh-load() {
    local key="$1"

    if [ -z "$key" ]; then
        echo "Usage: ssh-load <key>"
        return 1
    fi

    ssh-add "$HOME/.ssh/$key"
}

ssh-contoso() {
    ssh-load id_ed25519_contoso
}

ssh-keys() {
    ssh-add -l
}
```

Recargar:

```bash
source ~/.bashrc
```

---

# 17. Uso diario

Al empezar a trabajar con el cliente:

```bash
ssh-contoso
```

Introducir passphrase una vez.

Comprobar:

```bash
ssh-keys
```

Resultado esperado:

```text
ED25519 ... id_ed25519_contoso
```

A partir de ahí:

```bash
git pull
git push
git clone
```

no deberían pedir la passphrase en esa sesión.

---

# 18. Flujo completo diario

```bash
cd ~/dev/clients/contoso/01_repos
ssh-contoso
cd example-repo
git pull
code .
```

VSCode, al estar conectado a WSL, usará:

```text
Git de Ubuntu
SSH de Ubuntu
~/.ssh/config
ssh-agent de Ubuntu
```

Por tanto, si funciona en terminal WSL, también debe funcionar en VSCode.

---

# 19. Guardar clave en 1Password

Crear item:

```text
SSH - Contoso - WSL Ubuntu 24.04
```

Guardar:

```text
Private Key
Public Key
Passphrase
```

Campos recomendados:

```text
Client: Contoso
Environment: WSL Ubuntu 24.04
SSH Host Alias: github-contoso
Private key path: ~/.ssh/id_ed25519_contoso
Public key path: ~/.ssh/id_ed25519_contoso.pub
GitHub key title: WSL-Ubuntu24-Contoso
Created: YYYY-MM-DD
```

Nunca guardar claves privadas en Git.

---

# 20. Troubleshooting

## Error: Could not open a connection to your authentication agent

Significa que `ssh-agent` no está activo.

Solución:

```bash
eval "$(ssh-agent -s)"
```

Después:

```bash
ssh-add ~/.ssh/id_ed25519_contoso
```

---

## Error: SAML SSO enforced

Significa que la organización requiere autorizar la clave SSH.

Solución:

```text
GitHub
↓
Settings
↓
SSH and GPG keys
↓
Configure SSO
↓
Authorize
```

---

## git config user.email muestra email personal

Si estás en una carpeta normal como:

```text
~/dev/clients/contoso/01_repos
```

puede mostrar email personal.

La prueba real debe hacerse dentro de un repo:

```bash
cd ~/dev/clients/contoso/01_repos/example-repo
git config user.email
```

---

## git clone usa una clave incorrecta

Comprobar remoto:

```bash
git remote -v
```

Debe usar:

```text
git@github-contoso:org/repo.git
```

No:

```text
git@github.com:org/repo.git
```

---

# 21. Checklist para nuevo cliente

```text
[ ] Crear workspace con new-client contoso
[ ] Crear clave SSH id_ed25519_contoso
[ ] Registrar clave pública en GitHub/GHE
[ ] Autorizar SAML SSO si aplica
[ ] Añadir Host github-contoso en ~/.ssh/config
[ ] Crear ~/.gitconfig-contoso
[ ] Añadir includeIf en ~/.gitconfig
[ ] Crear función ssh-contoso
[ ] Cargar clave con ssh-contoso
[ ] Probar ssh -T git@github-contoso
[ ] Clonar repo con git@github-contoso:org/repo.git
[ ] Verificar git config user.email dentro del repo
[ ] Guardar clave privada, pública y passphrase en 1Password
[ ] Documentar acceso en OneNote
```

---

# Regla final

Para cada cliente:

```text
Una clave SSH
Un alias SSH
Una identidad Git
Una función de carga
Un vault 1Password
Un workspace Linux
```

Ejemplo:

```text
Cliente: Contoso
SSH Key: id_ed25519_contoso
SSH Alias: github-contoso
Git Config: ~/.gitconfig-contoso
Function: ssh-contoso
Workspace: ~/dev/clients/contoso
```
