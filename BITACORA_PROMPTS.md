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

## P10
- **Fecha:** 2026-09-14
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar)
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Instrucción dirigida + Few-shot (plantilla `scope-template.md` de referencia) + Referencia por bloques (versionado en dos pasos con fechas)
- **Prompt utilizado:**

```
ROL: Arquitecto de software que documenta el modelo C4.
CONTEXTO: La rama `docs/arquitectura-c4-contexto` contiene el DSL
Structurizr y el PNG del diagrama. Existe una versión anterior del
diagrama (3-sep 18:33) y la actual (corregida tras la sustentación 1).
TAREA: Genera la ficha de alcance con la plantilla scope-template.md,
incrustando la imagen (no un enlace); versiona primero la imagen antigua
y luego la actual en commits separados.
FORMATO: `docs/arquitectura/scope.md`, commits `docs(arquitectura): ...`,
mensaje del segundo commit con la causa de la corrección.
RIESGOS: No alteres el DSL; si el diagrama no coincide con la plantilla,
avísame en vez de inferir contenido.
```

- **Resultado obtenido:** Commits `docs(arquitectura): primera version del diagrama de contexto (C4 nivel 1)` (3-sep) y `docs(arquitectura): agrega ficha de alcance del sistema (diagrama de contexto)` (visibles en `git log`).
- **Validación (riesgos):** La plantilla de referencia limita la estructura; la imagen incrustada evita enlaces rotos.
- **Decisión de uso (propuesta):** Aceptado.

## P11
- **Fecha:** 2026-09-14
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar)
- **Fase del SDLC:** Pruebas (validación del diseño)
- **Técnica de prompting utilizada:** Critique-and-Correct (la IA contrasta el diagrama con la retroalimentación del profesor y corrige) + Delimitadores (audios, video y documentos como fuentes)
- **Prompt utilizado:**

```
ROL: Revisor de arquitectura que audita contra criterios del profesor.
CONTEXTO: Fuentes: transcripción de la sustentación, documentos de
requerimientos y el DSL actual (`festa.dsl`).
TAREA: (1) Extrae los criterios que el profesor dio; (2) para cada
criterio indica cumple / no cumple con evidencia citada; (3) corrige el
DSL y regenera la imagen para los incumplimientos.
FORMATO: Tabla criterio / evidencia / estado / cambio aplicado, y diff del
DSL antes de commitear.
RIESGOS: No des por cumplido un criterio sin citar la fuente; separa lo
que dijo el profesor de lo que infieres.
```

- **Resultado obtenido:** Commit `docs(arquitectura): corrige diagrama de contexto segun feedback de la sustentacion` (visible en `git log`) con DSL e imagen actualizados.
- **Validación (riesgos):** Mitiga el sesgo de autoconfirmación al exigir evidencia por criterio. Riesgo residual: la transcripción puede contener errores de reconocimiento de voz.
- **Decisión de uso (propuesta):** Aceptado.

## P12
- **Fecha:** 2026-09-15
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar)
- **Fase del SDLC:** Diseño / Análisis
- **Técnica de prompting utilizada:** Instrucción dirigida con estructura narrativa indicada (comparativa → ganadora → arquitectura → viabilidad)
- **Prompt utilizado:**

```
ROL: Consultor que prepara una sustentación técnica para el profesor.
CONTEXTO: Se pide propuesta de arquitectura y casos de uso priorizados.
Imágenes de arquitectura ya existentes (ArquitecturaFesta.jpeg,
ContextoFesta.png). Las cifras de costo son supuestos propios.
TAREA: Construye el deck `.pptx` con: (1) matriz de costos por nube;
(2) nube ganadora y justificación; (3) arquitectura con la imagen
oficial; (4) viabilidad económica; (5) casos de uso priorizados.
FORMATO: Una diapositiva por punto, imágenes originales sin redibujar,
supuestos de costo marcados como tales.
RIESGOS: No inventes cifras ni rehagas diagramas; marca todo número sin
fuente como estimación.
```

- **Resultado obtenido:** `Sustentacion2/Festa_Sustentacion2.pptx`. El profesor aprobó la arquitectura pero indicó que los costos estaban mal estimados (p. ej. "$4 por 5000 usuarios"); un compañero recalculó los costos después.
- **Validación (riesgos):** El riesgo de números inventados se materializó: las cifras de costo generadas por la IA fueron rechazadas. Lección documentada: costear por transacción × uso proyectado, sin capas gratuitas.
- **Decisión de uso (propuesta):** Aceptado con ajustes (diapositivas de costos descartadas).

## P13
- **Fecha:** 2026-09-15
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar) con conector de Lucid
- **Fase del SDLC:** Análisis / Diseño
- **Técnica de prompting utilizada:** Few-shot (plantilla de simbología puesta encima de RF1) + Critique-and-Correct (ocho rondas de corrección visual)
- **Prompt utilizado:**

```
ROL: Analista que modela casos de uso UML en Lucidchart.
CONTEXTO: Documento "Festa", página "Casos de uso". Hay una plantilla de
simbología encima de RF1 (actor, óvalo, frontera del sistema). Los
requisitos están en `requirements.md`.
TAREA: Dibuja el diagrama de los RF1–RF10 clonando los elementos de la
plantilla (no recreándolos), con un actor por diagrama, casos de uso en
columna y flechas rectas; si hay cruce, usa un salto de línea.
FORMATO: Un marco por RF, mismas dimensiones, título "RFn – nombre" arriba
fuera del marco del sistema.
RIESGOS: Si no puedes duplicar la plantilla, dímelo para que yo la
duplique; no uses figuras "parecidas".
```

- **Resultado obtenido:** Diagramas de caso de uso de RF1–RF10 en la página "Casos de uso" de Lucid, con la simbología de la plantilla, flechas rectas y tamaños uniformes tras las correcciones de RF3, RF4, RF7 y RF9.
- **Validación (riesgos):** La plantilla como ejemplo evitó simbología inventada; sin ella, la primera versión se parecía pero no era igual. Revisión visual humana por cada RF.
- **Decisión de uso (propuesta):** Aceptado.

## P14
- **Fecha:** 2026-09-15
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar) con ffmpeg + Whisper (Groq)
- **Fase del SDLC:** Análisis
- **Técnica de prompting utilizada:** Instrucción dirigida con delimitadores (audio adjunto) + Critique-and-Correct sobre una limitación declarada
- **Prompt utilizado:**

