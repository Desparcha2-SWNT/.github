# Sprint 3 — 4 al 11 de noviembre de 2026

**Objetivo:** el usuario encuentra eventos en el mapa con filtros, confirma su asistencia y recibe recomendaciones y descripciones con IA.

Tablero: <https://desparcha2.atlassian.net/jira/software/projects/SCRUM/boards/1>

## Qué se demuestra el último día
1. El usuario acepta el permiso de ubicación (o usa la ubicación del piloto) y ve los eventos cercanos como marcadores; al acercar el mapa los clústeres se separan.
2. Filtra por categoría, zona y fecha, y la lista y el mapa cambian.
3. Confirma su asistencia a un evento y luego la cancela; el organizador ve el conteo.
4. Escribe en lenguaje natural lo que busca y recibe recomendaciones con enlaces a los eventos; al superar el límite por minuto la app avisa.
5. Un organizador genera con IA la descripción de su evento, la edita o la regenera antes de publicar.

## Corte vertical
| Capa | Qué hay que mostrar |
|---|---|
| Pantalla | Mapa con clústeres, filtros, botón de asistencia, chat de recomendaciones y asistente de descripción (`festa-mobile`). |
| Endpoint | Consulta geoespacial y búsqueda en `festa-event-service`, asistencia en `festa-booking-service`, recomendaciones y descripciones en `festa-ai-service`. |
| Persistencia | `event_db` (PostGIS), `booking_db`, `ai_db` (MongoDB) y el límite por usuario en Redis. |
| Prueba automatizada | Rendimiento del mapa con muchos eventos, filtros, asistencia, límite de solicitudes y errores del modelo (con un modelo simulado). |

## Historias incluidas y reparto (20 subtareas)
| Historia | Responsable | Subtareas |
|---|---|---|
| SCRUM-22 RF7 · Confirmar asistencia | Isaac | 70, 72 (Isaac) · 71 (Brayan) |
| SCRUM-23 RF5 · Mapa interactivo | Duque | 73, 75 (Duque) · 74, 76 (Carlos) |
| SCRUM-24 RF5 · Clústeres por zona | Duque | 77 (Duque) · 78 (Manuel) |
| SCRUM-25 RF6 · Búsqueda y filtrado | Isaac | 79, 81 (Isaac) · 80 (Carlos) |
| SCRUM-30 RF8 · Recomendaciones con IA | Juan | 97, 98, 99 (Juan) · 100 (Brayan) · 96 (Manuel) |
| SCRUM-31 RF9 · Descripción con IA | Manuel | 101, 103 (Manuel) · 102 (Brayan) |

Carga: Carlos 3 · Brayan 3 · Duque 3 · Juan 3 · Isaac 4 · Manuel 4.

## Ruta crítica (fechas de vencimiento en Jira)
- **5 nov:** SCRUM-74 (consulta geoespacial), 71 (API de asistencia), 73 (Mapbox) y 98 (proveedor de LLM, antes se debe cerrar el ADR 0003).
- **6 nov:** 80 (API de búsqueda), 79 (UI de filtros), 96 (chat).
- **7 nov:** 75, 76, 70, 97, 102.
- **8 nov:** 77, 81, 72, 99, 100, 101.
- **9 nov:** 78 (rendimiento) y 103 (revisión del texto).
- **11 nov:** cierre y demostración.

## Fuera de alcance
Pagos, QR y panel de comercio.

## Riesgos
- Hay que elegir el proveedor del modelo de lenguaje (ADR 0003) antes del 5 de noviembre.
- Las descripciones generadas deben guardarse para no volver a pagarlas (RNF8).
- El mapa debe verse en menos de 2 segundos (RNF1); hay que medirlo (SCRUM-78).
- El consentimiento de ubicación debe estar antes de leer la ubicación del dispositivo (Ley 1581).
