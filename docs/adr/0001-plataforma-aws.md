# ADR 0001 — Plataforma de despliegue: AWS

- **Estado:** Propuesta (pasa a Aceptada cuando el equipo la ratifique; entonces se anotan la fecha y quién participó)
- **Fecha:** 2026-11-07
- **Participantes:** propuesto por Juan Sebastián Guayazán Clavijo; Brayan Loaiza (dueño de SCRUM-134) está de acuerdo por los créditos de AWS. Falta que el resto del equipo Desparcha2 lo ratifique.
- **Historias relacionadas (Jira):** SCRUM-134, SCRUM-131, SCRUM-135

## Contexto
La decisión del 25 de octubre fue Azure, y los repositorios nuevos no definen la nube. El profesor ofreció créditos de AWS si el proyecto se despliega allí; con Azure o GCP el costo sale del equipo (SCRUM-134). El entorno se apaga fuera de las demostraciones, así que hay que poder redesplegarlo con scripts desde cero.

Había tres páginas de arquitectura en Lucid (Azure, AWS y GCP) con el mismo contenido, y los diagramas daban respuestas distintas para el registro de imágenes y el LLM.

## Opciones consideradas
1. **AWS:** créditos que ofreció el profesor; ECS Fargate (servicios sin estado y autoescalado sin administrar un clúster), RDS, DocumentDB, ElastiCache, Amazon MQ (RabbitMQ), SNS y Secrets Manager.
2. **Azure:** la decisión previa; AKS ofrece más control, pero el costo sale del equipo.
3. **GCP:** Cloud Run, Cloud SQL y Memorystore; tampoco tiene créditos.

## Decisión
Se despliega en **AWS**, en la región us-east-1, con los servicios de la página "Arquitectura AWS (oficial)" de Lucid. Azure y GCP quedan como páginas alternativas, no como diseño vigente.

- Cómputo: Amazon ECS en Fargate, con las imágenes publicadas en GitHub Container Registry (GHCR) desde GitHub Actions; Fargate las descarga con credenciales guardadas en Secrets Manager.
- Entrada: un Application Load Balancer con HTTPS (certificado de ACM) delante del gateway Kong.
- Datos: una base por servicio. Cinco en una instancia de RDS PostgreSQL y tres en un solo clúster de DocumentDB, con bases y credenciales separadas.
- LLM: Gemini, como API externa (ADR 0003).

## Consecuencias
- Los créditos de AWS solo aplican si se avisa al profesor con los correos del equipo (SCRUM-134).
- Hay que escribir la infraestructura como código y los scripts de redespliegue (SCRUM-134), y calcular el costo en AWS por transacción y uso proyectado, sin capas gratuitas (SCRUM-131).
- La política de privacidad debe nombrar a AWS como proveedor de la nube (SCRUM-129).
- Si se prefiere ECR a GHCR, se cambia el CD de los servicios; hoy publican en GHCR.
- **Amazon MQ** no carga `definitions.json` al arrancar, como sí lo hace el Docker Compose de `festa-infra`. La topología (exchanges, colas `.inbox`, `.retry` y `.dlq`, y `festa.dlx`) hay que aplicarla con la API de administración de RabbitMQ desde los scripts de redespliegue (SCRUM-134).
- **ElastiCache** debe usarse con *cluster mode disabled*: el reparto en las bases 0 (mapa), 1 (límite de IA) y 2 (caché de perfiles de user-service) no funciona con ElastiCache Serverless ni con el modo clúster, que solo permiten la base 0.
- **DocumentDB** no tiene instancias de la familia micro (la más pequeña es de clase medium: db.t4g.medium o db.t3.medium) y no es 100 % compatible con MongoDB. Hay que tenerlo en cuenta en el modelo de costos (SCRUM-131) y en las pruebas de `festa-ai-service`, `festa-notification-service` y `festa-analytics-service`.
- Pendiente: la prueba de redespliegue completo desde cero y el tiempo que tarda.
