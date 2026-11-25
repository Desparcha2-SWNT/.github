# Modelo de costos de Festa (SCRUM-131)

- **Estado:** borrador. Los supuestos de la sección 1 esperan la aprobación del equipo.
- **Fecha:** 2026-11-16 · **Responsable:** Brayan Loaiza
- **Reemplaza:** las cifras del pitch (USD 113 al mes y 17 meses con USD 2.000) y el presupuesto del *Informe de arquitectura y viabilidad* de septiembre, que suponía GCP con capas gratuitas.
- **Ingresos:** el modelo oficial de monetización es el del XLSM `adjuntos/documentos/2026-11-16_festa-pg-ia-swnt-costos.xlsm` (suscripción Festa Pro con cupo de IA y overage). La comisión por boleta queda fuera: es un ingreso adicional posible, no parte del modelo.
- **Cálculo reproducible:** [`modelo_costos.py`](modelo_costos.py). Todos los supuestos y precios están arriba del archivo; al cambiar uno, `python modelo_costos.py` recalcula todo.

**Reglas del cálculo.** Precios de lista **sin capas gratuitas** (cada recurso se cobra desde la primera unidad), región us-east-1, 730 horas al mes y TRM de **3.300 COP por dólar** (la del 11 de noviembre fue 3.297,07). Se separa el costo de **operación** (el servicio encendido para usuarios reales) del de **desarrollo** (sección 6).

## 1. Supuestos (pendientes de aprobación)

| Supuesto | Fase 1 · Piloto ECI | Fase 2 · Bogotá zonal | Fase 3 · Ciudad |
|---|---|---|---|
| Usuarios activos al mes (MAU) | 4.000 | 30.000 | 100.000 |
| Organizadores con Festa Pro (pagan la suscripción) | 60 | 250 | 1.000 |
| Eventos creados al mes (4 por organizador) | 240 | 1.000 | 4.000 |
| Boletas vendidas al mes | 200 | 1.500 | 5.000 |
| Réplicas de los servicios de la ruta crítica (gateway, auth, user, event, booking, payment) | 1 | 2 | 4 |
| Réplicas de ai, notification y analytics | 1 | 1 | 2 |
| Base de datos y caché | db.t3.micro, cache.t3.micro | db.t3.medium, cache.t3.small | db.t3.medium, cache.t3.medium |

Uso por usuario, igual en las tres fases:
- **6 sesiones al mes por MAU** (DAU/MAU de 15 a 20 %, del informe de viabilidad), con **30 peticiones** y **0,4 MB** por sesión. Las imágenes se sirven por URL externa.
- **Chat de IA:** lo usa el 25 % de los MAU, 4 mensajes al mes cada uno, con 3.000 tokens de entrada y 500 de salida por mensaje.
- **IA de los organizadores:** se costea el mismo volumen que se factura en Festa Pro: 49 solicitudes por evento (5 de descripción, 2 de moderación, 40 del chat de asistentes y 2 de métricas), es decir 196 por organizador al mes, con 3.000 tokens de entrada y 300 de salida por solicitud (XLSM, hoja Supuestos_Festa). A las tarifas de Gemini de la sección 2, cada solicitud cuesta USD 0,00165 (unos 5,4 COP).
- **Compra:** 20 peticiones y 0,1 MB.
- **Negocio (Festa Pro, XLSM oficial):** suscripción de 79.000 COP al mes por organizador, con 150 solicitudes de IA incluidas y 60 COP por cada solicitud adicional. Un organizador típico hace 4 eventos al mes y 196 solicitudes (4 × (5 de descripción + 2 de moderación + 40 del chat de asistentes + 2 de métricas)). Wompi cobra 2,65 % + 700 COP + IVA: sobre la suscripción es costo de Festa (un cobro mensual por organizador). **Sobre las boletas, la decisión del equipo (2026-11-21) es que lo paga el comercio:** el comprador paga solo el precio de la boleta (`total = subtotal`) y la comisión se descuenta de lo que recibe el comercio (`festa-payment-service#1`, migración 009). No es costo de Festa. Boleta promedio de 35.000 COP, solo para calcular ese cargo.

## 2. Precios usados

