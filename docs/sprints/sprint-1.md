# Sprint 1 — 21 al 28 de octubre de 2026

**Objetivo:** un usuario se registra e inicia sesión desde la app, sobre la infraestructura base.

Tablero: <https://desparcha2.atlassian.net/jira/software/projects/SCRUM/boards/1>

## Qué se demuestra el último día
1. Se levanta la infraestructura con un solo comando (`festa-infra`): bases de datos por servicio, RabbitMQ, Redis, Prometheus y Grafana.
2. Desde la app (APK) una persona nueva se registra con correo y contraseña, o con Google, y acepta el aviso de privacidad.
3. La persona cierra sesión y vuelve a entrar.
4. La app llama solo al gateway (Kong); el gateway valida el JWT y enruta al servicio.
5. Un perfil de usuario y un perfil de comercio quedan guardados; el equipo Festa puede aprobar o rechazar el comercio.
6. Un pull request muestra el CI (build, linter y pruebas) en verde.

## Corte vertical
| Capa | Qué hay que mostrar |
|---|---|
| Pantalla | Registro, inicio y cierre de sesión, perfil, intereses y formulario de comercio (`festa-mobile`). |
| Endpoint | `/auth/register`, `/auth/login`, `/auth/google`, `/auth/refresh`, `/auth/logout` y los de perfil y verificación en `festa-user-service`, detrás del gateway. |
| Persistencia | `auth_db` y `user_db` (PostgreSQL), cada servicio con su base y su usuario. |
| Prueba automatizada | Pruebas de registro y login (casos válidos y de error), pruebas del perfil y contrato de mensajes contra `festa-infra/contracts`. |

## Historias incluidas
| Historia | Responsable |
|---|---|
| SCRUM-14 Infraestructura base desplegable | Carlos |
| SCRUM-15 CI/CD y pruebas automatizadas | Brayan |
| SCRUM-17 RF1 · Registro e inicio de sesión | Sebastián Duque |
| SCRUM-18 RF2 · Perfil de usuario e intereses | Juan |
| SCRUM-19 RF3 · Perfil de comercio con verificación manual | Isaac |

El reparto de las subtareas está en Jira. Cada integrante escribe en Jira la descripción de las suyas, con el formato de [`CONTRIBUTING.md`](../../CONTRIBUTING.md).

## Estado al 27 de octubre
- **Hecho** (ramas `feat/*` de Carlos, sin PR todavía): infraestructura local y contratos (`festa-infra`), registro y login en el backend (`festa-auth-service`) y gateway Kong (`festa-gateway`).
- **Sin código todavía:** `festa-mobile`, `festa-user-service` y el CI de todos los repositorios.

## Fuera de alcance
Eventos, mapa, pagos, IA y notificaciones push (Sprints 2 a 4).

## Riesgos
- La app y el servicio de usuarios no tienen código y el sprint termina el 28 de octubre. Hay que decidir si se extiende o si RF2 y RF3 pasan al Sprint 2.
- El trabajo de Carlos todavía no está fusionado a `develop`: hay que abrir los PR y revisarlos.
- Está por decidir la nube de despliegue (Azure, AWS o GCP); el CI automático al entorno de pruebas depende de eso.
