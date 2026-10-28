# Guía de contribución — Festa (Desparcha2)

Esta guía aplica a todos los repositorios `festa-*` de la organización. GitHub la muestra automáticamente en los repos que no tengan una propia. Combina Scrum (sprints de una semana) con prácticas DevSecOps: todo cambio pasa por una rama, un pull request, revisión y pruebas automáticas.

## 1. Ramas

### Ramas permanentes

| Rama | Para qué | Cómo se actualiza |
|---|---|---|
| `main` | Lo que se demuestra y se entrega al final de cada sprint | Solo por pull request desde `develop` o desde una rama `hotfix/*` |
| `develop` | Integración del sprint en curso | Solo por pull request desde ramas de trabajo |

**Nadie hace commits directos en `main` ni en `develop`.** Los repositorios son privados y en el plan gratuito GitHub no deja proteger ramas, así que esta regla depende de todos.

### Ramas de trabajo

Formato:

```
<tipo>/SCRUM-<n>-<descripcion>
```

- **`<tipo>`** dice qué clase de cambio es:

  | Tipo | Cuándo |
  |---|---|
  | `feature` | Funcionalidad nueva (historia o subtarea) |
  | `fix` | Corrección de un error en `develop` |
  | `hotfix` | Error urgente en `main`. Sale de `main`, se mezcla a `main` y luego a `develop` |
  | `docs` | Solo documentación |
  | `test` | Solo pruebas |
  | `refactor` | Cambio interno sin cambiar el comportamiento |
  | `ci` | Pipelines y automatización |
  | `chore` | Mantenimiento: dependencias, configuración, limpieza |

- **`SCRUM-<n>`** es la clave de Jira **en mayúsculas**, tal como aparece en el tablero. Con ella Jira enlaza la rama, los commits y el pull request con la tarea. Si la rama cubre varias subtareas de una misma historia, usa la clave de una sola: la principal, o la de la historia.
- **`<descripcion>`** va en minúsculas y sin tildes ni `ñ`, con las palabras separadas por guiones. Debe tener de 2 a 5 palabras que digan qué se hace.

| ✅ Bien | ❌ Mal | Por qué está mal |
|---|---|---|
| `feature/SCRUM-50-pantalla-registro` | `feat/scrum-50-51-pantallas` | Tipo `feat` en vez de `feature`, clave en minúsculas y dos claves |
| `fix/SCRUM-29-qr-ya-utilizado` | `feature/mapa-eventos` | No tiene clave de Jira |
| `docs/SCRUM-41-contratos-rabbitmq` | `docs/readme` | No tiene clave de Jira |
| `ci/SCRUM-44-pipeline-auth` | `feature/SCRUM-17-Login_Google` | Mayúsculas y guion bajo en la descripción |

Expresión regular equivalente, para validarla automáticamente:

```
^(feature|fix|hotfix|docs|test|refactor|ci|chore)/SCRUM-[0-9]+-[a-z0-9]+(-[a-z0-9]+)*$
```

### Ciclo de vida

1. Sale de `develop` actualizado (`hotfix/*` sale de `main`).
2. Es corta: máximo 2 o 3 días. Si una historia es más grande, se parte en subtareas.
3. Si `develop` avanzó mientras trabajabas, actualiza tu rama desde `develop` antes de pedir revisión.
4. Se borra después de fusionar el pull request.
5. Al cerrar el sprint se abre un pull request de `develop` a `main`. Ese es el incremento que se demuestra.

## 2. Commits