| Recurso | Precio (USD) | Fuente |
|---|---|---|
| Fargate | 0,04048 por vCPU-hora; 0,004445 por GB-hora | AWS Price List API, publicación del 11-nov-2026 |
| IPv4 pública (una por tarea) | 0,005 por hora | ídem |
| RDS PostgreSQL Single-AZ | t3.micro 0,018/h; t3.small 0,036/h; t3.medium 0,072/h; gp3 0,115 por GB-mes | ídem |
| ElastiCache Redis | t3.micro 0,017/h; t3.small 0,034/h; t3.medium 0,068/h | ídem |
| ALB y NLB internos | 0,0225/h cada uno; LCU 0,008 y 0,006 por hora | ídem |
| API Gateway (HTTP API) | 1,00 por millón de peticiones | ídem |
| Salida a internet | 0,09 por GB | ídem (sin los 100 GB gratis) |
| CloudWatch Logs | 0,50 por GB ingerido; 0,03 por GB-mes | ídem |
| Secrets Manager, EFS | 0,40 por secreto al mes; 0,30 por GB-mes | ídem |
| Gemini (`gemini-3.5-flash-lite`) | 0,30 por millón de tokens de entrada; 2,50 por millón de salida | aistudio.google.com/docs/pricing |
| Mapbox Maps SDK móvil | 4,00 por cada 1.000 MAU | mapbox.com/pricing |
| Wompi | 2,65 % + 700 COP + IVA 19 % sobre la comisión | tarifario de Wompi |

**Aviso sobre Gemini:** `gemini-2.5-flash`, el modelo que hoy usa ai-service, **se apaga el 1 de diciembre de 2026**. Desde ese día Google enruta las peticiones a `gemini-3.5-flash-lite`, que cuesta lo mismo. Conviene cambiar `LLM_CHAT_MODEL` y `LLM_DESCRIPTION_MODEL` antes de esa fecha.

## 3. Costo de operación por mes (AWS)

| Rubro | Fase 1 | Fase 2 | Fase 3 |
|---|---:|---:|---:|
| Fargate (tareas encendidas 24/7) | 127,76 | 199,84 | 371,03 |
| IPv4 públicas de las tareas | 40,15 | 62,05 | 116,80 |
| RDS PostgreSQL | 13,14 | 52,56 | 52,56 |
| ElastiCache Redis | 12,41 | 24,82 | 49,64 |
| ALB y NLB internos | 32,85 | 32,85 | 32,85 |
| Almacenamiento (RDS, EFS de Mongo, secreto) | 4,20 | 4,20 | 4,20 |
| **Fijo** | **230,51** | **376,32** | **627,08** |
| Tráfico sin compra (sección 4) | 26,76 | 200,78 | 669,27 |
| IA de los organizadores (11.760, 49.000 y 196.000 solicitudes) | 19,40 | 80,85 | 323,40 |
| Compras (infraestructura) | 0,01 | 0,06 | 0,19 |
| **Total al mes (USD)** | **276,70** | **658,01** | **1.619,95** |
| Total al mes (COP) | 913.095 | 2.171.441 | 5.345.829 |
| Costo por MAU (USD) | 0,069 | 0,022 | 0,016 |

En la Fase 1 hay 11 tareas (3,5 vCPU y 7,5 GB): los 8 servicios, Kong, RabbitMQ y MongoDB, como en `festa-infra/terraform/aws-lab`. **El 83 % del costo es fijo:** lo que más pesa es tener la plataforma encendida, no los usuarios.

## 4. Tráfico de quienes no compran

La mayoría de los usuarios solo navega. Su costo por mes:

| Rubro | Fase 1 | Fase 2 | Fase 3 |
|---|---:|---:|---:|
| Mapa de Mapbox | 16,00 | 120,00 | 400,00 |
| Chat de recomendaciones con IA | 8,60 | 64,50 | 215,00 |
| Salida a internet | 0,84 | 6,33 | 21,09 |
| API Gateway | 0,72 | 5,40 | 18,00 |
| Logs | 0,36 | 2,73 | 9,10 |
| Capacidad de balanceadores (LCU) | 0,24 | 1,82 | 6,08 |
| **Total** | **26,76** | **200,78** | **669,27** |

