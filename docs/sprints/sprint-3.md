# Sprint 3 — 4 al 11 de noviembre de 2026

**Objetivo:** el usuario confirma su asistencia y recibe recomendaciones y descripciones hechas con IA.

Tablero: <https://desparcha2.atlassian.net/jira/software/projects/SCRUM/boards/1>

## Qué se demuestra el último día
1. El usuario abre un evento y confirma su asistencia; luego la cancela.
2. El usuario escribe en lenguaje natural lo que busca («algo tranquilo esta noche, música en vivo») y recibe recomendaciones según sus intereses y los eventos cercanos, con enlaces directos a cada evento.
3. Al superar el límite de solicitudes por minuto, la app muestra un aviso claro y no cobra más llamadas al modelo.
4. Un organizador escribe nombre, lugar y tipo de actividad, la IA propone una descripción y él la revisa, la edita o la regenera antes de publicar.

## Corte vertical
| Capa | Qué hay que mostrar |
|---|---|
| Pantalla | Botón de asistencia, chat de recomendaciones y asistente de descripción en la creación de eventos (`festa-mobile`). |
| Endpoint | Asistencia en `festa-booking-service` y recomendaciones y descripciones en `festa-ai-service`, detrás del gateway. |
| Persistencia | `booking_db` (asistencias), `ai_db` (MongoDB, recomendaciones) y el límite por usuario en Redis. |
| Prueba automatizada | Pruebas de asistencia, del límite de solicitudes y del manejo de errores del modelo, con un modelo simulado para que no cueste. |

## Historias incluidas
| Historia | Responsable |
|---|---|
| SCRUM-22 RF7 · Confirmar asistencia a un evento | por asignar |
| SCRUM-30 RF8 · Recomendaciones conversacionales con IA | Manuel |
| SCRUM-31 RF9 · Descripción de evento generada por IA | Manuel |

## Fuera de alcance
Pagos, QR y panel de comercio.

## Riesgos
- Hay que elegir el proveedor del modelo de lenguaje (ADR 0003) antes de empezar.
- Las descripciones generadas deben guardarse para no volver a pagarlas (RNF8).
- Depende de los intereses del usuario (RF2) y de los eventos del Sprint 2.
