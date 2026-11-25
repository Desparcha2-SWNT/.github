# Decisiones de arquitectura (ADR)

Cada decisión importante se registra en un archivo numerado, con la plantilla [`0000-plantilla.md`](0000-plantilla.md). Un ADR es corto (una página) y responde: qué decidimos, por qué y qué consecuencias tiene. Si la decisión cambia, se crea un ADR nuevo que reemplaza al anterior; no se borra el historial.

## Decisiones pendientes (al 25 de octubre de 2026)

| Nº | Tema | Estado |
|---|---|---|
| 0001 | Plataforma de despliegue | [Aceptada: AWS](0001-plataforma-aws.md) (7-nov-2026) |
| 0002 | Almacén de datos por servicio (PostgreSQL, MongoDB, Redis) | [Aceptada: motor de cada servicio](0002-motores-de-base-de-datos.md) (23-nov-2026) |
| 0003 | Proveedor de LLM para `festa-ai-service` | [Aceptada: Gemini](0003-proveedor-llm-gemini.md) |
| 0004 | Contratos de mensajes de RabbitMQ y convención de eventos | Pendiente |
| 0005 | Dónde van RF13, RF14 y RF16-RF18 (sin repositorio asignado) | Pendiente |

Decisiones ya tomadas que conviene documentar: arquitectura de microservicios según los repositorios `festa-*`, observabilidad con Prometheus y Grafana, flujo de ramas `main` / `develop` / `feature` (ver [CONTRIBUTING.md](../../CONTRIBUTING.md)).
