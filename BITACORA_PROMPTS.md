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

## P2
- **Fecha:** 2026-09-14
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5 (Claude Code)
- **Fase del SDLC:** Análisis
- **Técnica de prompting utilizada:** Instrucción dirigida con contexto acumulado (el pedido se construyó a lo largo de varios turnos: reparto de tareas del equipo para la Sustentación 2, luego se aportaron `Requerimientos.docx` y la plantilla de referencia `dosw-lab4-example/requirement-template.md`, y finalmente la ubicación del repo de documentación del equipo)
- **Prompt utilizado:**

```
ROL: Analista de requisitos.
CONTEXTO: Sustentación 2 pide casos de uso priorizados. Fuentes:
Requerimientos.docx (MoSCoW ya definido) y requirement-template.md. Repo de
documentación: Desparcha2-SWNT/.github.
TAREA: Llena la plantilla con los requisitos del Word.
FORMATO: Un solo archivo `docs/requirements/requirements.md` (funcionales
y no funcionales), no un archivo por requerimiento.
RIESGOS: Marca como borrador lo que el equipo no haya validado; no omitas
requisitos Should, Could ni Won't.
```

- **Resultado obtenido:** Se leyó `Requerimientos.docx` (especificación
  completa con priorización MoSCoW ya definida: RF1–RF19, RNF1–RNF12,
  RN1–RN6) y la estructura de la plantilla de referencia (ID, nombre,
  descripción, precondiciones, actor, flujo principal, diagrama de caso
  de uso, postcondiciones). Se localizó el repo `Desparcha2-SWNT/.github`
  como el repositorio de documentación del equipo. Se creó
  `docs/requirements/` con un `README.md` (tabla MoSCoW + índice de
  responsables) y 12 archivos `RF0X-*.md` — uno por cada requerimiento
  Must (RF1–RF5, RF8–RF11) y Should principal (RF6, RF7, RF12) — cada uno
  con un borrador completo siguiendo el formato de la plantilla, listo
  para que cada integrante lo revise y ajuste antes de la sustentación de
  mañana. Se asignó un responsable por archivo entre los 8 integrantes
  listados en `profile/README.md`.
- **Validación (riesgos):** Mitiga el riesgo de requisitos vagos o
  incompletos de cara a la sustentación (cada caso de uso quedó con
  flujo principal, alternativo y postcondiciones explícitos, no solo una
  frase suelta) y el riesgo de reparto de trabajo desbalanceado o
  ambiguo bajo presión de tiempo (entrega al día siguiente). Riesgo
  pendiente de validar por el equipo: los borradores fueron generados a
  partir del documento de requerimientos sin validación humana del
  equipo todavía — cada responsable debe revisar que su caso de uso
  refleje lo que el equipo realmente tiene en mente antes de presentarlo
  (sesgo de autoconfirmación si se presenta sin revisión).
- **Decisión de uso (propuesta):** Aceptado con ajustes (se reemplazó por el consolidado de P3). Pendiente de confirmación del autor.

## P3
- **Fecha:** 2026-09-14
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5 (Claude Code)
- **Fase del SDLC:** Análisis
- **Técnica de prompting utilizada:** Instrucción dirigida (corrección explícita del formato de salida del prompt anterior, P2)
- **Prompt utilizado:**

```
ROL: Analista de requisitos.
CONTEXTO: El resultado anterior fragmentó los RF en 12 archivos y omitió
los demás.
TAREA: Consolida todo en un único archivo con la plantilla completa.
FORMATO: Secciones 1.1 funcionales, 1.2 no funcionales, 2 casos de uso
detallados de los 19 RF.
RIESGOS: Borra los archivos individuales solo después de confirmar que el
consolidado está completo.
```