```
ROL: Asistente de actas de la sustentación.
CONTEXTO: Audio de WhatsApp (.ogg) con la retroalimentación del profesor.
Tengo ffmpeg y una API de transcripción configurada localmente.
TAREA: Transcribe el audio, extrae las decisiones y correcciones
(especialmente de costos) y dime qué cambia respecto a lo que estimaste.
FORMATO: Transcripción completa + lista de acciones con responsable.
RIESGOS: Marca con [?] los pasajes ininteligibles; no completes cifras que
no se escuchen; no imprimas credenciales en la salida.
```

- **Resultado obtenido:** La IA primero indicó que no podía transcribir; después se reutilizó el flujo ffmpeg + Whisper ya instalado y se obtuvo la transcripción. Conclusión de costos: las cifras de la IA no eran las vigentes.
- **Validación (riesgos):** Contrastar con la capacidad real del entorno evitó una respuesta falsa de "no puedo". Riesgo: errores de transcripción; la transcripción se usa como apoyo, no como fuente única.
- **Decisión de uso (propuesta):** Aceptado.

## P15
- **Fecha:** 2026-09-16
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar)
- **Fase del SDLC:** Implementación (documentación)
- **Técnica de prompting utilizada:** Instrucción dirigida iterativa (Iterative Refinement) + Referencia por bloques
- **Prompt utilizado:**

```
ROL: Responsable de documentación del repo.
CONTEXTO: 19 diagramas de casos de uso en Lucid (RF1–RF10 míos, RF11–RF19
de otro integrante). Los títulos ya están reubicados fuera del recorte.
TAREA: Recorta/exporta los diagramas, súbelos a `docs/requirements/`
incrustados en `requirements.md` y reorganiza el documento por MoSCoW.
FORMATO: Dos commits separados por autor (RF1–RF10, luego RF11–RF19),
mensaje `docs(requisitos): ...`.
RIESGOS: Verifica que cada imagen corresponda a su RF antes de commitear;
no sobrescribas el trabajo del otro integrante.
```

- **Resultado obtenido:** Imágenes de casos de uso subidas al repositorio y `requirements.md` reorganizado por MoSCoW, con commits separados por integrante.
- **Validación (riesgos):** Commits separados por autor dan trazabilidad individual, que el profesor revisará semanalmente.
- **Decisión de uso (propuesta):** Aceptado.

---

## Etapa 3 — Backlog y Azure (21 de septiembre al 7 de octubre de 2026)

## P16
- **Fecha:** 2026-09-21
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar) con conector de Lucid
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Zero-shot de refinamiento visual
- **Prompt utilizado:**

```
ROL: Analista de procesos (BPMN 2.0).
CONTEXTO: Página "Proceso BPMN" del documento Lucid "Festa".
TAREA: Reorganiza el BPMN: carriles alineados, flujos sin cruces,
etiquetas legibles y gateways con condición escrita.
FORMATO: Muéstrame antes y después, y lista los cambios.
RIESGOS: No cambies la lógica del proceso ni los nombres de los actores.
```

- **Resultado obtenido:** BPMN reorganizado visualmente en Lucid [VERIFICAR enlace].
- **Validación (riesgos):** Cambio visual de bajo riesgo; se valida que la lógica del proceso no varíe.
- **Decisión de uso (propuesta):** Aceptado.

## P17
- **Fecha:** 2026-09-23
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Code (modelo por confirmar)
- **Fase del SDLC:** Implementación (documentación)
- **Técnica de prompting utilizada:** Instrucción dirigida
- **Prompt utilizado:**

```
ROL: Responsable de trazabilidad de IA del proyecto.
CONTEXTO: La bitácora debe seguir la plantilla del curso y consolidar los
prompts dispersos en varias ramas.
TAREA: Crea `docs/bitacora-prompts`, consolida allí las entradas
existentes sin alterarlas y deja la plantilla lista para recibir las demás.
FORMATO: Un commit `docs: consolida bitácora de prompts en rama dedicada`.
RIESGOS: No pierdas entradas existentes; muéstrame el diff antes de
empujar.
```

- **Resultado obtenido:** Commit `docs: consolida bitácora de prompts en rama dedicada` en la rama `docs/bitacora-prompts` (23-sep).
- **Validación (riesgos):** Verificado por `git log`; las entradas previas se conservaron.
- **Decisión de uso (propuesta):** Aceptado.

## P18
- **Fecha:** 2026-10-02
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Delimitadores (contexto en archivo adjunto) + Zero-shot
- **Prompt utilizado:**

```
ROL: Arquitecto de software.
CONTEXTO: Adjunto Festa.zip (requerimientos, pitch y sustentaciones). En
este mensaje solo quiero que lo asimiles.
TAREA: Resume en 10 líneas lo que entendiste y espera mi siguiente
instrucción antes de producir artefactos.
FORMATO: Lista de supuestos y preguntas abiertas.
RIESGOS: No generes diagramas ni archivos todavía.
```

- **Resultado obtenido:** La IA interpretó "contexto" como pedido de diagrama y pudo generar una estructura básica de arquitectura; el usuario aclaró que solo era contexto [VERIFICAR qué se generó]. Este malentendido motiva la mejora del prompt.
- **Validación (riesgos):** Un prompt sin tarea explícita causó trabajo no solicitado; pedir resumen y supuestos lo evita.
- **Decisión de uso (propuesta):** Descartado (el pedido real era solo dar contexto).

## P19
- **Fecha:** 2026-10-02
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code) con conector de Jira
- **Fase del SDLC:** Análisis
- **Técnica de prompting utilizada:** Persona (Business Analyst) + plantilla de historias de usuario + Instrucción dirigida iterativa
- **Prompt utilizado:**

```
ROL: Business Analyst / Product Owner del proyecto Festa.
CONTEXTO: Proyecto Jira desparcha2-festa. RF1–RF19, RNF1–RNF12 en
`requirements.md`, priorizados con MoSCoW. El profesor exige sprints de 2
semanas con corte vertical ejecutable (pantalla, endpoint real,
persistencia básica, prueba automatizada).
TAREA: Crea épicas, features, historias (formato "Como <rol> quiero
<acción> para <valor>" con criterios Gherkin) y tareas. Aún no
asignes sprints. Un color por épica.
FORMATO: Tabla jerarquía / clave / título / prioridad; lista de issues que
no pudiste crear o borrar, con enlace.
RIESGOS: No borres issues que yo no haya autorizado; no inventes
requerimientos fuera del documento.
```

- **Resultado obtenido:** Backlog base creado en Jira con épicas, features, historias y tareas; issues de ejemplo eliminados salvo algunos que el usuario borró manualmente por restricciones del conector; colores por épica. Los sprints quedaron pendientes para una fase posterior.
- **Validación (riesgos):** Verificación de los issues creados en Jira; mitiga requisitos vagos con criterios de aceptación explícitos.
- **Decisión de uso (propuesta):** Aceptado con ajustes (los sprints se definen después).

