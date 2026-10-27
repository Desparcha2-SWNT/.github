# Sprint 2 — 28 de octubre al 4 de noviembre de 2026

**Objetivo:** un comercio verificado crea y edita eventos, y el usuario configura su perfil e intereses.

Tablero: <https://desparcha2.atlassian.net/jira/software/projects/SCRUM/boards/1>

## Qué se demuestra el último día
1. Un usuario ya registrado edita su nombre y foto, y elige sus categorías de interés.
2. Un comercio llena el formulario de perfil y queda «pendiente de verificación».
3. El equipo Festa abre la vista de revisión y aprueba el comercio; el comercio recibe la notificación.
4. El comercio aprobado crea un evento con fecha, lugar, categoría, cupo y descripción; el lugar se geocodifica.
5. El organizador edita el evento y luego lo cancela; solo el creador puede hacerlo.
6. En Grafana se ven las métricas de los servicios, con TLS y secretos fuera del repositorio.

## Corte vertical
| Capa | Qué hay que mostrar |
|---|---|
| Pantalla | Perfil e intereses, formulario de comercio, revisión del equipo Festa, crear/editar/cancelar evento (`festa-mobile`). |
| Endpoint | Perfil y verificación en `festa-user-service`; crear, editar y cancelar en `festa-event-service`, detrás del gateway. |
| Persistencia | `user_db` y `event_db` (PostgreSQL, con PostGIS en eventos). |
| Prueba automatizada | Pruebas del perfil, de los estados de verificación y de crear, editar y cancelar con reglas de permiso. |

## Historias incluidas y reparto (18 subtareas, 3 por persona)
| Historia | Responsable | Subtareas por persona |
|---|---|---|
| SCRUM-16 Observabilidad y seguridad básica | Carlos | Carlos: 47, 48, 64 · Brayan: 49, 68, 69 |
| SCRUM-18 RF2 · Perfil de usuario e intereses | Juan | Juan: 57, 60, 65 · Manuel: 55, 56, 66 |
| SCRUM-19 RF3 · Perfil de comercio con verificación manual | Isaac | Isaac: 58, 61, 62 · Duque: 59, 63, 67 |
| SCRUM-20 RF4 · Crear evento | Carlos | |
| SCRUM-21 RF4 · Editar y cancelar evento | Brayan | |

## Ruta crítica (fechas de vencimiento en Jira)
APIs primero, pantallas después, pruebas al final:
- **29 oct:** SCRUM-57 (API de perfil) y 60 (API de verificación), de Juan; 64 (API de eventos), de Carlos; 49 (secretos), de Brayan.
- **30 oct:** SCRUM-65 (geocodificación), 69 (permisos), 48 (TLS).
- **1 nov:** pantallas 55, 56, 59 y 63, que esperan a sus APIs.
- **2–3 nov:** 67, 68, 58, 61, 62 y 66.
- **4 nov:** cierre y demostración.

Las tareas que no dependen de otras (47, 49, 57, 60, 64) arrancan el primer día en paralelo; los vínculos «bloquea» están creados en Jira.

## Fuera de alcance
Mapa, filtros, asistencia, IA, pagos y QR.

## Riesgos
- Depende de que el Sprint 1 deje la app con registro y login y el esqueleto conectado al gateway (SCRUM-43).
- Solo un comercio aprobado publica eventos: RF3 debe estar listo antes que RF4 en pantalla.
- Hay que confirmar el motor de cada base de datos (ADR 0002) antes de modelar `user_db`.