**Por usuario que no compra: USD 0,0067 al mes (unos 22 COP).** El 60 % es Mapbox y el 32 % es el chat de IA. Mapbox incluye 25.000 MAU gratis al mes; con esa franja, el mapa costaría USD 0 en la Fase 1, USD 20 en la Fase 2 y USD 300 en la Fase 3, pero el criterio de la tarea pide no contarla.

## 5. Ingresos con Festa Pro, por transacción y punto de equilibrio

El modelo oficial (XLSM) cobra al organizador una suscripción con cupo de IA y overage; el público usa Festa gratis. **La comisión por boleta no se incluye**: es un ingreso adicional posible (la discrepancia con SCRUM-27 sigue abierta en Jira hasta que el equipo la alinee).

Por organizador al mes:

| Concepto | COP |
|---|---:|
| Suscripción Festa Pro | 79.000 |
| Overage de IA (196 solicitudes, 150 incluidas: 46 × 60) | 2.760 |
| **ARPU** | **81.760** |
| Wompi sobre el cobro mensual (2,65 % + 700 + IVA) | 3.411 |
| **Neto antes de IA y costos fijos** | **78.349** |

Por boleta de 35.000 COP: la infraestructura de la compra cuesta 0,13 COP y Wompi cobra 1.937 COP. Festa no cobra comisión y el comprador paga solo el precio de la boleta: **esa tarifa se descuenta al comercio** (decisión del equipo, 2026-11-21; el pago neto es el subtotal menos la comisión, `festa-payment-service#1`). No entra al costo de Festa.

| | Fase 1 | Fase 2 | Fase 3 |
|---|---:|---:|---:|
| Organizadores con Festa Pro | 60 | 250 | 1.000 |
| Ingresos por suscripción y overage (COP) | 4.905.600 | 20.440.000 | 81.760.000 |
| Wompi sobre las suscripciones (COP) | 204.678 | 852.825 | 3.411.302 |
| Costo de operación, sección 3 (COP) | 913.095 | 2.171.441 | 5.345.829 |
| **Margen sobre la operación (COP)** | **3.787.827** | **17.415.734** | **73.002.870** |
| Margen sobre la operación (USD) | 1.147,83 | 5.277,50 | 22.122,08 |
| Organizadores para cubrir la operación (con la IA de cada organizador como costo marginal) | 11 | 25 | 56 |

**Lectura:**
- **La operación se cubre con pocos organizadores:** 11 en el piloto (de los 60 supuestos), 25 en la Fase 2 y 56 en la Fase 3. La IA de cada organizador (unos 1.067 COP al mes) se trata como costo marginal: el umbral deja fijos la infraestructura, el tráfico sin compra y las compras de la fase, y suma la IA solo de los organizadores que pagan.
- **Este margen no incluye nómina, mercadeo ni otros gastos.** El XLSM sí los incluye (9,3 millones de COP de costos fijos al mes) y por eso necesita unos 128 organizadores para el equilibrio, con utilidad positiva desde el mes 8 si la base crece 12 % mensual.
- **El volumen de IA es el mismo que se factura** (196 solicitudes por organizador), pero el costo por solicitud no es el del XLSM: aquí son unos 5,4 COP con la tarifa vigente de Gemini y la TRM de 3.300; el XLSM usa 30 COP (tarifa de referencia de 1 y 5 USD por millón de tokens, TRM de 4.000 y 40 % de sobrecosto). Con el costo del XLSM, la IA del piloto pasaría de USD 19 a unos USD 107 al mes y el margen seguiría siendo positivo. El chat de recomendaciones del público (sección 4) es aparte: no se factura a nadie.
- **Wompi de las boletas lo paga el comercio** (decisión del equipo, 2026-11-21): se le descuenta de lo que recibe y no afecta el margen de Festa. Son unos 0,39, 2,9 y 9,7 millones de COP al mes en cada fase que dejan de ser un posible costo de Festa. Falta confirmar en el sandbox de Wompi el IVA y el reembolso.

## 6. Costo de desarrollo (aparte de la operación)

| Rubro | USD al mes |
|---|---:|
| Entorno de pruebas en AWS: 4 horas al día, 22 días, a USD 0,3158 por hora | 27,79 |
| Gemini durante el desarrollo, unas cuantas generaciones de prueba | menos de 1 |
| GitHub Actions y GHCR: repositorios públicos, sin cobro por minutos ni almacenamiento | 0 |
| **Total** | **unos 29** |