## P20
- **Fecha:** 2026-10-06
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code) con conector de Lucid
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Instrucción dirigida con contexto pegado (resumen de un chat anterior entre delimitadores) + Negative Constraints
- **Prompt utilizado:**

```
ROL: Arquitecto cloud (Azure).
CONTEXTO: Sustentación 2 usó GCP serverless + Supabase. Ahora el equipo
despliega en Azure. En el documento Lucid "Festa" la página "Arquitectura"
corresponde a otra arquitectura (AWS/ECS Fargate): no se toca.
TAREA: Crea una página nueva con la arquitectura de Festa en Azure,
mapeando cada componente (Cloud Run → Azure Container Apps o Functions,
Supabase Auth/PostgreSQL → equivalentes, FCM, Gemini, Wompi) con íconos de
Azure.
FORMATO: Tabla de equivalencias GCP→Azure y un diagrama por capas.
RIESGOS: No modifiques ni borres páginas existentes sin mi confirmación;
indica los servicios sin equivalente directo.
```

- **Resultado obtenido:** Diagrama de arquitectura en Azure en el documento Lucid; se identificó una página duplicada creada por error en otro chat y se eliminó con confirmación explícita del usuario.
- **Validación (riesgos):** Pegar el contexto del chat anterior evitó rehacer trabajo; la confirmación del usuario previno borrar la página equivocada.
- **Decisión de uso (propuesta):** Aceptado.

## P21
- **Fecha:** 2026-10-07
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Implementación (documentación)
- **Técnica de prompting utilizada:** Instrucción dirigida iterativa con decisión del usuario sobre el criterio de organización
- **Prompt utilizado:**

```
ROL: Responsable de trazabilidad de IA.
CONTEXTO: 117 mensajes del proyecto en `prompts_sesion.md`; plantilla y 4
entradas en `BITACORA_PROMPTS.md`; lineamientos del profesor (evidencia
mínima por prompt: fecha, autor, herramienta, modelo, prompt, respuesta,
decisión).
TAREA: Consolida los mensajes en entradas por tarea, en orden cronológico,
con técnica del curso, fase del SDLC, resultado real, riesgo mitigado,
decisión propuesta y una versión mejorada del prompt con rol, contexto,
tarea, formato y riesgos.
FORMATO: Misma plantilla; separa claramente el prompt original del
mejorado.
RIESGOS: No inventes resultados que no puedas verificar.
```

- **Resultado obtenido:** Esta versión de la bitácora.
- **Validación (riesgos):** Pedir resultados verificables y marcar lo no confirmado con [VERIFICAR] evita falsear el registro.
- **Decisión de uso (propuesta):** Aceptado.

## Etapa 4 — Pitch deck, videos y presentación final (12 al 15 de octubre de 2026)

## P22
- **Fecha:** 2026-10-12 (21:20)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code) con ffmpeg y Whisper (Groq)
- **Fase del SDLC:** Análisis
- **Técnica de prompting utilizada:** Delimitadores (audio adjunto como fuente) + Structured Output (lista de recomendaciones separadas por equipo y generales)
- **Prompt utilizado:**

```
ROL: Asistente de actas de la sesión de pitch decks.
CONTEXTO: Audio de 33 minutos (`Grabación estándar 220.mp3`) con la
retroalimentación del profesor a todos los equipos. El último equipo en
presentar es el nuestro (Festa).
TAREA: Transcribe el audio y recoge todas las recomendaciones, cambios y
retroalimentación del profesor, separando las que son específicamente para
Festa de las generales para todos los equipos.
FORMATO: Lista numerada para Festa y lista de consejos generales, lista para
copiar al grupo de WhatsApp del equipo.
RIESGOS: Marca lo que no quede claro en la transcripción; no atribuyas a
Festa comentarios dirigidos a otros equipos; no completes cifras que no se
escuchen.
```

- **Resultado obtenido:** Transcripción en dos tramos (ffmpeg + `whisper-large-v3`, el audio se procesó en memoria). Se obtuvieron 6 recomendaciones para Festa (más imágenes y gráficas, competencia con fuente, no explicar la cotización de nubes, indicadores con umbral, validar el problema con entrevistas, entrega) y 8 consejos generales. Se redactó el mensaje para WhatsApp.
- **Validación (riesgos):** La transcripción tenía ruido; el punto 6 (entrega) se marcó como no claro. Más tarde se contrastó de nuevo: el profesor pidió enviar la presentación "tal cual" y dejar las mejoras para el parcial.
- **Decisión de uso (propuesta):** Aceptado con ajustes (el punto 6 se aclaró después, ver P32).

## P23
- **Fecha:** 2026-10-13 (hora aproximada, 12:30)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Análisis (documentación del proyecto)
- **Técnica de prompting utilizada:** Iterative Refinement + Negative Constraints (no mencionar piloto, comisión ni cuestiones de negocio) + Few-shot (texto propuesto por otra IA como referencia)
- **Prompt utilizado:**

```
ROL: Redactor de fichas de proyecto para un concurso académico.
CONTEXTO: El formulario del curso pide nombre del proyecto, nombres de los
estudiantes (dos nombres y dos apellidos, con solo la inicial en mayúscula),
una descripción de 100 a 150 palabras (contexto del problema, solución
propuesta y elementos destacados) y un video de 30 a 45 segundos.
TAREA: Completa los datos con la información del README de la organización y
redacta la descripción de Festa. Versión 1: tono descriptivo. Versión 2: más
llamativa. Versión final: equilibrio entre ambas, sin hablar del piloto ni de
la comisión.
FORMATO: Texto de 100 a 150 palabras, sin lenguaje técnico ni publicitario
exagerado.
RIESGOS: No inventes nombres, logo ni enlace del video; cuenta las palabras
antes de entregar.
```

- **Resultado obtenido:** Descripción final de 126 palabras (problema: planes que se pierden y comercios sin visibilidad; solución: app con mapa, IA que recomienda y boleta con QR). Se entregaron nombre del proyecto y lista de estudiantes. Quedaron pendientes el logo y el enlace del video.
- **Validación (riesgos):** El conteo de palabras se verificó con `wc`. Los nombres salieron del README (no se inventaron segundos nombres). Se señalaron como pendientes los segundos nombres de Brayan y Sebastián.
- **Decisión de uso (propuesta):** Aceptado.

## P24
- **Fecha:** 2026-10-13 (hora aproximada, 13:05)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code) con HyperFrames
- **Fase del SDLC:** Implementación
- **Técnica de prompting utilizada:** Instrucción dirigida con preguntas de alcance previas (storyboard, modo, estilo, audio) + Critique-and-Correct (revisión de imágenes de cada escena)
- **Prompt utilizado:**

