# Festa — contexto del proyecto (equipo Desparcha2)

Fuente de contexto para cualquier agente de IA que trabaje aquí. Si algo choca con lo que diga el equipo o el profesor, manda el equipo. El historial detallado (rondas de revisión de PR, decisiones fechadas, estado por repo) está en el repo de documentación, rama `docs/contexto-ia`, carpeta `docs/contexto-ia/`. Léelo solo cuando necesites el detalle de un PR o de una decisión.

## Qué es Festa
App móvil para descubrir eventos en Bogotá y dar visibilidad a comercios locales. Piloto con estudiantes de la Escuela Colombiana de Ingeniería Julio Garavito. Lema: "Menos buscar, más vivir la ciudad."

- **Curso:** ISIS, grupos SWNT-1/101, SWNT-2/201, SWNT-3/301. Periodo 2026-2.
- **Equipo:** Desparcha2 (seis integrantes). Correo del proyecto: `Desparcha2@pruebacorreoescuelaingeduco.onmicrosoft.com`.
- **Logo:** `logo_festa_cuadrado_*.png` (GitHub) y `Presentacion_Pitch_Festa/assets/logo_festa.png` (transparente). Texto negro y corona rosa (#F0127E): necesita fondo claro.

## Arquitectura (decidida el 2026-10-25)
Microservicios en la organización `Desparcha2-SWNT`:
- `festa-mobile`: app Flutter (usuario y vista de comercio). Mapa con Mapbox.
- `festa-gateway`: Kong 3.9 DB-less, enrutamiento, JWT y rate limiting.
- `festa-auth-service`: RF1, registro y login con correo y Google, emite el JWT.
- `festa-user-service`: RF2 y RF3, perfiles, preferencias y verificación manual de comercios.
- `festa-event-service`: RF4, RF5, RF6 y RF19, eventos, mapa y Parches en Vivo (PostgreSQL con PostGIS).
- `festa-booking-service`: RF7 y RF10, asistencia y QR de un solo uso.
- `festa-payment-service`: RF11, cobros con Wompi. Modelo oficial de monetización: el de `adjuntos/documentos/2026-11-16_festa-pg-ia-swnt-costos.xlsm` (suscripción Festa Pro con cupo de IA y overage; comisión por boleta fuera del modelo, es upside). No usar la comisión del 8 % anterior.
- `festa-ai-service`: RF8 y RF9, recomendaciones y descripciones con IA (LLM: Gemini).
- `festa-notification-service`: RF12, push (fase 2).
- `festa-analytics-service`: RF15, conteos para el panel de comercio.
- `festa-infra`: Docker Compose, RabbitMQ con contratos de mensajes en `contracts/`, Redis, Prometheus, Grafana y Terraform.

**Reglas de arquitectura:**
- Una base de datos por servicio. Ningún servicio lee la base de otro. No reintroducir un PostgreSQL o MongoDB compartido.
- Mongo corre **sin replica set**: no hay transacciones multi-documento. Las escrituras atómicas se resuelven con una sola escritura condicional por documento. Las escrituras que requieren transacciones (outbox y efectos) quedan pendientes de la decisión del equipo sobre el replica set (SCRUM-130).
- PostgreSQL 16 en todos los ambientes (`gen_random_uuid()` nativo; no hace falta `pgcrypto`).
- Despliegue en **AWS** (ADR 0001, región us-east-1): ECS Fargate, RDS PostgreSQL, ElastiCache, ALB con HTTPS, imágenes en GHCR, Gemini externo. Es un AWS Academy Learner Lab: sin Amazon MQ ni DocumentDB, sin roles IAM propios (solo `LabRole`), credenciales que vencen cada sesión.
- Distribución del front: APK de release en GitHub Release con QR (SCRUM-133). La URL del backend cambia en cada despliegue y el APK la lleva grabada. Sin Firebase, web ni iOS por ahora.
- Obsoletos, no reintroducir: Azure Container Apps y la arquitectura GCP/Supabase.

## Requerimientos (`.github/docs/requirements/requirements.md`)
19 RF y 12 RNF, prioridad MoSCoW.
- **Must:** RF1, RF2, RF3, RF4, RF5, RF8, RF9, RF10, RF11.
- **Should:** RF6, RF7, RF12, RF14, RF15.
- **Could:** RF13, RF19.
- **Won't (roadmap):** RF16, RF17, RF18.
- RNF clave: mapa en menos de 2 s, ubicación solo con consentimiento (Ley 1581), QR único y de un solo uso, IA con límite por usuario y descripciones persistidas.

## Jira
- Sitio: `https://desparcha2.atlassian.net`, proyecto **SCRUM "Festa"**, tablero 1.
- Épicas SCRUM-5 a 13; historias SCRUM-14 a 39; subtareas SCRUM-40 a 117; Sprint 0 SCRUM-118 a 125.
- Sprints de una semana, de miércoles a miércoles. Sprint 5 ("no se hará") agrupa lo que no entra al MVP.
- **Regla de estados (regla general del usuario):** una tarea pasa a **En revisión** (id 31) cuando su PR está hecho y se están haciendo las correcciones. Pasa a **Hecha / Finalizado** (id 41) solo cuando el PR se acepta en `develop`.
- Los puntos de historia son estimaciones pendientes de planning poker.
- Las descripciones de subtareas siguen el formato «Qué es», «Dónde», «Depende de», «Desbloquea a», «No incluye» y «Terminado cuando».

## Lucid, Figma y diagramas
- **Lucid:** documento "Festa", id `e18b5b62-ac62-4f8c-8e96-0049d0a7a8ee`. Todo lo de diagramación va en este único documento. Una página de clases y BD por cada servicio con base propia. "Arquitectura" es el modelo C4; "despliegue" es la página "Despliegue en AWS (oficial)".
- **Figma:** "Festa — Diseño de la app", clave `pfQHNthJdifeQQSD6blXVo`. Está en la cuenta personal del usuario; el equipo solo tiene lectura. Tipografías Bricolage Grotesque (títulos) y Plus Jakarta Sans (texto). Magenta `#F0127E` y tinta `#111111`. El texto sobre magenta va en negro (contraste AA).
- **Diagramas C4 (Structurizr):** rama `docs/arquitectura-c4` (PR #2), carpeta `docs/arquitectura/`.

## GitHub
- Organización `Desparcha2-SWNT`. Repo de documentación: `.github`.
- **Flujo de integración:** toda rama de trabajo apunta primero a `develop`. Después de validarse allí, se promueve a `main`.
- **Quién aprueba y fusiona:** las aprobaciones y fusiones las hace el usuario o el autor del PR de otra persona, nunca el agente. Un PR del propio usuario necesita la aprobación de otra persona.
- Los PR de compañeros en curso no se modifican sin que el usuario lo pida. Cuando lo pide, primero se verifica el cambio contra este archivo y `develop`, y solo después se corrige y se comenta.

## Reglas de trabajo
- **Responder y documentar en español.**
- **Alineación antes de tocar un PR:** antes de corregir, revisar o aprobar algo, contrastarlo con este archivo y con `develop`. Si el cambio es incongruente o no aporta a la finalidad del proyecto, argumentarlo en un comentario del PR. Si es necesario y encaja, hacerlo y comentar qué se cambió.
- **Comentarios en PR:** la cuenta `JuanGuayazanC` es el propio usuario. No mencionarla como tercero ni nombrar otras IAs en los comentarios. Las menciones a compañeros (`@MAGG0059`, `@brloa05`, `@cntrIsaac`) sí son reales.
- **Commits:** conventional commits con la clave de Jira. Sin trailer `Co-Authored-By` en los commits del usuario. No hacer force-push sin aprobación del usuario.
- **Costos:** calcular por transacción y uso proyectado, sin capas gratuitas. El costo de desarrollo no es costo de operación.
- **Adjuntos del usuario** (transcripciones, audios, imágenes, PDF): van en `adjuntos/` con nombre `AAAA-MM-DD_tema.ext`.
- **No inventes datos del equipo ni de la universidad; pregunta.**
- **Mantén este archivo al día:** cuando haya una decisión o un estado nuevo relevante, actualiza la sección correspondiente con fecha. Las rondas de revisión van al historial, no aquí.

## Reglas del curso
- Cada sprint entrega un corte vertical ejecutable (pantalla, endpoint real, persistencia y prueba automatizada) y se demuestra al final.
- El uso de IA en el proceso se documenta con evidencia: fecha, autor, herramienta, modelo, prompt, respuesta y decisión (bitácora `.github/BITACORA_PROMPTS.md`).
- Los commits con código generado por IA deben indicarlo. El aporte de cada integrante debe ser equitativo.

## Presentaciones
Hay dos presentaciones con roles distintos. No mezclar contenido entre ellas.
- **Parte teórica (clase, producto y comercial):** `Presentacion_Pitch_Festa/PitchDeck.pptx`, pitch de 7 diapositivas, sin videos. Se genera con `node build7.js`. Se presenta en vivo. Cubre problema, solución, competencia, modelo de negocio e indicadores.
- **Parte práctica (laboratorio, diagramación y programación):** `Sustentacion2/Festa_Sustentacion2.pptx`, presentación única de entregas y sustentaciones, generada con `node build.js`. Se modifica en cada entrega, sin copias. Aquí van la demo, la arquitectura y los avances técnicos.
- `videos/festa-pitch-vertical/`: video vertical en HyperFrames. Sus propios `AGENTS.md` y `CLAUDE.md` son de esa herramienta, no de Festa.

## Dónde buscar el detalle
- Estado y rondas de revisión de PR, decisiones fechadas, pendientes por repo: `docs/contexto-ia/CLAUDE.md` en la rama `docs/contexto-ia` del repo `.github`.
- Requerimientos completos: `.github/docs/requirements/requirements.md`.
- Sprints: `.github/docs/sprints/`.

## Skill routing

When the user's request matches an available skill, invoke it via the Skill tool. Route only to skills in the session's available-skills list; answer directly for quick questions or small scoped edits.

Key routing rules:
- Product ideas/brainstorming → invoke /office-hours
- QA/testing site behavior → invoke /qa
- Code review/diff check → invoke /review
- Ship/deploy/PR → invoke /ship

Do not suggest or auto-invoke other skills: they run when the user types them, or when a running skill hands off to them (`gstack-config set proactive all` routes every skill).

---

# Actualización de contexto — 2026-11-18

Esta sección incorpora decisiones de producto, seguimiento de Jira y lineamientos de presentación consolidados al 18 de noviembre de 2026. Cuando una descripción histórica anterior contradiga una decisión explícita de esta sección, prevalece esta actualización. Los estados de Jira que se indican son una fotografía de la revisión realizada ese día; deben consultarse de nuevo antes de afirmar que una tarea sigue en el mismo estado.

## Identidad, posicionamiento y alcance del producto

- **Lema oficial:** «Menos buscar, más vivir la ciudad». No sustituir por «Descubre tu próximo plan».
- Festa es una **plataforma móvil para descubrir eventos en Bogotá y conectar a asistentes con organizadores y comercios locales**. El piloto se realiza con la comunidad de la Escuela Colombiana de Ingeniería Julio Garavito, pero el producto no es exclusivo de la universidad.
- El problema central es la dispersión de la información de eventos entre redes sociales y distintas plataformas. Esto dificulta encontrar actividades cercanas y relevantes; organizadores y comercios también necesitan herramientas para publicar y gestionar sus eventos y llegar a potenciales asistentes.
- No reducir la propuesta de valor a una boletera ni a un chatbot. El núcleo es el descubrimiento de actividades, la conexión entre asistentes y organizadores y el acceso a eventos desde una experiencia móvil integrada.
- La geolocalización requiere consentimiento explícito. Si la persona no concede permiso o la ubicación no está disponible, el mapa debe utilizar la ubicación predeterminada del piloto en la Escuela Colombiana de Ingeniería. No afirmar que la aplicación obtiene automáticamente la ubicación sin consentimiento.

## Modelo de negocio vigente

- El modelo principal definido es **suscripción Festa Pro**, que incluye un cupo de uso de inteligencia artificial y cobra por consumo excedente (*overage*).
- La comisión por venta de entradas puede considerarse una oportunidad adicional de ingresos (*upside*), pero **no debe presentarse como el modelo principal**.
- La comisión del 8 % y el reparto 92/8 aparecen en una historia técnica antigua de Jira (SCRUM-27). Esa historia no sustituye la decisión comercial más reciente de Festa Pro. La discrepancia debe mantenerse visible hasta que el equipo alinee formalmente la historia y sus criterios.
- Mantener separados el flujo técnico de compra/procesamiento de pagos con Wompi y el modelo comercial Festa Pro. No inferir precios de suscripción, cupos exactos ni tarifas que no estén documentados en una decisión vigente del equipo.

## Alcance del MVP y decisiones funcionales

- **Mapa:** el mapa permite explorar eventos cercanos, mostrar marcadores y abrir el detalle del evento. La decisión vigente para el MVP es no implementar WebSockets/WSS para actualizaciones en tiempo real. En la demo, el mapa se actualiza al abrirse y al moverlo; no describirlo como un mapa con actualización en tiempo real.
- Aunque los criterios originales de SCRUM-23 mencionan actualizaciones en tiempo real, la subtarea SCRUM-76 asociada a WSS fue retirada del alcance del MVP. No reintroducirla como compromiso de entrega sin una nueva decisión del equipo.
- **Búsqueda y filtros:** contemplan categoría, zona y fecha.
- **Comercios:** el perfil de comercio requiere verificación manual por el equipo. Solo los comercios aprobados pueden publicar eventos.
- **Eventos:** organizadores autenticados y comercios aprobados pueden crear y gestionar eventos.
- **IA:** las recomendaciones conversacionales consideran intereses y eventos disponibles cercanos y deben enlazar a los eventos recomendados. Gemini es el proveedor LLM escogido. La generación de descripciones propone un texto que el organizador puede revisar, editar o regenerar.
- **Asistencia y entradas:** se contempla confirmar asistencia, emitir un QR único firmado y de un solo uso, mostrarlo en la aplicación y validarlo en el acceso por parte del organizador. La compra de entradas contempla Wompi.
- **Fuera del MVP:** RF18 de reputación/visibilidad pagada y posicionamiento promocionado permanece fuera de alcance (*Won't*). La finalidad general de dar visibilidad a comercios locales no debe confundirse con una funcionalidad de publicidad o posicionamiento pagado.
- Distinguir siempre entre funcionalidad especificada, en desarrollo, con PR abierto, fusionada en `develop` y probada en la demo. Una historia o subtarea de Jira no demuestra por sí sola que el código esté integrado u operativo.

## Revisión de Jira — fotografía al 2026-11-18

Se revisaron las historias y subtareas relacionadas con comercio, eventos, mapa, búsqueda, IA, pagos y QR en el proyecto SCRUM:

| Elemento | Alcance | Estado observado |
|---|---|---|
| SCRUM-19 (RF3) | Perfil de comercio y verificación manual | En revisión |
| SCRUM-20 (RF4) | Crear y gestionar eventos | En curso |
| SCRUM-23 (RF5) | Mapa interactivo de eventos | Por hacer |
| SCRUM-73 | Mapbox y ubicación del usuario en mobile | En revisión |
| SCRUM-74 | Consulta PostGIS de eventos cercanos | Por hacer |
| SCRUM-75 | Marcadores y detalle del evento | En revisión |
| SCRUM-76 | WSS para actualización en tiempo real | Por hacer; retirado del MVP |
| SCRUM-127 | Consentimiento y ubicación predeterminada | En revisión |
| SCRUM-25 (RF6) | Búsqueda y filtros | Por hacer |
| SCRUM-26 (RF11) | Compra de entradas con Wompi | Por hacer |
| SCRUM-27 | Reparto de comisión 92/8 | Por hacer; mantener como discrepancia frente a Festa Pro |
| SCRUM-28 (RF10) | Generación de QR único de entrada/asistencia | Por hacer |
| SCRUM-29 (RF10) | Escaneo y validación del QR en el acceso | Por hacer |
| SCRUM-30 (RF8) | Recomendaciones conversacionales con IA | En revisión |
| SCRUM-31 (RF9) | Generación de descripciones de eventos con IA | Por hacer |

Esta tabla es una referencia histórica de la revisión del 18 de noviembre, no una afirmación del estado actual. Antes de preparar una entrega, demo o exposición, comprobar Jira, las PR y la rama de integración correspondiente.

## Presentaciones y narrativa

Se mantienen **dos presentaciones independientes**, con objetivos y contenidos distintos:

1. **Pitch teórico/comercial:** `Presentacion_Pitch_Festa/PitchDeck.pptx`, máximo 7 diapositivas, se presenta en vivo y sin videos. Se genera con `node build7.js`. Su narrativa debe vender la propuesta: problema, oportunidad/usuarios, solución, diferenciación/competencia, modelo de negocio, indicadores y equipo/cierre. No convertirlo en una explicación de microservicios.
2. **Sustentación técnica/práctica:** `Sustentacion2/Festa_Sustentacion2.pptx`, presentación única para entregas y sustentaciones, generada con `node build.js`. Se actualiza en cada entrega sin crear copias. Incluye demo, arquitectura, diagramación, programación, avances y evidencias técnicas.

Lineamientos para el pitch:
- Usar siempre el lema oficial.
- Presentar Festa Pro con cupo de IA incluido y cobro por excedente como modelo principal. No presentar el 8 % como ingreso principal.
- No afirmar que una funcionalidad está disponible si solo está especificada o planificada.
- La ubicación inicial del piloto puede ser la Escuela Colombiana de Ingeniería; no prometer geolocalización sin consentimiento.
- La inclusión del equipo con fotos, nombres y roles cerca del cierre es una recomendación narrativa, no una decisión obligatoria del equipo.
- El video vertical de referencia compartido fue `https://youtube.com/shorts/EBw-YxjBQlQ`; no se verificó su contenido, por lo que no se deben inventar elementos visuales, lema o narrativa atribuidos a ese video.

## Descripción de referencia para jurados

Usar la siguiente descripción como base cuando se solicite presentar el proyecto, ajustando los verbos al estado real de implementación:

> **Festa — Menos buscar, más vivir la ciudad.** Actualmente, encontrar eventos y planes de interés puede convertirse en una tarea dispersa, ya que la información se encuentra distribuida entre redes sociales y diferentes plataformas. Esto dificulta que las personas descubran actividades cercanas que se ajusten a sus gustos, mientras que los organizadores necesitan mejores herramientas para publicar sus eventos y llegar a potenciales asistentes.
>
> Festa busca resolver esta necesidad mediante una plataforma móvil que centraliza el descubrimiento y la gestión de eventos, iniciando con un piloto en la comunidad de la Escuela Colombiana de Ingeniería. Los usuarios podrán explorar eventos activos y próximos mediante un mapa interactivo, buscar y filtrar actividades por categoría, zona y fecha, y recibir recomendaciones conversacionales apoyadas en inteligencia artificial según sus intereses y los eventos disponibles. Por su parte, los organizadores podrán registrar y verificar sus perfiles de comercio, publicar y gestionar eventos, y utilizar herramientas de inteligencia artificial para generar sus descripciones. La plataforma contempla además la confirmación de asistencia, la compra de entradas mediante Wompi y el ingreso a los eventos mediante códigos QR únicos y verificables.
>
> El modelo de negocio de Festa se basa en una suscripción Festa Pro que incluye un cupo de uso de inteligencia artificial y contempla cobros por consumo excedente. De esta manera, Festa busca conectar a quienes desean encontrar nuevas experiencias con quienes organizan eventos, facilitando el descubrimiento y el acceso a actividades desde un mismo lugar.

