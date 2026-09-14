# Bitácora de Prompts — Proyecto Festa

Registro documentado del uso de IA (Claude) en el desarrollo del proyecto,
siguiendo los lineamientos del curso sobre uso documentado de IA en el
desarrollo de software.

Cada prompt de contenido del proyecto que se ejecute con la IA se registra
como una nueva entrada, usando la plantilla exacta a continuación.

---

## Plantilla (copiar para cada entrada nueva)

```
## [ID del prompt, ej. P1, P2, P3...]
- **Fecha:**
- **Autor:**
- **Herramienta/Modelo:**
- **Fase del SDLC:** (Análisis / Diseño / Implementación / Pruebas)
- **Técnica de prompting utilizada:** (Zero-shot / Few-shot / Chain-of-Thought /
  Delimitadores / System Persona / Role-play adversarial / Instrucción
  dirigida / etc.)
- **Prompt utilizado:** (estructurado con los cinco elementos vistos en el
  curso: rol, contexto, tarea, formato y riesgos)

​```
ROL: ...
CONTEXTO: ...
TAREA: ...
FORMATO: ...
RIESGOS: ...
​```

- **Resultado obtenido:** (resumen o fragmento más representativo)
- **Validación (riesgos):** (qué riesgo mitiga esta técnica específica —
  alucinación, inconsistencia, requisitos vagos, bugs silenciosos, cobertura
  falsa de tests, sesgo de autoconfirmación, sobre-ingeniería, etc.)
- **Decisión de uso:** (Aceptado / Aceptado con ajustes / Descartado, con
  motivo. La IA puede proponerla; el autor la confirma)
```

---

## Entradas

Orden cronológico, agrupado por etapas. Cada entrada consolida los mensajes
de una misma tarea; los mensajes de control (`/model`, "sí", "continúa") no
tienen entrada propia. El texto completo de los 117 mensajes está en
`Sustentacion2/prompts_sesion.md`.

## Etapa 1 — Configuración del repositorio y requisitos (5 al 14 de septiembre de 2026)

## P1
- **Fecha:** 2026-09-05
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar)
- **Fase del SDLC:** Implementación
- **Técnica de prompting utilizada:** Instrucción dirigida con plantilla estructurada (few-shot template)
- **Prompt utilizado:**

```
ROL: Responsable de trazabilidad de IA del repositorio de documentación.
CONTEXTO: Repo `Desparcha2-SWNT/.github`; el curso exige registrar cada
prompt con técnica, riesgo mitigado y decisión de uso.
TAREA: Crea `BITACORA_PROMPTS.md` con la plantilla (fecha, autor, modelo,
fase SDLC, técnica, prompt, resultado, riesgos, decisión) y registra cada
prompt futuro como entrada nueva.
FORMATO: Un commit por entrada (`docs: registra prompt [ID] en bitácora`);
commits con contenido de IA marcados con `Co-authored-by`.
RIESGOS: Confirma el mecanismo antes del primer prompt de contenido; deja
Decisión de uso vacía hasta que yo revise.
```

- **Resultado obtenido:** Se creó `BITACORA_PROMPTS.md` en la raíz del repo
  `Desparcha2-SWNT/.github` con la plantilla reutilizable exacta solicitada,
  y esta misma entrada (P1) como primer registro del mecanismo. Se estableció
  el flujo de trabajo: cada prompt de contenido futuro se registrará con ID
  incremental, fecha del día, y commit dedicado con mensaje
  "docs: registra prompt [ID] en bitácora"; los commits con contenido
  generado por IA incluirán la línea de co-autoría de Claude.
- **Validación (riesgos):** Mitiga la falta de trazabilidad sobre qué
  contenido del proyecto fue generado o asistido por IA (requisito del
  curso), reduciendo el riesgo de atribución incorrecta de autoría y
  facilitando la auditoría posterior de decisiones tomadas sobre resultados
  de IA (sesgo de autoconfirmación si no se revisa cada entrada).
- **Decisión de uso (propuesta):** Aceptado. Pendiente de confirmación del autor.

