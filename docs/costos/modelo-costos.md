# Modelo de costos de Festa (SCRUM-131)

- **Estado:** borrador. Los supuestos de la sección 1 esperan la aprobación del equipo.
- **Fecha:** 2026-11-16 · **Responsable:** Brayan Loaiza
- **Reemplaza:** las cifras del pitch (USD 113 al mes y 17 meses con USD 2.000) y el presupuesto del *Informe de arquitectura y viabilidad* de septiembre, que suponía GCP con capas gratuitas.
- **Cálculo reproducible:** [`modelo_costos.py`](modelo_costos.py). Todos los supuestos y precios están arriba del archivo; al cambiar uno, `python modelo_costos.py` recalcula todo.

**Reglas del cálculo.** Precios de lista **sin capas gratuitas** (cada recurso se cobra desde la primera unidad), región us-east-1, 730 horas al mes y TRM de **3.300 COP por dólar** (la del 11 de noviembre fue 3.297,07). Se separa el costo de **operación** (el servicio encendido para usuarios reales) del de **desarrollo** (sección 6).

## 1. Supuestos (pendientes de aprobación)

| Supuesto | Fase 1 · Piloto ECI | Fase 2 · Bogotá zonal | Fase 3 · Ciudad |
|---|---|---|---|
| Usuarios activos al mes (MAU) | 4.000 | 30.000 | 100.000 |
| Eventos creados al mes | 150 | 1.000 | 4.000 |
| Boletas vendidas al mes | 200 | 1.500 | 5.000 |
| Comercios destacados | 5 | 40 | 150 |
| Réplicas de los servicios de la ruta crítica (gateway, auth, user, event, booking, payment) | 1 | 2 | 4 |
| Réplicas de ai, notification y analytics | 1 | 1 | 2 |
| Base de datos y caché | db.t3.micro, cache.t3.micro | db.t3.medium, cache.t3.small | db.t3.medium, cache.t3.medium |

Uso por usuario, igual en las tres fases:
- **6 sesiones al mes por MAU** (DAU/MAU de 15 a 20 %, del informe de viabilidad), con **30 peticiones** y **0,4 MB** por sesión. Las imágenes se sirven por URL externa.
- **Chat de IA:** lo usa el 25 % de los MAU, 4 mensajes al mes cada uno, con 3.000 tokens de entrada y 500 de salida por mensaje.
- **Descripción con IA:** 1,5 generaciones por evento (con alguna regeneración), 800 tokens de entrada y 400 de salida.
- **Compra:** 20 peticiones y 0,1 MB.
- **Negocio:** boleta promedio de 35.000 COP, comisión del 8 %, destacado a 50.000 COP al mes. Wompi cobra 2,65 % + 700 COP + IVA, y **lo paga el comprador** como cargo por servicio (recomendación del informe de viabilidad). La sección 5 muestra qué pasa si lo absorbe Festa.

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
| Descripciones con IA | 0,28 | 1,86 | 7,44 |
| Compras (infraestructura) | 0,01 | 0,06 | 0,19 |
| **Total al mes (USD)** | **257,57** | **579,02** | **1.303,99** |
| Total al mes (COP) | 849.982 | 1.910.774 | 4.303.161 |
| Costo por MAU (USD) | 0,064 | 0,019 | 0,013 |

En la Fase 1 hay 11 tareas (3,5 vCPU y 7,5 GB): los 8 servicios, Kong, RabbitMQ y MongoDB, como en `festa-infra/terraform/aws-lab`. **El 90 % del costo es fijo:** lo que más pesa es tener la plataforma encendida, no los usuarios.

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

## 5. Por transacción y justificación del 8 %

Por cada boleta de 35.000 COP:

| Concepto | COP |
|---|---:|
| Comisión de Festa (8 %) | **2.800** |
| Infraestructura de la compra | 0,13 |
| Wompi (2,65 % + 700 + IVA) | 1.937, que lo paga el comprador |

La compra en sí casi no cuesta: **los 2.800 COP sirven para pagar la parte fija**, es decir, tener la plataforma encendida y atender a quienes no compran. Boletas al mes que hacen falta para el punto de equilibrio:

| | Fase 1 | Fase 2 | Fase 3 |
|---|---:|---:|---:|
| Solo con comisión | 304 | 682 | 1.537 |
| Con comisión y destacados | 214 | 0, los destacados ya cubren el costo | 0 |
| Si Festa absorbe Wompi (gana 863 COP netos por boleta) | 695 | 0 | 0 |
| Boletas supuestas en la fase | 200 | 1.500 | 5.000 |
| **Resultado mensual (USD)** | **−12,12** | **+1.299,77** | **+5.211,16** |

**Conclusión sobre el 8 %:**
- **Es suficiente desde la Fase 2.** Con 1.500 boletas y 40 destacados, los ingresos (6.200.000 COP) triplican el costo (1.910.774 COP).
- **En el piloto queda casi en equilibrio.** Faltan unos 14 boletas al mes para cubrir los USD 257,57 con los 5 destacados supuestos.
- **Trasladar Wompi al comprador es indispensable:** si Festa lo absorbe, en el piloto se necesitarían 695 boletas en vez de 214.
- Frente al 10 a 15 % que cobran las boleterías en Colombia, **el 8 % sigue siendo competitivo** y cubre el costo con holgura desde la Fase 2.

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
| El piloto cuesta USD 113 al mes | **USD 258 al mes** (850.000 COP), operación en AWS sin capas gratuitas |
| Con USD 2.000 se cubren 17 meses | **Unos 8 meses** de infraestructura sin contar ingresos. Con los ingresos supuestos del piloto, el déficit es de USD 12 al mes y los USD 2.000 duran mucho más |
| Cada usuario deja USD 0,40 y cuesta USD 0,30 al mes | En el piloto, cada MAU deja **USD 0,061** y cuesta **USD 0,064**. En la Fase 2 deja USD 0,063 y cuesta USD 0,019 |

## 9. Dónde se puede ahorrar

1. **IPv4 públicas: USD 40 al mes en la Fase 1 (17 % del fijo).** Cada tarea tiene una IP pública porque no hay NAT. Un NAT Gateway cuesta más (unos USD 33 al mes más el tráfico), así que en el laboratorio conviene juntar servicios pequeños en menos tareas.
2. **Mapbox es el mayor costo variable.** En producción sí se aprovecharían los 25.000 MAU incluidos.
3. **Caché de recomendaciones de IA.** Si se reutilizan respuestas para preguntas parecidas, el costo del chat baja en proporción.
4. **Apagar el entorno de pruebas** cuando no se use: cada hora encendida cuesta USD 0,32.

## 10. Riesgos y límites del modelo

- Los supuestos de uso (sesiones, peticiones, mensajes de chat) son estimaciones y **hay que recalibrarlos con las métricas del piloto** (analytics-service, RF15).
- Los tamaños de las Fases 2 y 3 son una primera aproximación. Hay que validarlos con pruebas de carga (SCRUM-78).
- La TRM y los precios de terceros cambian. El script permite recalcular en un minuto.
- No incluye impuestos sobre los ingresos de Festa, soporte, mercadeo ni nómina.