```
ROL: Director de video de producto.
CONTEXTO: Necesitamos el video de 30 a 45 segundos del formulario. Festa es
una app que reúne en un mapa los eventos de Bogotá, con IA que recomienda y
boleta con QR. El video no debe usar jerga técnica.
TAREA: Crea el video con HyperFrames: 7 escenas (gancho, problema, logo,
mapa, IA, comercios y boleta, cierre), estilo juvenil y colorido, solo texto
en pantalla, sin voz ni música por ahora.
FORMATO: MP4 16:9 de unos 41 segundos y una versión vertical 9:16 apta para
Shorts. Valida con `hyperframes check` y revisa una imagen de cada escena.
RIESGOS: No uses datos falsos (marca como ejemplo el evento del mapa); el
video debe poder reemplazarse luego por uno del equipo.
```

- **Resultado obtenido:** Proyecto `videos/festa-pitch` (16:9, 41 s) y `videos/festa-pitch-vertical` (9:16). Pasaron `check` (0 errores) y el contraste AA. El render desde el Studio falló y se resolvió con el CLI.
- **Validación (riesgos):** Se aclaró que un video con animaciones y voz sintética puede no cumplir "el equipo presenta la idea". Se eliminaron las versiones de prueba para dejar solo los dos videos definitivos.
- **Decisión de uso (propuesta):** Aceptado con ajustes (el equipo terminó entregando videos propios, ver P29).

## P25
- **Fecha:** 2026-10-13 (hora aproximada, 15:40)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Role + solicitud de alternativas divergentes (3 propuestas creativas antes de generar)
- **Prompt utilizado:**

```
ROL: Redactor de prompts para generación de video con IA.
CONTEXTO: Queremos usar Google Flow para un video corto de Festa (30 a 40
segundos, en español, público de jóvenes y universitarios).
TAREA: Entrega un prompt general, no escena por escena, que le pida a la IA
proponer 3 direcciones creativas distintas antes de generar el video final.
FORMATO: Un solo bloque de texto con problema, solución, público, tono,
restricciones y la instrucción de presentar las 3 opciones.
RIESGOS: Sin marcas ni personas reales identificables; texto en pantalla
correcto en español.
```

- **Resultado obtenido:** Se entregaron un prompt por escena y luego uno general con las tres propuestas.
- **Validación (riesgos):** No se ejecutó en Flow, por lo que no hay resultado que validar. Se advirtió que estas herramientas suelen fallar con la ortografía dentro de la imagen.
- **Decisión de uso (propuesta):** Descartado (no se usó en el entregable final).

## P26
- **Fecha:** 2026-10-13 (hora aproximada, 22:40)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code) con Kokoro, edge-tts y ElevenLabs
- **Fase del SDLC:** Implementación
- **Técnica de prompting utilizada:** Iterative Refinement con comparación de alternativas (muestras de voces) + Negative Constraints (la clave nunca se pega en el chat)
- **Prompt utilizado:**

```
ROL: Productor de audio para video de producto.
CONTEXTO: El video de Festa necesita voz en off en español y música de fondo.
La primera voz (Kokoro) sonó plana; probamos una voz colombiana (edge-tts) y
luego ElevenLabs. Uso mi cuenta gratuita de ElevenLabs.
TAREA: Genera 7 frases de narración sincronizadas con las escenas, una voz
más natural y una pista de música; compara voces con una muestra antes de
generar todo.
FORMATO: Un MP3 por escena, ajustado a la duración de cada escena; video
final con audio.
RIESGOS: La clave de API se guarda en un archivo local y no se escribe en el
chat; informa los créditos que se gastan; indica qué no está disponible en
el plan gratuito.
```

- **Resultado obtenido:** Voz de Jessica (ElevenLabs) elegida entre 3 muestras. Música sintética propia, porque la API de música es de pago. Video v3 con voz y música.
- **Validación (riesgos):** La clave quedó en `~/.config/elevenlabs/.env` y nunca se mostró. Se controlaron los créditos (unos 560 de 10.000). Una primera clave tenía el límite en 0 y se corrigió desde ElevenLabs.
- **Decisión de uso (propuesta):** Aceptado con ajustes (la voz sintética se mantuvo solo en el cierre de la IA, ver P31).

## P27
- **Fecha:** 2026-10-14 (hora aproximada, 00:05)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** System Persona (diseñador de presentaciones) + Delimitadores (archivos y retroalimentación entre bloques) + Structured Output
- **Prompt utilizado:**

```
ROL: Diseñador de presentaciones y consultor de pitch para startups.
CONTEXTO: Adjunto FESTA_Pitch.pptx (12 diapositivas), Guion_Pitch_Festa.docx
y la retroalimentación del profesor (más imágenes y gráficas, competencia
con fuente, sin cotizar nubes, indicadores con umbral, validar con
entrevistas, fotos del equipo, lenguaje no técnico).
TAREA: Genera un prompt para que otra IA mejore las diapositivas según esa
retroalimentación y el guion, con el diagnóstico concreto de cada diapositiva.
FORMATO: Bloque de prompt con rol, contexto, tarea, formato y restricciones.
RIESGOS: No inventes cifras; marca [CONFIRMAR] lo no definido (costos, nube
final) y [FOTO] las fotos del equipo.
```

- **Resultado obtenido:** Prompt largo con diagnóstico (diapositivas sin imágenes, costos en Google Cloud, indicadores solo en el guion, equipo sin fotos).
- **Validación (riesgos):** Se verificó el contenido real de las 12 diapositivas y del guion antes de redactar el diagnóstico. Se advirtió la contradicción entre "Google Cloud" y la decisión de desplegar en Azure.
- **Decisión de uso (propuesta):** Aceptado con ajustes (se aplicó luego con el conector de Pitch, ver P28).

## P28
- **Fecha:** 2026-10-14 (hora aproximada, 00:25)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code) con el conector de Pitch
- **Fase del SDLC:** Implementación
- **Técnica de prompting utilizada:** Delimitadores + Structured Output (estructura de 11 diapositivas con contenido exacto) + Negative Constraints (no inventar cifras, conservar marcadores)
- **Prompt utilizado:**

```
ROL: Diseñador de presentaciones para inversionistas jóvenes.
CONTEXTO: Rehacemos el pitch de Festa en Pitch con una plantilla coherente
(se eligió "Color Pop"). El contenido, las cifras y las fuentes son los del
deck actual y el guion.
TAREA: Crea 11 diapositivas (portada, problema, mercado, solución, así de
fácil, competencia, modelo de negocio, números, crecimiento, indicadores y
cierre) con gráficas, cifras grandes y notas del presentador.
FORMATO: Texto mínimo en pantalla; fuentes al pie; marcadores [CONFIRMAR] y
[FOTO] intactos; estilo juvenil.
RIESGOS: No inventes datos; sin nubes ni jerga técnica; revisa los
resultados del agente de Pitch contra la lista de verificación.
```

