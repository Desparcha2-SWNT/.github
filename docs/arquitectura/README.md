# Arquitectura — Festa (modelo C4)

Modelo de arquitectura de Festa escrito como código (*diagrams as code*) con
[Structurizr DSL](https://docs.structurizr.com/dsl). El archivo
[`festa.dsl`](./festa.dsl) es la **única fuente de verdad**: las imágenes de
`diagramas/` son exportaciones generadas a partir de él y no deben editarse a mano.

## Contenido

| Archivo | Descripción |
| --- | --- |
| `festa.dsl` | Workspace Structurizr: modelo (personas, sistemas, contenedores, componentes, despliegue), vistas y estilos. |
| `diagramas/ContextoFesta.png` | C4 nivel 1: contexto de sistema. |
| `diagramas/ContenedoresFesta.png` | C4 nivel 2: app móvil, gateway, microservicios `festa-*` y componentes de `festa-infra`. |
| `diagramas/ComponentesBooking.png` | C4 nivel 3: `festa-booking-service` (asistencia y QR de un solo uso). |
| `diagramas/ComponentesPayment.png` | C4 nivel 3: `festa-payment-service` (cobro y split con Wompi). |
| `diagramas/ComponentesAI.png` | C4 nivel 3: `festa-ai-service` (recomendaciones, descripciones y límite de uso). |
| `diagramas/CompraBoleto.png` | Vista dinámica: compra de un boleto y generación del QR. |
| `diagramas/DespliegueAzure.png` | Vista de despliegue propuesta en Azure. |
| [`alcance.md`](./alcance.md) | Ficha de alcance del sistema, en el formato de [`dosw-lab4-example/scope-template.md`](https://github.com/lauherrerac/dosw-lab4-example/blob/main/docs/requirements/scope-template.md). |

## Estado del modelo

El modelo sigue los repositorios `Desparcha2-SWNT/festa-*` (24-oct-2026) y el despliegue en Azure
(decisión del 25-oct-2026). Lo marcado como **propuesto** depende de decisiones pendientes del equipo:
la plataforma de despliegue (ADR 0001) y el almacén que usa cada servicio (ADR 0002). Las relaciones
servicio-almacén, los componentes internos de los niveles 3 y los servicios de Azure son una propuesta
de diseño, no código existente. Los repositorios solo tienen README al 25 de octubre.

La versión anterior del modelo (Kong, Spring Boot, Admin Panel en React) quedó obsoleta y se reemplazó.

## Vistas definidas

- **`ContextoFesta`** (nivel 1): Festa frente a sus actores y a los sistemas externos (Wompi, Azure OpenAI, FCM/APNs, Google Identity y Mapbox).
- **`ContenedoresFesta`** (nivel 2): `festa-mobile`, `festa-gateway`, los siete microservicios de negocio, RabbitMQ, PostgreSQL, MongoDB, Redis y Prometheus + Grafana.
- **`ComponentesBooking`, `ComponentesPayment`, `ComponentesAI`** (nivel 3): componentes internos de los tres servicios con la lógica más crítica (RNF7, RF11 y RNF8).
- **`CompraBoleto`** (dinámica): secuencia de compra, pago, evento en RabbitMQ y entrega del QR.
- **`DespliegueAzure`**: Container Apps, PostgreSQL Flexible Server, Cosmos DB, Cache for Redis, Key Vault, Azure OpenAI y Notification Hubs.

## Cómo visualizar o exportar los diagramas

**Con Structurizr (Docker):** la imagen oficial `structurizr/structurizr` busca un archivo llamado `workspace.dsl`,
así que se monta una carpeta temporal con una copia de `festa.dsl` renombrada:

```bash
mkdir tmp-structurizr && cp docs/arquitectura/festa.dsl tmp-structurizr/workspace.dsl
docker run --rm -p 8080:8080 -v "$(pwd)/tmp-structurizr:/usr/local/structurizr" structurizr/structurizr local
```

Luego abrir <http://localhost:8080>, elegir la vista y exportarla a PNG con el botón de exportar. Así se generaron las
imágenes de `diagramas/`. Borrar la carpeta temporal al terminar.

**Opción C: sin instalar nada:** pegar el contenido de `festa.dsl` en <https://structurizr.com/dsl>.

## Convención de cambios

1. Editar **solo** `festa.dsl`.
2. Re-exportar la imagen afectada a `diagramas/` conservando el nombre de la vista.
3. Registrar el prompt en [`BITACORA_PROMPTS.md`](../../BITACORA_PROMPTS.md) si el
   cambio fue asistido por IA.