Los **USD 50 de créditos** del Learner Lab alcanzan para unas **158 horas** de la Fase 1 encendida, unos 40 días a 4 horas diarias. No se incluye el tiempo del equipo, porque es un proyecto académico.

## 7. Comparación de nubes (Fase 1, solo el costo fijo, mismos supuestos)

| Nube | Arquitectura equivalente | USD al mes |
|---|---|---:|
| **AWS** | ECS Fargate, RDS t3.micro, ElastiCache t3.micro, ALB y NLB internos, API Gateway | **230,51** |
| Azure | Container Apps (consumo, réplicas mínimas en 1 y siempre activas), PostgreSQL Flexible B1ms, Redis C0 | 310,65 |
| GCP | Cloud Run por instancia, Cloud SQL micro, Memorystore 1 GB, y una VM E2 para RabbitMQ y MongoDB | 525,32 |

- **Azure** no necesita balanceadores, porque Container Apps trae el ingreso HTTPS incluido. Aun así sale más caro: sus contenedores nunca pasan a la tarifa de reposo, porque los consumidores de RabbitMQ y los publicadores del outbox trabajan todo el tiempo.
- **GCP** es el más caro con esta arquitectura. Cloud Run solo permite menos de 1 vCPU con facturación por petición, que congela la CPU entre peticiones, y los servicios necesitan CPU en segundo plano. Eso obliga a 1 vCPU por servicio (9 en total en vez de 2,75). Además, Cloud Run no acepta TCP, así que RabbitMQ y MongoDB van en una VM aparte.
- **Los costos variables son parecidos en las tres nubes:** Mapbox y Gemini no dependen de la nube.

Precios de Azure: API Retail Prices (eastus). Precios de GCP: Cloud Billing Catalog (us-east1). Los dos se consultaron el 16 de noviembre de 2026.

## 8. Cifras del pitch: reemplazo

| En el pitch | Con este modelo |
|---|---|
| El piloto cuesta USD 113 al mes | **USD 277 al mes** (913.000 COP), operación en AWS sin capas gratuitas |
| Con USD 2.000 se cubren 17 meses | **Unos 7 meses** de infraestructura sin contar ingresos. Si los 60 organizadores del piloto pagan Festa Pro, los ingresos (USD 1.487 al mes) cubren la operación y los USD 2.000 no se consumen |
| Cada usuario deja USD 0,40 y cuesta USD 0,30 al mes | En el piloto, cada MAU deja **USD 0,372** de ingreso y cuesta **USD 0,069**. En la Fase 2 deja USD 0,207 y cuesta USD 0,022 |

## 9. Dónde se puede ahorrar

1. **IPv4 públicas: USD 40 al mes en la Fase 1 (17 % del fijo).** Cada tarea tiene una IP pública porque no hay NAT. Un NAT Gateway cuesta más (unos USD 33 al mes más el tráfico), así que en el laboratorio conviene juntar servicios pequeños en menos tareas.
2. **Mapbox es el mayor costo variable.** En producción sí se aprovecharían los 25.000 MAU incluidos.
3. **Caché de recomendaciones de IA.** Si se reutilizan respuestas para preguntas parecidas, el costo del chat baja en proporción.
4. **Apagar el entorno de pruebas** cuando no se use: cada hora encendida cuesta USD 0,32.

## 10. Riesgos y límites del modelo

- Los supuestos de uso (sesiones, peticiones, mensajes de chat) son estimaciones y **hay que recalibrarlos con las métricas del piloto** (analytics-service, RF15).
- Los tamaños de las Fases 2 y 3 son una primera aproximación. Hay que validarlos con pruebas de carga (SCRUM-78).
- La TRM y los precios de terceros cambian. El script permite recalcular en un minuto.
- No incluye impuestos sobre los ingresos de Festa, soporte, mercadeo ni nómina (el XLSM sí incluye nómina, mercadeo y otros gastos; ver sección 5).
- Los organizadores de cada fase son supuestos: el piloto de 60 viene del XLSM, y las Fases 2 y 3 siguen la proporción de 4 eventos por organizador.