- **Resultado obtenido:** Presentación "FESTA" en Pitch (11 diapositivas) y varias ediciones con el agente. Los créditos de IA de Pitch se agotaron (100 de 100). Algunos defectos se corrigieron a mano en el editor (título tapado en la 9, numeración en la 5, tabla en la 6).
- **Validación (riesgos):** Se revisó cada diapositiva en pantalla con el navegador integrado y se encontraron defectos que el texto de la API no mostraba (solapes, texto pequeño). El agente no insertó dibujos animados.
- **Decisión de uso (propuesta):** Aceptado con ajustes (las fotos y el contenido sirvieron de base; la entrega final pasó a PowerPoint, ver P29).

## P29
- **Fecha:** 2026-10-14 (hora aproximada, 17:15)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code) con pptxgenjs
- **Fase del SDLC:** Implementación
- **Técnica de prompting utilizada:** Instrucción dirigida con corrección de alcance (el guion fija 6 secciones y la IA había creado 11 diapositivas) + Delimitadores (carpeta con videos y fotos)
- **Prompt utilizado:**

```
ROL: Diseñador de presentaciones.
CONTEXTO: El guion del pitch tiene 6 secciones, una por diapositiva. Tengo
en una carpeta 5 videos de mis compañeros (uno por sección), las fotos de
los 6 integrantes (nombradas con cada nombre) y mi presentación anterior.
TAREA: Rehaz la presentación en PowerPoint con una diapositiva por sección
del guion, más una de conclusiones y agradecimientos con las fotos. Incrusta
cada video en un lugar visible y actualiza las cifras para que coincidan con
lo que dicen los videos. Sin roles en la diapositiva final.
FORMATO: Archivo .pptx con notas del presentador y créditos.
RIESGOS: No repitas el error del número de diapositivas; señala cifras que
puedan contradecir al profesor; valida el archivo antes de entregarlo.
```

- **Resultado obtenido:** `Pitch.pptx` de 7 diapositivas (portada, problema, solución, competencia, modelo de negocio, indicadores y conclusiones) con 6 videos incrustados, fotos del equipo y cifras alineadas ($113 USD/mes de infraestructura y 17 meses con USD 2.000). Se extrajo el video de la portada desde el `Pitch.pptx` del usuario.
- **Validación (riesgos):** Se validó con `validate.py`, con mediciones de texto y exportando las diapositivas con PowerPoint. Se señaló que las cifras de costo son del equipo y que el profesor había cuestionado los costos anteriores.
- **Decisión de uso (propuesta):** Aceptado.

## P30
- **Fecha:** 2026-10-14 (hora aproximada, 19:30)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Implementación
- **Técnica de prompting utilizada:** Critique-and-Correct (revisión visual de cada diapositiva exportada desde PowerPoint) + Negative Constraints
- **Prompt utilizado:**

```
ROL: Revisor de calidad visual de presentaciones.
CONTEXTO: En PowerPoint, la imagen de la portada se ve distorsionada y la de
la diapositiva 5 se deforma; la diapositiva 4 tiene una imagen muy pequeña y
un hueco bajo la tabla; los videos hay que ponerlos a mano en "Iniciar:
Automáticamente"; el profesor prefiere imágenes tipo caricatura y las fotos
originales no estaban mal.
TAREA: Corrige los tamaños, haz que los videos y el audio arranquen solos,
combina fotos y dibujos animados y usa una portada que se integre.
FORMATO: Un solo `Pitch.pptx`; verifica abriendo el archivo en PowerPoint.
RIESGOS: No cambies textos ni cifras; no dejes el archivo corrupto; elimina
las versiones duplicadas.
```

- **Resultado obtenido:** Ilustraciones vectoriales propias (la generación de Canva salía en 200 px y sin créditos), fotos originales restauradas en las diapositivas 2, 3 y 6, y el video de la diapositiva 5 reconvertido (traía una marca de rotación de 90°). El inicio automático se logró editando el XML de cada diapositiva.
- **Validación (riesgos):** Un primer intento corrompió el archivo (identificadores repetidos entre el video y una forma decorativa); se detectó al abrirlo en PowerPoint y se corrigió. Se verificó, por diapositiva, que PowerPoint reconoce la acción de reproducir con inicio automático.
- **Decisión de uso (propuesta):** Aceptado con ajustes.

## P31
- **Fecha:** 2026-10-14 (hora aproximada, 21:00)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code) con ElevenLabs
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** System Persona (Festi, la IA de Festa) + Negative Constraints (no repetir información ya dicha) + Iterative Refinement
- **Prompt utilizado:**

```
ROL: Festi, la inteligencia artificial de Festa, encargada de cerrar y
convencer (tono publicitario, no una presentación lineal).
CONTEXTO: Las diapositivas y los videos del equipo ya explicaron el problema,
la solución, las cifras y el lema. La diapositiva 7 no tenía voz.
TAREA: Escribe y genera un audio de cierre que se presente, hable a
inversionistas, comercios y usuarios, y mencione que detrás hay seis socios.
No repitas lo ya dicho; pausa de 0,5 s al inicio y al final.
FORMATO: Audio MP3 con la voz elegida (Jessica), sin cifras de inversión,
con el texto en las notas del presentador.
RIESGOS: Avisa de las licencias publicitarias; evita "el comercio de tu
barrio" (no todos los negocios son del barrio de cada persona).
```

- **Resultado obtenido:** Audio de 38,4 s ("¿Sabes qué es lo mejor de un buen plan? Que no se te escape…" con invitación a invertir, a aliarse o a poner su negocio en el mapa, y la frase de los seis socios). Avatar de Festi como imagen del audio.
- **Validación (riesgos):** Pausas medidas con `silencedetect` (0,50 s al inicio y al final). No se incluyó ningún monto de inversión. Se descartaron tres voces alternativas.
- **Decisión de uso (propuesta):** Aceptado.


## P32
- **Fecha:** 2026-10-16 (hora aproximada, 22:30)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Análisis / Diseño
- **Técnica de prompting utilizada:** Few-shot (plantillas del laboratorio) + Instrucción dirigida + Iterative Refinement
- **Prompt utilizado:**

