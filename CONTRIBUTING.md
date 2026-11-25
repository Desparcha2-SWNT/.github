# Guía de contribución — Festa (Desparcha2)

Esta guía aplica a todos los repositorios `festa-*` de la organización. GitHub la muestra automáticamente en los repos que no tengan una propia. Combina Scrum (sprints de una semana) con prácticas DevSecOps: todo cambio pasa por una rama, un pull request, revisión y pruebas automáticas.

## 1. Ramas

| Rama | Para qué | Quién escribe |
|---|---|---|
| `main` | Lo que se demuestra y se entrega al final de cada sprint | Solo por pull request desde `develop` (o `hotfix/*`) |
| `develop` | Integración del sprint en curso | Solo por pull request desde ramas de trabajo |
| `feature/SCRUM-<n>-<descripcion>` | Una historia o subtarea nueva | Quien tenga la historia asignada |
| `fix/SCRUM-<n>-<descripcion>` | Corrección de un error | Quien lo corrige |
| `hotfix/SCRUM-<n>-<descripcion>` | Error urgente en `main` | Se mezcla a `main` y luego a `develop` |
| `docs/...`, `chore/...`, `test/...` | Documentación, mantenimiento, pruebas | Cualquiera |

Reglas:
- **Nadie hace commits directos en `main` ni en `develop`.**
- Las ramas de trabajo salen de `develop` y se mantienen cortas (máximo 2 o 3 días). Si una historia es más grande, se parte.
- El nombre incluye la clave de Jira (`SCRUM-17`): así Jira enlaza la rama, los commits y el pull request con la historia.
- Al cerrar el sprint se abre un pull request de `develop` a `main`; ese es el incremento que se demuestra.

## 2. Commits

Formato [Conventional Commits](https://www.conventionalcommits.org/es/) con la clave de Jira:

```
feat(auth): inicio de sesión con Google [SCRUM-17]
fix(booking): rechaza el QR ya utilizado [SCRUM-29]
docs(infra): documenta los contratos de RabbitMQ [SCRUM-41]
```

Tipos: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`, `ci`, `perf`, `security`.

**Código generado con IA:** el commit debe indicarlo con un trailer al final del mensaje, por ejemplo:

```
Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>
```

Los prompts que cambien una decisión o generen código importante se registran en la bitácora (`BITACORA_PROMPTS.md`), con fecha, autor, herramienta, modelo, prompt, respuesta y decisión.

## 3. Pull requests

- Se abren hacia `develop` (o hacia `main` solo para cerrar el sprint o un hotfix).
- Usan la plantilla del repositorio y enlazan la historia de Jira.
- Necesitan **al menos una aprobación de otra persona** (nadie aprueba su propio PR) y **CI en verde**.
- Son pequeños: idealmente menos de 400 líneas cambiadas.
- Se mezclan con *squash* para dejar un historial legible.

## 4. Cómo escribir una historia o tarea en Jira

Toda historia, tarea o subtarea tiene que poder entenderse y comprobarse sin preguntarle a quien la escribió. Usa este formato en la descripción:

```
**Como** <quién necesita esto>, **quiero** <qué necesita>, **para** <qué gana con eso>.

**Criterios de aceptación**
* <condición que se puede comprobar>
* <condición que se puede comprobar>
* <caso de error o límite>
```

Buenas prácticas para los criterios:
- Cada criterio es **verificable**: otra persona puede decir "se cumple" o "no se cumple" sin interpretar.
- Una sola condición por línea, escrita en presente ("Puedo…", "El sistema muestra…").
- Incluye al menos un **caso de error** (dato inválido, sin conexión, permiso negado).
- Menciona el requisito que cubre (RF o RNF) cuando aplique.
- No inventes números ni umbrales. Si falta una decisión del equipo, escríbela como pendiente y enlaza la tarea o el ADR que la resuelve.
- Una subtarea hereda el contexto de su historia: describe solo lo que ella aporta y sus criterios propios.

Ejemplo, subtarea SCRUM-50 «Pantalla de registro (correo y contraseña)»:

```
**Como** persona interesada en eventos, **quiero** una pantalla para registrarme con mi correo y una contraseña, **para** crear mi cuenta en Festa.

**Criterios de aceptación**
* Puedo ingresar correo y contraseña y enviar el formulario.
* Antes de crear la cuenta se me muestra el aviso de privacidad y debo autorizar el tratamiento de mis datos (Ley 1581).
* Si el correo ya está registrado o el formato es inválido, veo un mensaje claro y no se crea la cuenta.
* Si no hay conexión, la pantalla me avisa y no pierdo lo que escribí.
* La pantalla se conecta al gateway y la cuenta queda creada por festa-auth-service (RF1).
```

## 5. Definition of Done

Una historia está terminada cuando:
- [ ] Cumple los criterios de aceptación de Jira.
- [ ] El código fue revisado por otra persona.
- [ ] Tiene pruebas automatizadas y el CI pasa (build, linter, pruebas).
- [ ] No introduce vulnerabilidades altas ni secretos (escaneos del CI limpios).
- [ ] La documentación afectada está actualizada (README, diagramas de Lucid, ADR si hubo decisión).
- [ ] Está desplegada en el entorno de pruebas y se puede demostrar.
- [ ] Los commits con IA están marcados y, si aplica, hay entrada en la bitácora.

## 6. Seguridad básica (DevSecOps)

- **Nunca** subas secretos, llaves ni contraseñas. Usa variables de entorno y un `.env.example` sin valores reales.
- Wompi y cualquier pasarela se usan solo con llaves de **sandbox** hasta la demostración.
- Los servicios validan todas las entradas, usan JWT con expiración corta y no registran datos personales en los logs.
- Los datos personales se tratan según la Ley 1581 de 2012 (consentimiento y política de privacidad).
- Si encuentras una vulnerabilidad, sigue [SECURITY.md](SECURITY.md); no abras un issue público.

## 7. Decisiones de arquitectura

Las decisiones importantes (nube de despliegue, almacén de datos por servicio, proveedor de LLM, etc.) se registran como ADR en `docs/adr/`, con la plantilla `0000-plantilla.md`.

## 8. Aporte equitativo

El profesor revisa los repositorios cada semana y pide informes individuales. Por eso: commits propios y de tamaño razonable, historias asignadas a una persona y revisiones repartidas entre todos.
