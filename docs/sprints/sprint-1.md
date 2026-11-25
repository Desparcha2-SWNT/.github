# Sprint 1 — 21 al 28 de octubre de 2026

**Objetivo:** un usuario se registra e inicia sesión desde la app, sobre la infraestructura base.

Tablero: <https://desparcha2.atlassian.net/jira/software/projects/SCRUM/boards/1>

## Qué se demuestra el último día
1. Se levanta la infraestructura con un solo comando (`festa-infra`): bases de datos por servicio, RabbitMQ, Redis, Prometheus y Grafana.
2. Desde la app (APK) una persona nueva se registra con correo y contraseña, o con Google, y acepta el aviso de privacidad.
3. La persona cierra sesión y vuelve a entrar.
4. La app llama solo al gateway (Kong); el gateway valida el JWT y enruta al servicio.
5. Un pull request muestra el CI (build, linter y pruebas) en verde.

## Corte vertical
| Capa | Qué hay que mostrar |
|---|---|
| Pantalla | Registro, inicio y cierre de sesión (`festa-mobile`). |
| Endpoint | `/auth/register`, `/auth/login`, `/auth/google`, `/auth/refresh`, `/auth/logout`, detrás del gateway. |
| Persistencia | `auth_db` (PostgreSQL), con su propio usuario. |
| Prueba automatizada | Pruebas de registro y login (casos válidos y de error), contrato de mensajes contra `festa-infra/contracts`. |

## Historias incluidas
| Historia | Responsable |
|---|---|
| SCRUM-14 Infraestructura base desplegable | Carlos |
| SCRUM-15 CI/CD y pruebas automatizadas | Brayan |
| SCRUM-17 RF1 · Registro e inicio de sesión | Sebastián Duque |

RF2 y RF3 pasaron al Sprint 2 (los sprints no se alargan): la app y el servicio de usuarios no tenían código y no hay forma de entregarlos con calidad el 28 de octubre. En este sprint Juan escribe la política de privacidad y la autorización Ley 1581 (SCRUM-129 y 126), Isaac las pruebas de auth (SCRUM-54) y Manuel el esqueleto de la app (SCRUM-43). El reparto está en Jira. Cada integrante escribe en Jira la descripción de las suyas, con el formato de [`CONTRIBUTING.md`](../../CONTRIBUTING.md).

## Estado al 27 de octubre
- **Hecho** (ramas `feat/*` de Carlos, sin PR todavía): infraestructura local y contratos (`festa-infra`), registro y login en el backend (`festa-auth-service`) y gateway Kong (`festa-gateway`).
- **Sin código todavía:** `festa-mobile`, `festa-user-service` y el CI de todos los repositorios.

## Fuera de alcance
Eventos, mapa, pagos, IA y notificaciones push (Sprints 2 a 4).

## Riesgos
- La app no tiene código y el sprint termina el 28 de octubre: el registro y login desde la app (SCRUM-43, 50 y 51) es lo que más riesgo corre. Si no alcanza, el corte se demuestra con el APK mínimo y se documenta el atraso.
- El trabajo de Carlos todavía no está fusionado a `develop`: hay que abrir los PR y revisarlos.
- Está por decidir la nube de despliegue (Azure, AWS o GCP); el CI automático al entorno de pruebas depende de eso.