```
ROL: Analista funcional que redacta especificaciones para un equipo de
desarrollo o un agente de IA.
CONTEXTO: Laboratorio 2 del curso. Festa ya tiene RF1-RF19 y RNF1-RNF12
(requirements.md). Se entregan una plantilla de Mapa de Componentes (2.1) y
una de Especificación de Componente (2.2).
TAREA: Genera el Mapa de Componentes v1 (3-6 módulos, 2-5 componentes por
módulo, dependencias, qué entra al MVP) y la especificación de 5-7
componentes críticos, con RNF y criterios Dado/Cuando/Entonces. Cada
historia de usuario debe quedar cubierta. Después: entrega el texto para la
caja de respuesta, que admite máximo 10.000 caracteres.
FORMATO: Texto plano, sin tablas, con la plantilla del laboratorio.
RIESGOS: No inventar requisitos; marcar como supuestos los valores que no
estén en los requerimientos.
```

- **Resultado obtenido:** Mapa de 15 componentes en 5 módulos y 7 especificaciones críticas (Auth, Eventos y Geolocalización, Mapa, Boletería y QR, Wompi, Orquestador de IA, Panel de comercio), con tabla de trazabilidad HU → componentes. Versión comprimida de 8.209 caracteres para la caja de respuesta.
- **Validación (riesgos):** Trazabilidad HU → componente → criterio para detectar historias sin cobertura (HU-02 quedó cubierta solo de forma indirecta y se dejó anotado). Los valores que no venían de los requerimientos (10 solicitudes de IA por minuto, bloqueo tras 5 intentos fallidos, JWT de 1 h) se señalaron como supuestos para confirmar con el equipo. Conteo de caracteres verificado con un script.
- **Decisión de uso (propuesta):** Aceptado con ajustes. Después de la decisión de pasar a Azure (6 de octubre) se reemplazaron Supabase, Gemini y FCM por Entra External ID, Azure OpenAI y Notification Hubs en los dos archivos.


## P33
- **Fecha:** 2026-10-16 (hora aproximada, 22:50)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Implementación
- **Técnica de prompting utilizada:** Plantilla dirigida (template filling) + Delimitadores + Iterative Refinement
- **Prompt utilizado:**

```
ROL: Ingeniero que convierte una especificación en un prompt técnico para
una herramienta de vibe coding (Lovable).
CONTEXTO: Laboratorio 3. Se debe elegir un componente crítico del Laboratorio
2 y usar la plantilla de prompt de implementación (3.1). Componente elegido:
C4, Pantalla Mapa y filtros de Festa.
TAREA: Redacta el prompt inicial, un prompt refinado con las mejoras, la
sección de validación con los criterios de aceptación y una reflexión.
Todo debe caber en 10.000 caracteres.
FORMATO: Un solo bloque de texto para copiar en la caja de respuesta.
RIESGOS: No inventar resultados de una herramienta que aún no se ejecutó;
dejar espacios claros para pegar el código real y marcar los criterios.
```

- **Resultado obtenido:** Prompt inicial para generar en React + TypeScript + Leaflet el mapa con clústeres, filtros y confirmación de asistencia, con 3 criterios de aceptación; prompt refinado con casos límite (fechas inválidas, lista vacía, carga y error, pruebas); reflexión en borrador (unos 7.500 caracteres).
- **Validación (riesgos):** Las secciones de código generado y de validación se dejaron vacías a propósito, porque el prompt todavía no se había ejecutado en Lovable. La reflexión se marcó como borrador para ajustarla con el resultado real. Se advirtió que Lovable genera React y no Flutter, así que es un prototipo web.
- **Decisión de uso (propuesta):** Aceptado con ajustes. Queda pendiente ejecutarlo en Lovable y completar el código generado, la validación y la reflexión final.


## P34
- **Fecha:** 2026-10-21 (hora aproximada, 16:20)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Diseño / Planeación
- **Técnica de prompting utilizada:** Instrucción dirigida + Iterative Refinement (con verificación contra la herramienta)
- **Prompt utilizado:**

```
ROL: Líder técnico que organiza el backlog de Festa en Jira.
CONTEXTO: El profesor pidió planear cuatro sprints de una semana, cada uno
con un incremento funcional. El proyecto SCRUM en Jira ya tiene épicas
E0-E8, 26 historias (SCRUM-14 a 39) y subtareas. El Sprint 0 fue de
organización y diseño; el Sprint 5 es para lo que no entra al MVP.
TAREA: Acomoda las historias existentes en los sprints por dependencia
funcional (no por capa técnica), crea el Sprint 5, agrega puntos de historia
y prioridad, registra el trabajo ya hecho en el Sprint 0 y fija fechas
(Sprint 1 del lunes 19 al domingo 25 de octubre, y así sucesivamente).
FORMATO: Cambios directos en Jira a través del conector de Atlassian, con
un resumen por sprint.
RIESGOS: No duplicar issues ya cargados; no inventar responsables; avisar
qué puntos son estimaciones.
```

- **Resultado obtenido:** Reparto en Jira: Sprint 1 (infraestructura, CI/CD, RF1-RF3), Sprint 2 (observabilidad, RF4-RF6), Sprint 3 (RF7-RF9), Sprint 4 (RF10, RF11, RF15) y Sprint 5 para RF12-RF14 y RF16-RF19. Puntos de historia (26, 29, 16 y 26 por sprint) y prioridad según la etiqueta MoSCoW. Ocho tareas finalizadas en el Sprint 0 (SCRUM-118 a 125). Fechas del 19 de octubre al 15 de noviembre.
- **Validación (riesgos):** Antes de importar el CSV que la IA había generado, se revisó el backlog real y se vio que ya existía: se descartó el CSV para no duplicar 26 issues. Se leyó de nuevo el Sprint 1 después de mover las historias y se comprobaron las fechas en el tablero. El conector no permite crear sprints ni editar fechas, así que eso se hizo desde la interfaz.
- **Decisión de uso (propuesta):** Aceptado con ajustes. Los puntos de historia son estimaciones de la IA pendientes de planning poker, las subtareas no tienen sprint propio y faltan los responsables de cada historia.


## P35
- **Fecha:** 2026-10-22 (hora aproximada, 17:00)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Análisis / Diseño
- **Técnica de prompting utilizada:** Chain-of-Thought (comparación entre fuentes) + Instrucción dirigida
- **Prompt utilizado:**

```
ROL: Revisor que verifica la consistencia entre artefactos del proyecto.
CONTEXTO: Festa tiene requerimientos (requirements.md), Jira (historias y
subtareas), un documento de Lucid con el BPMN, la arquitectura en Azure y 19
casos de uso, y material de entrega (laboratorios y pitch). El usuario cree
que Jira está bien y que lo que se debe corregir es Lucid, pero deja la
decisión a la IA.
TAREA: Revisa que todo concuerde; si no, corrige lo que toque, ya sea Jira,
Lucid, ambos o ninguno. Después, aplica los cambios que propongas.
FORMATO: Lista priorizada de hallazgos con la acción para cada uno.
RIESGOS: No cambiar diagramas a ciegas ni asumir que la arquitectura vieja
sigue vigente; confirmar el estado actual antes de editar.
```

