# Sprint 4 — 11 al 18 de noviembre de 2026

**Objetivo:** el usuario compra una entrada y entra al evento con un QR de un solo uso, incluso sin conexión.

Tablero: <https://desparcha2.atlassian.net/jira/software/projects/SCRUM/boards/1>

## Qué se demuestra el último día
1. El usuario elige un evento con boletería y paga con Wompi en modo de pruebas (tarjeta o PSE).
2. El pago se reparte: 8 % para Festa y 92 % para el organizador.
3. La app recibe un código QR único y lo guarda en el celular.
4. Con el celular sin internet, el usuario muestra el QR en la puerta y el comercio lo escanea y lo valida.
5. Si intenta usar el mismo QR otra vez, la validación lo rechaza.
6. El comercio abre su panel y ve cuántos asistentes y cuántos boletos se vendieron.

## Corte vertical
| Capa | Qué hay que mostrar |
|---|---|
| Pantalla | Compra, QR guardado en el celular, escáner en la puerta y panel de comercio (`festa-mobile`). |
| Endpoint | Pagos y webhook de Wompi en `festa-payment-service`, QR y validación en `festa-booking-service`, conteos en `festa-analytics-service`. |
| Persistencia | `payment_db`, `booking_db` y `analytics_db`; la validación rápida de QR en Redis es una propuesta. |
| Prueba automatizada | Pruebas del reparto de comisión, del webhook (sin procesar dos veces el mismo aviso) y del uso único del QR. |

## Historias incluidas
| Historia | Responsable |
|---|---|
| SCRUM-26 RF11 · Compra de entradas dentro de la app | Carlos (82, 84, 85) · Duque (83) |
| SCRUM-27 RF11 · Comisión del 8 % por entrada (split de pago) | Brayan (86, 87, 88) |
| SCRUM-28 RF10 · Código QR por entrada | Juan (89) · Duque (90, 91) |
| SCRUM-29 RF10 · Escaneo y validación de QR en la puerta | Juan (93, 94) · Manuel (92) · Isaac (95) |
| SCRUM-35 RF15 · Panel de comercio | Isaac (112) · Manuel (113) |

Son 16 subtareas: Carlos 3 · Brayan 3 · Duque 3 · Juan 3 · Isaac 2 · Manuel 2. Es el sprint con menos carga a propósito, como colchón para la integración y la demostración final.

## Ruta crítica (fechas de vencimiento en Jira)
- **12 nov:** SCRUM-82 (Wompi) y 83 (pantalla de compra).
- **13 nov:** 84 (webhook) y 86 (split).
- **14 nov:** 89 (QR), 93 (validación), 85, 87.
- **15 nov:** 94, 90, 92, 88.
- **16 nov:** 91, 95, 112.
- **17 nov:** 113. **18 nov:** demostración.

## Fuera de alcance
Notificaciones push, compartir en redes, reportes y la gamificación (Sprint 5, que no se hará).

## Riesgos
- Wompi solo se usa con llaves de pruebas (sandbox) hasta la demostración.
- El webhook de Wompi necesita una URL pública; el entorno local usa un túnel.
- Hay que decidir si la validación del QR usa Redis y cómo se sincroniza lo escaneado sin conexión.
- Es el sprint con más dependencias: necesita eventos, asistencia y login funcionando.