## P5
- **Fecha:** 2026-09-05
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar)
- **Fase del SDLC:** Implementación (documentación)
- **Técnica de prompting utilizada:** Few-shot (repositorio de referencia `CodeForge-DOSW/.github` como ejemplo de estructura) + Instrucción dirigida paso a paso
- **Prompt utilizado:**

```
ROL: Eres un ingeniero de documentación que mantiene el repositorio
`Desparcha2-SWNT/.github`.
CONTEXTO: El repo es la portada de la organización. La estructura del
README debe imitar https://github.com/CodeForge-DOSW/.github (solo la
estructura, no sus fechas). Nuestro grupo se llama "Desparchados" y el
proyecto "Festa". El historial debe reflejar la evolución real del trabajo.
TAREA: Reconstruye el historial en commits separados y fechados:
(1) 3-ago 17:35 nombres de profesores e información institucional;
(2) 4-ago contexto del proyecto; (3) 12-ago integrante Sebastián Duque
Ceballos (SWNT-3/SWNT-301); (4) 14-ago nombre del grupo y del proyecto;
(5) 31-ago bitácora de prompts.
FORMATO: Un commit por paso, mensaje convencional (`docs: ...`), listado
final de hashes y fechas para que yo lo verifique antes de empujar.
RIESGOS: Reescribir fechas cambia el historial; confírmame antes de
cualquier force-push y no toques ramas ajenas.
```

- **Resultado obtenido:** El historial del repo quedó como commits fechados del 3, 4, 12, 14 y 31 de agosto (visibles en `git log`), con el README alineado a la estructura del repo de referencia.
- **Validación (riesgos):** El ejemplo concreto (few-shot) evita que la IA invente una estructura de README; pedir un paso por vez y listar hashes permite verificar el historial reescrito. Riesgo residual: fechas de commit editadas a mano no coinciden con la fecha real de trabajo, por lo que esta bitácora conserva las fechas reales.
- **Decisión de uso (propuesta):** Aceptado con ajustes. Pendiente de confirmación del autor.

## Etapa 2 — Diagramas y sustentación 2 (14 al 16 de septiembre de 2026)

## P6
- **Fecha:** 2026-09-14
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar) con conector de Lucid
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Instrucción dirigida con contexto multimodal (documentos Word adjuntos) + Critique-and-Correct (varias rondas de corrección visual)
- **Prompt utilizado:**

```
ROL: Eres un arquitecto de software que documenta en Lucidchart.
CONTEXTO: Festa es una app de descubrimiento de eventos en Bogotá. Adjunto
la arquitectura de microservicios y los requerimientos (RF1–RF19,
RNF1–RNF12). Despliegue previsto: AWS. Mi cuenta de Lucid permite editar
solo 3 documentos.
TAREA: En el documento "Festa" (páginas "Proceso BPMN" y "Arquitectura"),
mejora la legibilidad del BPMN y del diagrama de arquitectura usando los
íconos oficiales de AWS, agrupando los servicios en cinco bloques
lógicos, sin flechas que se crucen ni textos ilegibles.
FORMATO: Un diagrama por página, flechas ortogonales, nombres de servicio
consistentes entre BPMN y arquitectura; al final, lista de los cambios
hechos para que los valide.
RIESGOS: No elimines ni sobrescribas páginas existentes sin avisarme; no
agregues servicios (p. ej. payment o notification) que no estén en los
documentos fuente.
```

- **Resultado obtenido:** Se actualizó el BPMN y el diagrama de arquitectura en Lucid. Hubo varias rondas de corrección porque la primera versión añadió servicios no pedidos y dejó el diagrama fragmentado; se rehízo como un solo sistema en cinco bloques. Los límites de edición de la cuenta de Lucid obligaron a borrar documentos generados para liberar cupo.
- **Validación (riesgos):** Contrastar el diagrama con los documentos fuente detectó una alucinación de alcance (servicios inventados). La revisión visual humana en cada ronda fue el control principal.
- **Decisión de uso (propuesta):** Aceptado con ajustes (la arquitectura AWS fue superada después por la de GCP y luego por Azure, ver P12 y P20).
