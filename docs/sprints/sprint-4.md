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
| SCRUM-26 RF11 · Compra de entradas dentro de la app | por asignar |
| SCRUM-27 RF11 · Comisión del 8 % por entrada (split de pago) | por asignar |
| SCRUM-28 RF10 · Código QR por entrada | por asignar |
| SCRUM-29 RF10 · Escaneo y validación de QR en la puerta | por asignar |
| SCRUM-35 RF15 · Panel de comercio | por asignar |

## Fuera de alcance
Notificaciones push, compartir en redes, reportes y la gamificación (Sprint 5, que no se hará).

## Riesgos
- Wompi solo se usa con llaves de pruebas (sandbox) hasta la demostración.
- El webhook de Wompi necesita una URL pública; el entorno local usa un túnel.
- Hay que decidir si la validación del QR usa Redis y cómo se sincroniza lo escaneado sin conexión.
- Es el sprint con más dependencias: necesita eventos, asistencia y login funcionando.