- **Resultado obtenido:** Se eliminaron los 12 archivos `RF0X-*.md`
  generados en P2 y se reemplazaron por un único archivo
  `docs/requirements/requirements.md` que llena la plantilla completa de
  `dosw-lab4-example/requirement-template.md`: sección 1.1 con las 19
  funcionales en alto nivel, sección 1.2 con las 12 no funcionales,
  y sección 2 con un caso de uso detallado (tabla completa) por cada uno
  de los 19 RF — no solo los 9 Must, sino también Should, Could y Won't,
  cubriendo el 100% de los requerimientos funcionales del Word. Se
  actualizó `README.md` para reflejar el archivo único.
- **Validación (riesgos):** Corrige una alucinación de alcance del
  resultado anterior (asumí que "casos de uso priorizados" implicaba
  fragmentar en un archivo por requerimiento y limitar a los
  prioritarios, cuando el usuario pidió explícitamente un solo archivo
  con la plantilla completa y todos los requerimientos). Mitiga el
  riesgo de que el equipo tenga que buscar información repartida en
  múltiples archivos bajo presión de tiempo antes de la sustentación.
- **Decisión de uso (propuesta):** Aceptado. Pendiente de confirmación del autor.

## P4
- **Fecha:** 2026-09-14 (21:21, commits `29a5912` y `87456e1` de brloa05)
- **Autor:** Brayan Loaiza Leal
- **Herramienta/Modelo:** Claude Code — Claude Opus 5 (1M context)
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Instrucción dirigida con delimitadores y contexto multimodal (código DSL + imagen del diagrama renderizado + ruta del repositorio destino)
- **Prompt utilizado:**

```
ROL: Arquitecto que versiona el modelo C4.
CONTEXTO: Se entrega el DSL Structurizr (entre delimitadores) y el PNG del
diagrama de contexto; el repo destino es el de documentación.
TAREA: Versiona el DSL sin modificarlo, la imagen y un README de uso.
FORMATO: `docs/arquitectura/festa.dsl`, `diagramas/ContextoFesta.png`,
`README.md` con cómo renderizar.
RIESGOS: No "mejores" el DSL; avisa si la imagen y el código no coinciden.
```

- **Resultado obtenido:** Se versionó el modelo de arquitectura en la rama
  `docs/arquitectura-c4-contexto` del repo `Desparcha2-SWNT/.github`, con la
  estructura:
  - `docs/arquitectura/festa.dsl` — el workspace Structurizr DSL **sin cambios
    de contenido** (se preservó tal cual fue entregado), como fuente de verdad
    del modelo C4.
  - `docs/arquitectura/diagramas/ContextoFesta.png` — la exportación del
    diagrama de contexto (C4 nivel 1) adjunta en el prompt.
  - `docs/arquitectura/README.md` — documenta ambas vistas (`ContextoFesta` y
    `ContenedoresFesta`), tres formas de renderizar el DSL (Structurizr Lite
    vía Docker, `structurizr-cli`, o el editor web) y la convención de cambios:
    editar solo el `.dsl`, re-exportar la imagen y registrar el prompt en esta
    bitácora.

  Commit: `docs(arquitectura): versiona el modelo C4 de Festa en Structurizr
  DSL`, con la línea de co-autoría de IA.
- **Validación (riesgos):** Entregar el código y la imagen renderizada juntos
  (delimitadores + contexto multimodal) evita que la IA reinterprete o
  "mejore" el modelo por su cuenta: el DSL se versionó literalmente, sin
  alucinar contenedores, relaciones ni estilos inexistentes. Tratar el `.dsl`
  como única fuente de verdad mitiga el riesgo de inconsistencia entre el
  diagrama publicado y el modelo real (imágenes editadas a mano que divergen
  del código). El riesgo residual es que la exportación PNG quede
  desactualizada frente al DSL si alguien no re-exporta; por eso se documentó
  explícitamente en el README.
- **Decisión de uso (propuesta):** Aceptado. Pendiente de confirmación del autor.


---

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

## P7
- **Fecha:** 2026-09-14
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar)
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Few-shot visual (imágenes con la simbología AWS y un diagrama Lucid previo como ejemplo) + Instrucción dirigida
- **Prompt utilizado:**

