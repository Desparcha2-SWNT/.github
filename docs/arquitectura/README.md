# Arquitectura — Festa (modelo C4)

Modelo de arquitectura de Festa escrito como código (*diagrams as code*) con
[Structurizr DSL](https://docs.structurizr.com/dsl). El archivo
[`festa.dsl`](./festa.dsl) es la **fuente de verdad de las vistas C4** (contexto, contenedores,
componentes y dinámica): sus imágenes en `diagramas/` se exportan desde él y no deben editarse a mano.
Los diagramas de las carpetas `05` a `09` (clases, base de datos, secuencias, proceso y despliegue) **no salen del DSL**:
se dibujan en Lucid, que es su fuente de verdad, y no tienen vista equivalente en `festa.dsl`.

## Estructura de carpetas

```text
docs/
├── arquitectura/
│   ├── README.md                         ← este índice
│   ├── alcance.md                        ← alcance del sistema y explicación de todos los diagramas
│   ├── festa.dsl                         ← modelo C4 (fuente de verdad de las vistas C4)
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
│       │       booking-service.png, payment-service.png, ai-service.png,
│       │       analytics-service.png, notification-service.png
│       ├── 06-base-de-datos/             ← un modelo de base de datos por microservicio (Lucid)
│       │   └── auth-service.png, user-service.png, … (los mismos ocho)
│       ├── 07-secuencias/                ← seis diagramas de secuencia (Lucid)
│       ├── 08-proceso/                   ← proceso de negocio BPMN (Lucid)
│       └── 09-despliegue/                ← arquitectura y despliegue en AWS (Lucid)
└── adr/                                  ← decisiones de arquitectura (en el PR de DevSecOps)
```

Cada carpeta de `diagramas/` corresponde a un tipo de vista del modelo C4 y lleva
un número para que se lea de lo general a lo particular. El nombre de cada imagen de las carpetas 01 a 04 es
la clave de su vista en `festa.dsl`; las de 05 a 09 vienen de Lucid.

## Diagramas

| Nivel | Vista (`festa.dsl`) | Imagen | Qué muestra |
| --- | --- | --- | --- |
| 1. Contexto | `ContextoFesta` | [`01-contexto/ContextoFesta.png`](./diagramas/01-contexto/ContextoFesta.png) | Festa frente a sus actores y a los sistemas externos (Wompi, Google Gemini API, Firebase Cloud Messaging, Google Identity y Mapbox). |
| 2. Contenedores | `ContenedoresFesta` | [`02-contenedores/ContenedoresFesta.png`](./diagramas/02-contenedores/ContenedoresFesta.png) | `festa-mobile`, `festa-gateway`, los ocho microservicios de negocio, RabbitMQ, la base de datos propia de cada servicio (PostgreSQL o MongoDB), Redis y Prometheus + Grafana. |
| 3. Componentes | `ComponentesBooking` | [`03-componentes/ComponentesBooking.png`](./diagramas/03-componentes/ComponentesBooking.png) | `festa-booking-service`: asistencia y QR de un solo uso (RF7, RF10, RNF7). |
| 3. Componentes | `ComponentesPayment` | [`03-componentes/ComponentesPayment.png`](./diagramas/03-componentes/ComponentesPayment.png) | `festa-payment-service`: órdenes y checkout firmado de Wompi (RF11). |
| 3. Componentes | `ComponentesAI` | [`03-componentes/ComponentesAI.png`](./diagramas/03-componentes/ComponentesAI.png) | `festa-ai-service`: recomendaciones, descripciones y límite de uso (RF8, RF9, RNF8). |
| Dinámica | `CompraBoleto` | [`04-dinamicas/CompraBoleto.png`](./diagramas/04-dinamicas/CompraBoleto.png) | Compra con checkout de Wompi, webhook, evento en RabbitMQ y emisión del pase QR (RF11, RF10). |
| Clases | (Lucid) | [`05-clases/`](./diagramas/05-clases/) | Un diagrama de clases por microservicio (auth, user, event, booking, payment, ai, analytics y notification). |
| Base de datos | (Lucid) | [`06-base-de-datos/`](./diagramas/06-base-de-datos/) | Un modelo de base de datos por microservicio, con su propio esquema. |
| Secuencias | (Lucid) | [`07-secuencias/`](./diagramas/07-secuencias/) | Registro, crear evento, asistencia, descripción con IA, compra y validación de QR. |
| Proceso | (Lucid) | [`08-proceso/`](./diagramas/08-proceso/) | Proceso de negocio en BPMN. |
| Despliegue | (Lucid) | [`09-despliegue/`](./diagramas/09-despliegue/) | Arquitectura de microservicios y despliegue en AWS. |

El documento [`alcance.md`](./alcance.md) describe el sistema, su problema, su contexto, actores y sistemas externos y su alcance, y reúne y explica todos los diagramas de esta carpeta.

El despliegue en AWS no se modela en C4: su fuente es la página "Despliegue en AWS (oficial)" del documento de Lucid del proyecto.

## Diagramas en Lucid

Todos los diagramas de Lucid están en el mismo documento del proyecto. Las páginas "Clases y BD · auth-service", "… user-service", "… event-service", "… booking-service", "… payment-service", "… ai-service", "… analytics-service" y "… notification-service" tienen el diagrama de clases y el modelo de base de datos de cada microservicio, hechos desde sus migraciones y colecciones reales.

## Estado del modelo

El modelo se contrastó el 23-nov-2026 con la rama `develop` de cada repositorio `Desparcha2-SWNT/festa-*` y con el Terraform de `festa-infra`. Los PR abiertos se revisaron, pero lo que aún no está fusionado no se dibuja como hecho.

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
