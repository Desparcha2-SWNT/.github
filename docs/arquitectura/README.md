# Arquitectura — Festa (modelo C4)

Modelo de arquitectura de Festa escrito como código (*diagrams as code*) con
[Structurizr DSL](https://docs.structurizr.com/dsl). El archivo
[`festa.dsl`](./festa.dsl) es la **única fuente de verdad**: las imágenes de
`diagramas/` son exportaciones generadas a partir de él y no deben editarse a mano.

## Contenido

| Archivo | Descripción |
| --- | --- |
| `festa.dsl` | Workspace Structurizr: modelo (personas, sistemas, contenedores), vistas y estilos. |
| `diagramas/ContextoFesta.png` | Exportación de la vista `ContextoFesta` (C4 nivel 1 — Contexto de sistema). |
| [`alcance.md`](./alcance.md) | Ficha de alcance del sistema (objetivo, problema a resolver, diagrama de contexto con actores y sistemas externos, y qué está dentro/fuera del alcance), en el formato de [`dosw-lab4-example/scope-template.md`](https://github.com/lauherrerac/dosw-lab4-example/blob/main/docs/requirements/scope-template.md). |

## Vistas definidas

- **`ContextoFesta`** — C4 nivel 1 (Contexto). Muestra a Festa frente a sus
  actores (persona interesada en eventos, comercio/organizador, administrador de
  la plataforma) y a los sistemas externos: pasarela de pagos, servicio de
  recomendaciones por IA, servicio de notificaciones y proveedor de identidad.
- **`ContenedoresFesta`** — C4 nivel 2 (Contenedores). Descompone Festa en API
  Gateway, Auth, User, Event, Booking, Payment, AI, Notification y Analytics
  Service, Admin Panel y el Message Broker (RabbitMQ).

## Cómo visualizar o exportar los diagramas

**Opción A — Structurizr Lite (recomendada, con Docker):**

```bash
docker run -it --rm -p 8080:8080 \
  -v "$(pwd)/docs/arquitectura:/usr/local/structurizr" \
  structurizr/lite
```

Luego abrir <http://localhost:8080>. Detecta `festa.dsl` automáticamente y
recarga al guardar cambios.

**Opción B — structurizr-cli (exportar a imágenes o PlantUML):**

```bash
structurizr-cli export -workspace docs/arquitectura/festa.dsl -format plantuml
```

**Opción C — sin instalar nada:** pegar el contenido de `festa.dsl` en
<https://structurizr.com/dsl>.

## Convención de cambios

1. Editar **solo** `festa.dsl`.
2. Re-exportar la imagen afectada a `diagramas/` conservando el nombre de la vista.
3. Registrar el prompt en [`BITACORA_PROMPTS.md`](../../BITACORA_PROMPTS.md) si el
   cambio fue asistido por IA.