```
ROL: Arquitecto cloud con experiencia en diagramas AWS.
CONTEXTO: Adjunto imágenes de la simbología AWS y el diagrama
https://lucid.app/... como referencia de estilo. Requerimientos y
arquitectura de microservicios ya compartidos.
TAREA: Propón la arquitectura y dibújala con la simbología de la
referencia (VPC, subredes, servicios, flechas con etiquetas), y aplica la
misma limpieza visual al BPMN.
FORMATO: Reglas explícitas de limpieza (sin cruces, espaciado uniforme,
una capa por fila); entrega por iteraciones pequeñas que yo reviso.
RIESGOS: Si un ícono no existe en la biblioteca de Lucid, dímelo en vez
de reemplazarlo por uno distinto.
```

- **Resultado obtenido:** Diagrama de arquitectura AWS reordenado y BPMN depurado; iteraciones de armonía visual hasta que el equipo lo dio por válido para la sustentación.
- **Validación (riesgos):** El ejemplo visual reduce la libertad de la IA para inventar simbología. Riesgo residual: cumplimiento solo estético; la corrección técnica de la arquitectura la validó el equipo.
- **Decisión de uso (propuesta):** Aceptado. Pendiente de confirmación del autor.

## P8
- **Fecha:** 2026-09-14
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar)
- **Fase del SDLC:** Análisis
- **Técnica de prompting utilizada:** Zero-shot de consulta + Instrucción dirigida (reparto de trabajo a partir del enunciado del profesor)
- **Prompt utilizado:**

```
ROL: Líder técnico que prepara la sustentación 2.
CONTEXTO: El profesor pidió una propuesta de arquitectura y casos de uso
priorizados. Somos 8 integrantes. Aún no hemos fijado la nube.
TAREA: Lista las calculadoras oficiales de costos de todos los
proveedores relevantes (AWS, Azure, GCP, otros) y propón una distribución
de tareas para mañana (costos, diagrama de arquitectura, casos de uso).
FORMATO: Tabla proveedor / URL oficial / qué estima / limitaciones, y tabla
de tareas con responsable sugerido.
RIESGOS: Verifica que las URL existan; no des cifras de precios sin
fuente, indícalas como supuestos.
```

- **Resultado obtenido:** Lista de calculadoras de costos por proveedor y propuesta de reparto de tareas para el equipo.
- **Validación (riesgos):** Prompt de consulta de bajo riesgo; el riesgo es que las URL o precios estén desactualizados, por eso las cifras se calcularon aparte (ver P12).
- **Decisión de uso (propuesta):** Aceptado.

## P9
- **Fecha:** 2026-09-14
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar)
- **Fase del SDLC:** Implementación (control de versiones)
- **Técnica de prompting utilizada:** Instrucción dirigida con confirmación explícita antes de acciones destructivas
- **Prompt utilizado:**

```
ROL: Responsable de control de versiones.
CONTEXTO: Los requisitos y casos de uso ya están listos en el repo de
documentación. Cada integrante debe aparecer como autor; la coautoría de
la IA debe quedar declarada en el mensaje del commit, no como autor.
TAREA: Crea la rama `docs/requisitos-priorizados`, haz commits atómicos
fechados el 7-sep 18:25, quita la coautoría de Claude de los cuatro
commits si así lo decido, y súbelos.
FORMATO: Muéstrame `git log --format=fuller` antes de empujar.
RIESGOS: Reescribir historia ya publicada exige force-push: pídeme
confirmación explícita y solo sobre esta rama.
```

- **Resultado obtenido:** Rama `docs/requisitos-priorizados` publicada con los commits de requisitos y casos de uso (visibles en `git log`, fecha 2026-09-07 18:25), tras un force-push confirmado.
- **Validación (riesgos):** La confirmación previa al force-push es el control humano sobre una operación destructiva. Nota para el equipo: el curso exige indicar el uso de IA en los commits; quitar la coautoría reduce esa trazabilidad, por lo que conviene documentarlo aquí.
- **Decisión de uso (propuesta):** Aceptado con ajustes. Pendiente de confirmación del autor.
