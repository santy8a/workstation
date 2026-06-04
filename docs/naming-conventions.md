# Naming Conventions

## Objetivo

Este documento define las convenciones de nombres utilizadas en la Workstation.

El objetivo es mantener consistencia, facilitar la automatización y evitar decisiones repetitivas.

---

# Principios generales

Siempre que sea posible:

* Utilizar nombres cortos.
* Utilizar nombres descriptivos.
* Evitar espacios.
* Evitar acentos.
* Evitar caracteres especiales.
* Mantener una única convención para cada tipo de recurso.

---

# Clientes

## Convención

```text
kebab-case
```

o acrónimos ampliamente reconocidos.

## Ejemplos

```text
eco
bbba
mapre
telefonia
cliente-demo
startup-ai
```

## Evitar

```text
El Cliente A
ElClienteA
elClienteA
el_cliente_a
```

## Justificación

Los nombres de clientes se utilizan frecuentemente en:

* Directorios.
* Scripts.
* Automatizaciones.
* Variables.
* Documentación.

Los nombres cortos mejoran la productividad diaria.

---

# Repositorios

## Convención

Mantener siempre el nombre original del repositorio.

## Ejemplos

```text
terraform-aks-platform
azure-networking
shared-infrastructure
```

## Justificación

Evita diferencias entre:

* GitHub.
* Azure DevOps.
* Documentación.
* Directorios locales.

---

# Scripts

## Convención

```text
kebab-case
```

## Ejemplos

```text
bootstrap.sh
install-vscode-wsl.sh
create-client-workspace.sh
apply-terraform-vscode-settings.sh
```

## Evitar

```text
Bootstrap.sh
createClientWorkspace.sh
create_client_workspace.sh
```

## Justificación

Es la convención más habitual en entornos Linux.

---

# Directorios

## Convención

```text
kebab-case
```

## Ejemplos

```text
personal-notes
azure-platform
terraform-modules
shared-services
```

## Justificación

Consistencia con Linux y facilidad de uso en terminal.

---

# Funciones Shell

## Convención

```text
snake_case
```

o nombres cortos cuando el contexto sea evidente.

## Ejemplos

```bash
create_client_workspace
apply_terraform_settings
install_vscode_extensions
```

Funciones cortas:

```bash
croot
personal
labs
```

## Justificación

Las funciones suelen utilizarse dentro de scripts Bash donde snake_case es una convención ampliamente utilizada.

---

# Alias Shell

## Convención

Nombres cortos y fáciles de recordar.

## Ejemplos

```bash
tf
tfp
tfa
k
kgp
kgpa
```

## Justificación

Los alias deben minimizar pulsaciones de teclado.

---

# Regla principal

Cuando exista una duda:

```text
Priorizar consistencia sobre preferencias personales.
```

Es preferible seguir una convención estable que mezclar múltiples estilos dentro de la misma Workstation.
