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