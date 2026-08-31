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
- **Prompt utilizado:**

​```
(aquí va el prompt exacto, tal cual fue escrito)
​```

- **Resultado obtenido:** (resumen o fragmento más representativo)
- **Validación (riesgos):** (qué riesgo mitiga esta técnica específica —
  alucinación, inconsistencia, requisitos vagos, bugs silenciosos, cobertura
  falsa de tests, sesgo de autoconfirmación, sobre-ingeniería, etc.)
- **Decisión de uso:** (en blanco — lo completa el autor tras revisar el
  resultado)
```

---

## Entradas

## P1
- **Fecha:** 2026-09-05
- **Autor:** [COMPLETAR]
- **Herramienta/Modelo:** [COMPLETAR]
- **Fase del SDLC:** Implementación
- **Técnica de prompting utilizada:** Instrucción dirigida con plantilla estructurada (few-shot template)
- **Prompt utilizado:**

```
Necesito que configures un mecanismo de bitácora de prompts en este
repositorio, para registrar cada prompt que te dé junto con su resultado,
siguiendo los lineamientos de mi curso sobre uso documentado de IA en el
desarrollo de software.

1. Crea un archivo BITACORA_PROMPTS.md con esta plantilla reutilizable en
Markdown, para que cada entrada nueva se agregue con esta estructura EXACTA:

## [ID del prompt, ej. P1, P2, P3...]
- **Fecha:**
- **Autor:**
- **Herramienta/Modelo:**
- **Fase del SDLC:** (Análisis / Diseño / Implementación / Pruebas)
- **Técnica de prompting utilizada:** (Zero-shot / Few-shot / Chain-of-Thought /
  Delimitadores / System Persona / Role-play adversarial / Instrucción
  dirigida / etc. — infiere cuál aplica según el prompt que te dé)
- **Prompt utilizado:**

(aquí va el prompt exacto que te di, tal cual lo escribí)

- **Resultado obtenido:** (tu resultado real para ese prompt — resumen si es
muy largo, o el fragmento más representativo)
- **Validación (riesgos):** (qué riesgo mitiga esta técnica específica —
alucinación, inconsistencia, requisitos vagos, bugs silenciosos, cobertura
falsa de tests, sesgo de autoconfirmación, sobre-ingeniería, etc.)
- **Decisión de uso:** (deja este campo en blanco — lo completo yo después
de revisar el resultado)

2. A partir de ahora, cada vez que te dé un prompt nuevo para ejecutar:
 - Ejecuta el prompt normalmente y dame el resultado.
 - Automáticamente, agrega una entrada nueva a BITACORA_PROMPTS.md siguiendo
   la plantilla de arriba, con el ID siguiente en la secuencia (P1, P2,
   P3...), la fecha de hoy, y el resultado real que generaste.
 - Deja los campos Autor y Herramienta/Modelo como [COMPLETAR] si no te
   los especifico en ese momento.
 - Haz un commit por cada entrada nueva agregada a la bitácora, con el
   mensaje "docs: registra prompt [ID] en bitácora".

3. Además, cualquier commit que contenga código o documentos generados
directamente por ti (no solo la entrada de la bitácora) debe indicar
explícitamente que es resultado de IA — agrega la línea
"Co-authored-by: Claude <noreply@anthropic.com>" al final del mensaje de
ese commit, manteniéndome a mí como autor principal.

Confírmame que el mecanismo quedó listo antes de que te pase el primer
prompt de contenido del proyecto.
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
- **Decisión de uso:**
