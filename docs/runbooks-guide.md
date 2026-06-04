# Runbooks Guide

## Objetivo

Los runbooks permiten registrar sesiones importantes de configuración y administración para poder reproducirlas en el futuro.

La filosofía es:

```text
Primero ejecutar.
Después documentar.
Finalmente automatizar.
```

---

# ¿Qué es un runbook?

Un runbook es una combinación de:

* Procedimiento documentado.
* Registro de ejecución.
* Referencia futura.

Permite reconstruir configuraciones complejas sin depender de la memoria.

---

# Estructura

```text
~/dev/personal/notes/runbooks
├── logs
├── ssh-and-git.md
├── vscode.md
├── terraform.md
└── kubernetes.md
```

---

# Logs de sesión

Los logs se almacenan en:

```text
~/dev/personal/notes/runbooks/logs
```

Ejemplo:

```text
ssh-setup-2026-06-04.log
```

---

# Iniciar una sesión

Ejecutar:

```bash
runbook <nombre>
```

Ejemplo:

```bash
runbook ssh-setup
```

Resultado:

```text
~/dev/personal/notes/runbooks/logs/ssh-setup-YYYY-MM-DD.log
```

Todo lo ejecutado durante la sesión quedará registrado.

---

# Finalizar una sesión

Ejecutar:

```bash
exit
```

---

# Flujo recomendado

1. Iniciar runbook.
2. Realizar configuración.
3. Finalizar sesión.
4. Revisar log.
5. Extraer comandos útiles.
6. Actualizar documentación.
7. Automatizar si procede.

---

# Casos de uso

* Configuración SSH.
* Configuración Git.
* Instalación Kubernetes.
* Instalación Terraform.
* Instalación Azure CLI.
* Configuración VPN.
* Migraciones de equipo.

---

# Regla principal

Si una tarea es suficientemente importante como para repetirla en el futuro:

```text
Debe tener runbook.
```
