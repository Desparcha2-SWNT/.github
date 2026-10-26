# Decisiones de arquitectura (ADR)

Cada decisión importante se registra en un archivo numerado, con la plantilla [`0000-plantilla.md`](0000-plantilla.md). Un ADR es corto (una página) y responde: qué decidimos, por qué y qué consecuencias tiene. Si la decisión cambia, se crea un ADR nuevo que reemplaza al anterior; no se borra el historial.

## Decisiones pendientes (al 25 de octubre de 2026)

| Nº | Tema | Estado |
|---|---|---|
| 0001 | Plataforma de despliegue (la decisión previa fue Azure; los repositorios nuevos no la definen) | Pendiente |
| 0002 | Almacén de datos por servicio (PostgreSQL, MongoDB, Redis) | Aislamiento decidido: una base de datos por servicio (retroalimentación del profesor, 26-oct-2026). Falta confirmar el motor de cada una |
| 0003 | Proveedor de LLM para `festa-ai-service` | Pendiente |
| 0004 | Contratos de mensajes de RabbitMQ y convención de eventos | Pendiente |
| 0005 | Dónde van RF13, RF14 y RF16-RF18 (sin repositorio asignado) | Pendiente |

Decisiones ya tomadas que conviene documentar: arquitectura de microservicios según los repositorios `festa-*`, observabilidad con Prometheus y Grafana, flujo de ramas `main` / `develop` / `feature` (ver [CONTRIBUTING.md](../../CONTRIBUTING.md)).