Formato [Conventional Commits](https://www.conventionalcommits.org/es/) con la clave de Jira al final:

```
<tipo>(<alcance>): <descripción> [SCRUM-<n>]

<cuerpo opcional: por qué se hizo el cambio>

<pie opcional: trailers>
```

- **`<tipo>`:** `feat`, `fix`, `docs`, `test`, `refactor`, `ci`, `chore`, `perf`, `security`. Corresponde al tipo de la rama: una rama `feature/` lleva commits `feat`, y una `hotfix/` lleva commits `fix`.
- **`<alcance>`:** la parte del sistema que cambia. Es el nombre del repositorio sin `festa-`: `auth`, `user`, `event`, `booking`, `payment`, `ai`, `notification`, `analytics`, `gateway`, `infra`, `mobile`. En el repositorio `.github` es el área: `ci`, `arquitectura`, `sprints`… Puede omitirse si el cambio es transversal.
- **`<descripción>`:**
  - en español y en presente, con el verbo en tercera persona: "agrega", "corrige", "valida";
  - empieza en minúscula y no lleva punto final;
  - la primera línea completa, con la clave de Jira, tiene máximo 72 caracteres.
- **`[SCRUM-<n>]`:** la clave de Jira, entre corchetes y en mayúsculas.
- **Cuerpo:** explica el **por qué** cuando no es obvio. Va separado por una línea en blanco.
- **Pie:**
  - Si el cambio rompe un contrato (API, mensajes de RabbitMQ, esquema de base de datos), agrega `BREAKING CHANGE: <qué se rompe y qué hacer>` y usa `!` después del tipo: `feat(auth)!: …`.
  - Si el código fue generado con IA, lleva el trailer `Co-Authored-By` (ver abajo).

| ✅ Bien | ❌ Mal | Por qué está mal |
|---|---|---|
| `feat(auth): inicio de sesión con Google [SCRUM-17]` | `login google` | No tiene tipo, alcance ni clave |
| `fix(booking): rechaza el QR ya utilizado [SCRUM-29]` | `Fix: Arreglé el QR.` | Mayúscula inicial, verbo en pasado y punto final |
| `docs(infra): documenta los contratos de RabbitMQ [SCRUM-41]` | `docs(infra): cambios [SCRUM-41]` | "cambios" no dice qué cambió |
| `test(auth): cubre el bloqueo tras 5 intentos fallidos [SCRUM-54]` | `feat: varias cosas del sprint` | Un commit debe hacer una sola cosa |

Haz commits pequeños y que cada uno compile. Como los pull requests se fusionan con *squash*, en `develop` solo queda el **título del pull request** como commit. Por eso el título es lo que más importa (ver sección 3).

**Código generado con IA:** el commit debe indicarlo con un trailer al final del mensaje, por ejemplo:

```
Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>
```

Los prompts que cambien una decisión o generen código importante se registran en la bitácora (`BITACORA_PROMPTS.md`), con fecha, autor, herramienta, modelo, prompt, respuesta y decisión.

## 3. Pull requests

- **Título:** el mismo formato de un commit: `<tipo>(<alcance>): <descripción> [SCRUM-<n>]`. Al fusionar con *squash*, el título se vuelve el commit de `develop`. Si GitHub propone un título a partir del nombre de la rama (por ejemplo "Feature/SCRUM 50 pantalla registro"), cámbialo antes de crear el PR.
- **Rama destino:** `develop`. Hacia `main` solo para cerrar el sprint o para un hotfix.
- **Descripción:** se llena la plantilla del repositorio y se enlaza la tarea de Jira.
- **Tamaño:** pequeño, idealmente menos de 400 líneas cambiadas. Si crece más, se parte en varios PR.
- **Borrador:** si todavía no está listo para revisión, ábrelo como *draft*.
- **Revisión:**
  - Necesita **al menos una aprobación de otra persona**; nadie aprueba su propio PR.
  - Necesita **CI en verde**.
  - Quien revisa comenta sobre el código. Quien abrió el PR responde cada comentario y resuelve la conversación cuando ya está atendido.
- **Fusión:**
  - La hace quien abrió el PR, después de la aprobación.
  - Se usa **Squash and merge**: el título del commit debe quedar igual al del PR.
  - Después se borra la rama.

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