- **Resultado obtenido:** Hallazgos: la arquitectura de Lucid ya estaba en Azure (decisión del 6 de octubre) y Jira seguía en GCP, Supabase y Gemini, por lo que se corrigieron 12 issues de Jira; el título del caso de uso RF9 en Lucid estaba roto ("c") y se corrigió. Se crearon dos subtareas por privacidad (RNF5, Ley 1581) y se alineó el QR de eventos gratuitos entre requerimiento, Jira y BPMN.
- **Validación (riesgos):** Se contrastaron las tres fuentes, cada una con su exportación o lectura directa (PNG de Lucid, JQL en Jira). Al volver a leer Lucid se vio que otra persona ya había aplicado varios cambios del BPMN, y se revirtió una nota de la IA en SCRUM-28 que contradecía el diagrama. Queda como pregunta abierta el costo del pitch (USD 113 por mes, calculado para GCP).
- **Decisión de uso (propuesta):** Aceptado con ajustes. La decisión sobre el QR se alineó con el BPMN y el requerimiento; falta que el equipo confirme el costo de infraestructura con Azure.


## P36
- **Fecha:** 2026-10-22 (hora aproximada, 18:30)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Documentación
- **Técnica de prompting utilizada:** System Persona (contexto persistente) + Instrucción dirigida
- **Prompt utilizado:**

```
ROL: Asistente técnico que documenta el contexto del proyecto para otros
agentes de IA.
CONTEXTO: La carpeta raíz del proyecto no tenía un archivo de contexto. Se
debe buscar agents.md; si no existe, crear claude.md.
TAREA: Verifica si existe agents.md y, si no, crea claude.md con el contexto
del proyecto: qué es Festa, stack y arquitectura vigente, requerimientos,
Jira y sprints, Lucid, GitHub y carpetas, reglas del curso y convenciones.
FORMATO: Markdown en español, en la raíz del proyecto.
RIESGOS: No inventar datos del equipo ni de la universidad; no reintroducir
la arquitectura obsoleta (GCP, Supabase, Gemini).
```

- **Resultado obtenido:** CLAUDE.md creado en la raíz con el stack en Azure, los RF/RNF por prioridad, los sprints con fechas, los identificadores de Jira y Lucid, las reglas del curso (evidencia de prompts, commits marcados) y las convenciones. Se verificó antes que no existía agents.md ni claude.md en la raíz (solo los del proyecto de video).
- **Validación (riesgos):** Se buscó el archivo con una búsqueda sin distinguir mayúsculas antes de crearlo. Los datos sensibles o sin confirmar (nombres de los integrantes, costos) se dejaron fuera o marcados como pendientes de confirmar.
- **Decisión de uso (propuesta):** Aceptado.


## P37
- **Fecha:** 2026-10-25 (hora aproximada, 18:40)
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Chain-of-Thought (comparación de fuentes) + Instrucción dirigida + Iterative Refinement
- **Prompt utilizado:**

```
ROL: Arquitecto de software que mantiene alineados los artefactos del proyecto.
CONTEXTO: El 24 de octubre el equipo de desarrollo creó 11 repositorios nuevos
en la organización de GitHub (gateway, ocho servicios, app móvil y festa-infra
con RabbitMQ, Postgres, Mongo, Redis y Prometheus/Grafana). La arquitectura de
Lucid (3 servicios en Azure) y Jira (GCP/Azure, Monitor) no coincidían con
esa estructura. El equipo decidió manejar todo según los repositorios nuevos
y la observabilidad con Prometheus y Grafana.
TAREA: Revisa la organización de GitHub y, si hace falta, modifica Lucid y
Jira para que coincidan con lo planteado en los repositorios.
FORMATO: Diagrama de arquitectura nuevo en Lucid, carriles del BPMN con los
nombres de los servicios, y cambios en las historias y subtareas de Jira,
con un resumen de lo que queda por definir.
RIESGOS: No inventar decisiones que los repositorios no dicen (nube de
despliegue, almacén por servicio, proveedor de LLM); no borrar la
arquitectura anterior sin dejar rastro; no tocar los repositorios.
```

- **Resultado obtenido:** Página nueva "Arquitectura" en Lucid con el gateway, los ocho servicios, festa-mobile, festa-infra y los terceros (Google, Wompi, proveedor de LLM, FCM/APNs, Mapbox); la página anterior quedó como "Arquitectura Azure (anterior)". Carriles del BPMN renombrados con los repos. En Jira, 12 issues con los textos de GCP/Azure reemplazados, la infraestructura reescrita (SCRUM-14, 40 a 44) y etiquetas festa-* en 19 historias. Observabilidad con Prometheus y Grafana en SCRUM-16 y 47.
- **Validación (riesgos):** Se leyeron los 11 repositorios con la CLI de GitHub (solo README, sin código) y el diagrama se contrastó con sus descripciones. Las piezas que los repos no definen se marcaron como "por definir" en el diagrama (plataforma de despliegue, almacén por servicio, proveedor de LLM). Se verificó cada diagrama con una exportación a imagen y cada cambio de Jira con la respuesta de la herramienta; una primera versión del diagrama tenía líneas cruzadas y se corrigió.
- **Decisión de uso (propuesta):** Aceptado con ajustes. Queda pendiente que el equipo decida la plataforma de despliegue y los almacenes por servicio, asigne repo a RF13, RF14 y RF16-RF18, y revise la estimación del Sprint 1, que ahora incluye RabbitMQ, Mongo, Redis y el gateway.

## Etapa 5 — Arquitectura, DevSecOps y retroalimentación del profesor (25 al 26 de octubre de 2026)

## P38
- **Fecha:** 2026-10-25
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Instrucción dirigida + Iterative Refinement
- **Prompt utilizado:**

```
ROL: Arquitecto de software que documenta con el modelo C4.
CONTEXTO: El equipo desplegará en Azure y ya tiene la arquitectura en Lucid. El usuario pidió acoplar el diagrama de Azure con la estructura de los repositorios nuevos y generar los diagramas C4 con el DSL oficial de Structurizr, no con PlantUML.
TAREA: Crear la rama docs/arquitectura-c4 con los diagramas de contexto, contenedores y componentes, un documento de alcance siguiendo la plantilla de referencia y la estructura de directorios organizada.
FORMATO: festa.dsl, alcance.md, README.md e imágenes PNG exportadas con la imagen oficial de Docker de Structurizr.
RIESGOS: No inventar decisiones que los repositorios no dicen; no cerrar el PR abierto al renombrar la rama; no usar un generador distinto al oficial.
```

