# Arquitectura — Festa (modelo C4)

Modelo de arquitectura de Festa escrito como código (*diagrams as code*) con
[Structurizr DSL](https://docs.structurizr.com/dsl). El archivo
[`festa.dsl`](./festa.dsl) es la **única fuente de verdad**: las imágenes de
`diagramas/` son exportaciones generadas a partir de él y no deben editarse a mano.

## Estructura de carpetas

```text
docs/
├── arquitectura/
│   ├── README.md                         ← este índice
│   ├── alcance.md                        ← alcance del sistema y explicación de todos los diagramas
│   ├── festa.dsl                         ← modelo C4 (fuente de verdad)
│   └── diagramas/
│       ├── 01-contexto/
│       │   └── ContextoFesta.png         ← C4 nivel 1
│       ├── 02-contenedores/
│       │   └── ContenedoresFesta.png     ← C4 nivel 2
│       ├── 03-componentes/
│       │   ├── ComponentesBooking.png    ← C4 nivel 3
│       │   ├── ComponentesPayment.png
│       │   └── ComponentesAI.png
│       ├── 04-dinamicas/
│       │   └── CompraBoleto.png          ← vista dinámica (complementaria)
│       ├── 05-clases/                    ← un diagrama de clases por microservicio (Lucid)
│       │   └── auth-service.png, user-service.png, event-service.png,
│       │       booking-service.png, payment-service.png, ai-service.png
│       └── 06-base-de-datos/             ← un ERD de PostgreSQL por microservicio (Lucid)
│           └── auth-service.png, user-service.png, … (los mismos seis)
└── adr/                                  ← decisiones de arquitectura (en el PR de DevSecOps)
```

Cada carpeta de `diagramas/` corresponde a un tipo de vista del modelo C4 y lleva
un número para que se lea de lo general a lo particular. El nombre de cada imagen es
la clave de su vista en `festa.dsl`.

## Diagramas

| Nivel | Vista (`festa.dsl`) | Imagen | Qué muestra |
| --- | --- | --- | --- |
| 1. Contexto | `ContextoFesta` | [`01-contexto/ContextoFesta.png`](./diagramas/01-contexto/ContextoFesta.png) | Festa frente a sus actores y a los sistemas externos (Wompi, Azure OpenAI, FCM/APNs, Google Identity y Mapbox). |
| 2. Contenedores | `ContenedoresFesta` | [`02-contenedores/ContenedoresFesta.png`](./diagramas/02-contenedores/ContenedoresFesta.png) | `festa-mobile`, `festa-gateway`, los siete microservicios de negocio, RabbitMQ, PostgreSQL, MongoDB, Redis y Prometheus + Grafana. |
| 3. Componentes | `ComponentesBooking` | [`03-componentes/ComponentesBooking.png`](./diagramas/03-componentes/ComponentesBooking.png) | `festa-booking-service`: asistencia y QR de un solo uso (RF7, RF10, RNF7). |
| 3. Componentes | `ComponentesPayment` | [`03-componentes/ComponentesPayment.png`](./diagramas/03-componentes/ComponentesPayment.png) | `festa-payment-service`: cobro y split con Wompi (RF11). |
| 3. Componentes | `ComponentesAI` | [`03-componentes/ComponentesAI.png`](./diagramas/03-componentes/ComponentesAI.png) | `festa-ai-service`: recomendaciones, descripciones y límite de uso (RF8, RF9, RNF8). |
| Dinámica | `CompraBoleto` | [`04-dinamicas/CompraBoleto.png`](./diagramas/04-dinamicas/CompraBoleto.png) | Secuencia de compra, pago, evento en RabbitMQ y entrega del QR (RF11, RF10). |
| Clases | (Lucid) | [`05-clases/`](./diagramas/05-clases/) | Un diagrama de clases por microservicio (auth, user, event, booking, payment y ai). |
| Base de datos | (Lucid) | [`06-base-de-datos/`](./diagramas/06-base-de-datos/) | Un ERD de PostgreSQL por microservicio, con su propio esquema. |

El documento [`alcance.md`](./alcance.md) describe el sistema, su problema, su contexto, actores y sistemas externos y su alcance, y reúne y explica todos los diagramas de esta carpeta.

El despliegue en Azure no se modela aquí: está en la página "Arquitectura Azure" del documento de Lucid del proyecto,
con los íconos oficiales de Azure.

## Diagramas en Lucid

Todos los diagramas de Lucid están en el mismo documento del proyecto. Las páginas "Clases y BD · auth-service", "… user-service", "… event-service", "… booking-service", "… payment-service" y "… ai-service" tienen el diagrama de clases y el modelo de base de datos de cada microservicio. Son una propuesta, pendiente del ADR 0002.

## Estado del modelo

El modelo sigue los repositorios `Desparcha2-SWNT/festa-*` (24-oct-2026) y el despliegue en Azure
(decisión del 25-oct-2026). Lo marcado como **propuesto** depende de decisiones pendientes del equipo:
la plataforma de despliegue (ADR 0001) y el almacén que usa cada servicio (ADR 0002). Las relaciones
servicio-almacén, los componentes internos del nivel 3 y los servicios de Azure son una propuesta
de diseño, no código existente. Los repositorios solo tienen README al 25 de octubre.

La versión anterior del modelo (Kong, Spring Boot, Admin Panel en React) quedó obsoleta y se reemplazó.

## Cómo visualizar o exportar los diagramas

**Con Structurizr (Docker):** la imagen oficial `structurizr/structurizr` busca un archivo llamado `workspace.dsl`,
así que se monta una carpeta temporal con una copia de `festa.dsl` renombrada:

```bash
mkdir tmp-structurizr && cp docs/arquitectura/festa.dsl tmp-structurizr/workspace.dsl
docker run --rm -p 8080:8080 -v "$(pwd)/tmp-structurizr:/usr/local/structurizr" structurizr/structurizr local
```

Luego abrir <http://localhost:8080>, elegir la vista y exportarla a PNG con el botón de exportar. Así se generaron las
imágenes de `diagramas/`. Borrar la carpeta temporal al terminar.

**Sin instalar nada:** pegar el contenido de `festa.dsl` en <https://structurizr.com/dsl>.

## Convención de cambios

1. Editar **solo** `festa.dsl`.
2. Re-exportar la imagen afectada y guardarla en la carpeta de su nivel, conservando el nombre de la vista.
3. Si cambia el diagrama de contexto o los sistemas externos, revisar [`alcance.md`](./alcance.md).
4. Registrar el prompt en [`BITACORA_PROMPTS.md`](../../BITACORA_PROMPTS.md) si el
   cambio fue asistido por IA.
