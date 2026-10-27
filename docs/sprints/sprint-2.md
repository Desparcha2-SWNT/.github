# Sprint 2 — 28 de octubre al 4 de noviembre de 2026

**Objetivo:** un organizador crea un evento y los usuarios lo encuentran en el mapa y con filtros.

Tablero: <https://desparcha2.atlassian.net/jira/software/projects/SCRUM/boards/1>

## Qué se demuestra el último día
1. Un comercio ya verificado entra a la app y crea un evento con fecha, lugar, categoría, cupo y descripción.
2. El organizador edita el evento y luego lo cancela.
3. Otro usuario abre el mapa, acepta el permiso de ubicación (o usa la ubicación del piloto si lo rechaza) y ve los eventos cercanos como marcadores.
4. Al acercar el mapa, los clústeres se separan en eventos individuales.
5. El usuario filtra por categoría, zona y fecha, y los resultados cambian en la lista y en el mapa.
6. En Grafana se ven las métricas de los servicios.

## Corte vertical
| Capa | Qué hay que mostrar |
|---|---|
| Pantalla | Crear, editar y cancelar evento; mapa con marcadores y clústeres; filtros (`festa-mobile`). |
| Endpoint | CRUD de eventos y consultas geoespaciales en `festa-event-service`, detrás del gateway. |
| Persistencia | `event_db` (PostgreSQL con PostGIS) y caché del mapa en Redis. |
| Prueba automatizada | Pruebas de crear, editar y cancelar, de las consultas por zona y de los filtros. |

## Historias incluidas
| Historia | Responsable |
|---|---|
| SCRUM-16 Observabilidad y seguridad básica | por asignar |
| SCRUM-20 RF4 · Crear evento | Manuel |
| SCRUM-21 RF4 · Editar y cancelar evento | Manuel |
| SCRUM-23 RF5 · Mapa interactivo de eventos | Manuel |
| SCRUM-24 RF5 · Clústeres de eventos por zona | Manuel |
| SCRUM-25 RF6 · Búsqueda y filtrado de eventos | Manuel |

Las subtareas se reparten con el mismo criterio del Sprint 1: todos aportan código y el esfuerzo es parejo.

## Fuera de alcance
Asistencia, IA, pagos y QR.

## Riesgos
- Depende de que el Sprint 1 deje funcionando el login y el perfil de comercio (solo un comercio aprobado publica).
- El consentimiento de ubicación debe estar antes de leer la ubicación del dispositivo (Ley 1581).
- El mapa debe verse en menos de 2 segundos (RNF1); hay que medirlo.