- **Resultado obtenido:** Rama docs/arquitectura-c4 con el modelo en DSL, cuatro vistas exportadas, la vista dinámica de compra y el documento de alcance. La primera versión con PlantUML fue rechazada y se rehízo con Structurizr. Al renombrar la rama se cerró el PR #1 y hubo que abrir el PR #2.
- **Validación (riesgos):** Se validó el DSL con structurizr-cli y con el servidor oficial (que fue más estricto y obligó a declarar relaciones explícitas). Cada imagen se revisó tras exportarla. Se quitó la vista de despliegue porque ya vive en Lucid.
- **Decisión de uso (propuesta):** Aceptado con ajustes. Lección: confirmar antes de borrar una rama con un PR abierto.

## P39
- **Fecha:** 2026-10-25
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Implementación
- **Técnica de prompting utilizada:** Instrucción dirigida
- **Prompt utilizado:**

```
ROL: Ingeniero DevSecOps que prepara la base de trabajo de la organización.
CONTEXTO: La organización Desparcha2-SWNT tiene los repositorios con solo README y el profesor exige CI/CD, convenciones de ramas y evidencia de revisión semanal.
TAREA: Preparar archivos base reutilizables: guía de contribución, política de seguridad, plantillas de PR e issues, flujo reutilizable de CI con análisis Trivy, plantillas de workflow, plantilla de CODEOWNERS y ADR.
FORMATO: Rama chore/base-devsecops con archivos Markdown y YAML, y un PR.
RIESGOS: No tocar los repositorios de los servicios; no incluir secretos; no imponer decisiones del equipo (motor de base de datos, plataforma) como definitivas.
```

- **Resultado obtenido:** PR #3 con CONTRIBUTING.md, SECURITY.md, plantillas, ci-reusable.yml, workflow-templates, ADR 0000 (plantilla) y el índice de ADR con 0001 y 0002 como pendientes.
- **Validación (riesgos):** Se revisó la sintaxis de los YAML y que los ADR marcaran como pendiente lo que el equipo no ha decidido.
- **Decisión de uso (propuesta):** Aceptado con ajustes. Pendiente que el equipo revise y fusione el PR.

## P40
- **Fecha:** 2026-10-25
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Análisis
- **Técnica de prompting utilizada:** Instrucción dirigida + Iterative Refinement
- **Prompt utilizado:**

```
ROL: Analista que mantiene los casos de uso alineados con los requisitos.
CONTEXTO: Los 19 casos de uso están en Lucid y requirements.md debe mostrar cada uno. El usuario quiere solo el diagrama, sin título de RF, sin include ni extend, sin el enlace "Editar en Lucid" ni "Plantilla base".
TAREA: Actualizar los diagramas de caso de uso en Lucid, exportarlos y enlazar cada imagen en la ficha del RF correspondiente en la rama docs/requisitos-priorizados.
FORMATO: PNG por RF en docs/requirements/casos-de-uso/ y una sola imagen por ficha en requirements.md.
RIESGOS: Recortes que cortan actores o incluyen títulos; relaciones inventadas; perder la información de las fichas.
```

- **Resultado obtenido:** Diagramas RF01 a RF19 recortados y enlazados. Se necesitaron varias iteraciones porque los recortes tenían barras negras, cortaban etiquetas de actores o incluían el título. El usuario corrigió además la lectura de las flechas entre actores.
- **Validación (riesgos):** Se revisó cada recorte a ojo y se limitaron los márgenes a los bordes de la imagen. Se mantuvo la semántica del usuario sobre las flechas.
- **Decisión de uso (propuesta):** Aceptado con ajustes.

## P41
- **Fecha:** 2026-10-25
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Diseño
- **Técnica de prompting utilizada:** Instrucción dirigida
- **Prompt utilizado:**

```
ROL: Arquitecto de datos que diagrama por microservicio.
CONTEXTO: Las clases y la base de datos no se harán en C4 sino en Lucid, en el mismo archivo principal, una página por microservicio con base propia. Los documentos de Lucid sueltos deben eliminarse.
TAREA: Crear en el documento Festa un diagrama de clases y uno de base de datos por servicio (auth, user, event, booking, payment, ai) y pasar las hojas de los otros documentos al original.
FORMATO: Seis páginas "Clases y BD · servicio" con clases UML y esquema entidad-relación.
RIESGOS: Mezclar tablas de servicios distintos; dejar documentos huérfanos; esquemas que contradigan los requisitos.
```

- **Resultado obtenido:** Seis páginas en el documento principal. Tres documentos sueltos quedaron renombrados "[ELIMINAR]" porque el conector no permite borrarlos.
- **Validación (riesgos):** Se exportó cada página a imagen para revisar solapamientos y títulos desbordados, que se corrigieron.
- **Decisión de uso (propuesta):** Aceptado con ajustes. El usuario debe borrar los tres documentos sueltos.

## P42
- **Fecha:** 2026-10-25
- **Autor:** Juan Sebastián Guayazán Clavijo
- **Herramienta/Modelo:** Claude Sonnet 5.5 (Claude Code)
- **Fase del SDLC:** Análisis
- **Técnica de prompting utilizada:** Instrucción dirigida
- **Prompt utilizado:**

```
ROL: Líder técnico que organiza el trabajo del equipo.
CONTEXTO: Jira tiene el backlog cargado pero sin responsables. Los repositorios de la organización tienen descripciones heterogéneas y no tienen rama develop.
TAREA: Asignar trabajo a los 6 integrantes en el Sprint 1; cambiar la descripción de los repositorios sin incluir RF y crear las ramas main y develop sin ningún otro cambio.
FORMATO: Asignaciones en Jira y una comparación entre las descripciones antes y después, para que el usuario confirme antes de aplicar.
RIESGOS: Asignar a personas equivocadas; modificar contenido de los repositorios; aplicar sin confirmación.
```

- **Resultado obtenido:** Cinco integrantes con tareas del Sprint 1 y un sexto sin tareas. Descripciones actualizadas y ramas develop creadas tras la confirmación del usuario.
- **Validación (riesgos):** Los integrantes se leyeron de Jira (no se inventaron). Los cambios en los repositorios se aplicaron solo tras mostrar la comparativa y recibir el "aplícalo tal cual".
- **Decisión de uso (propuesta):** Aceptado con ajustes. Las asignaciones las hizo el agente y el equipo no las ha confirmado.

