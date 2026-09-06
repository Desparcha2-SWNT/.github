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
