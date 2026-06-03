# Linux Shell Guide

## Objetivo

Este documento explica cómo está personalizada la shell de la Workstation y cómo ampliarla en el futuro.

Está pensado para alguien que está empezando en Linux y quiere entender qué hace cada componente.

---

# Cómo se carga la shell

Cuando se abre una terminal Ubuntu ocurre lo siguiente:

```text
Ubuntu
│
├── ~/.bashrc
│
└── profile.sh
    │
    ├── aliases.sh
    │
    └── functions.sh
```

Flujo completo:

```text
Abrir Terminal
↓
Bash arranca
↓
Lee ~/.bashrc
↓
Carga profile.sh
↓
Carga aliases.sh
↓
Carga functions.sh
↓
Entorno listo para trabajar
```

---

# ~/.bashrc

Ubicación:

```bash
~/.bashrc
```

Es uno de los ficheros estándar de Linux.

Cada vez que se abre una terminal interactiva Bash ejecuta este fichero.

No es recomendable modificarlo constantemente.

La estrategia utilizada en esta workstation es:

```text
~/.bashrc
↓
Carga profile.sh
↓
Toda la personalización vive en el repositorio Workstation
```

Esto permite reconstruir el entorno completo en un equipo nuevo.

---

# profile.sh

Ubicación:

```text
shell/profile.sh
```

Responsabilidad:

```text
Configuración global de la shell
```

Aquí deben vivir:

* Variables de entorno
* PATH
* Configuraciones globales
* Carga de aliases
* Carga de functions

Ejemplos:

```bash
export EDITOR=code

export PATH="$HOME/.local/bin:$PATH"

export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
```

No deben vivir aquí:

* Alias
* Automatizaciones
* Comandos específicos de proyectos

---

# PATH

Uno de los conceptos más importantes de Linux.

Cuando se ejecuta:

```bash
terraform
```

Linux busca ese ejecutable en todas las rutas definidas en:

```bash
echo $PATH
```

Ejemplo:

```text
/home/santiago/.local/bin
/usr/local/bin
/usr/bin
```

Por este motivo se añadió:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

para que herramientas instaladas por:

* uv
* pipx
* Python

puedan encontrarse automáticamente.

---

# aliases.sh

Ubicación:

```text
shell/aliases.sh
```

Responsabilidad:

```text
Atajos de comandos
```

Ejemplo:

```bash
alias k=kubectl
```

Ahora:

```bash
k get pods
```

equivale a:

```bash
kubectl get pods
```

Ejemplos actuales:

```bash
tf
tfp
tfa

k
kgp
kgpa

gs
gp
gc
```

Regla recomendada:

```text
Alias = comando corto
Sin lógica
Sin validaciones
Sin automatización
```

Si empieza a tener lógica probablemente debería ser una función.

---

# functions.sh

Ubicación:

```text
shell/functions.sh
```

Responsabilidad:

```text
Automatizaciones reutilizables
```

Ejemplo:

```bash
aks-creds rg-dev aks-dev
```

En realidad ejecuta:

```bash
az aks get-credentials \
  --resource-group rg-dev \
  --name aks-dev
```

Otro ejemplo:

```bash
new-client cliente-x
```

Crea automáticamente el árbol estándar de trabajo para un cliente.

Regla recomendada:

```text
Function = varios comandos
Puede recibir parámetros
Puede contener lógica
Puede validar entradas
```

---

# Cuándo usar Alias o Function

Usar Alias cuando:

```text
Quiero escribir menos
```

Ejemplo:

```bash
alias tf=terraform
```

Usar Function cuando:

```text
Quiero automatizar algo
```

Ejemplo:

```bash
tf-clean()
```

porque ejecuta varios comandos.

---

# Cómo recargar cambios

Si se modifica:

```text
profile.sh
aliases.sh
functions.sh
```

No es necesario cerrar la terminal.

Ejecutar:

```bash
source ~/.bashrc
```

Esto vuelve a cargar toda la configuración.

---

# Cómo comprobar que algo está cargado

Ver alias:

```bash
alias
```

Buscar alias:

```bash
alias | grep terraform
```

Ver funciones:

```bash
type tf-clean

type new-client
```

Si aparece:

```text
new-client is a function
```

la función está cargada correctamente.

---

# Buenas prácticas

## profile.sh

Mantener pequeño.

Solo configuración global.

---

## aliases.sh

Añadir únicamente alias usados frecuentemente.

Evitar alias innecesarios.

---

## functions.sh

Documentar las funciones complejas.

Crear funciones reutilizables.

Pensar en automatización de tareas repetitivas.

---

# Filosofía de la Workstation

Objetivo:

```text
Menos tiempo configurando
Más tiempo construyendo
```

Todo cambio útil debe:

1. Probarse localmente.
2. Añadirse al repositorio Workstation.
3. Hacer commit.
4. Hacer push.

De esta forma cualquier portátil nuevo puede reconstruirse de forma reproducible.
