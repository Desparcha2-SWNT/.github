# ADR 0001 — Plataforma de despliegue: AWS

- **Estado:** Aceptada (ratificada por el equipo el 2026-11-07)
- **Fecha:** 2026-11-07
- **Participantes:** propuesto por Juan Sebastián Guayazán Clavijo; Brayan Loaiza (dueño de SCRUM-134) lo respaldó por los créditos de AWS. El equipo Desparcha2 lo confirmó el 2026-11-07 (comunicado por Juan; los nombres de quienes lo ratificaron no están anotados).
- **Historias relacionadas (Jira):** SCRUM-134, SCRUM-131, SCRUM-135

## Contexto
La decisión del 25 de octubre fue Azure, y los repositorios nuevos no definen la nube. El profesor ofreció créditos de AWS si el proyecto se despliega allí; con Azure o GCP el costo sale del equipo (SCRUM-134). Los créditos son una cuenta de AWS Academy (Learner Lab) con permisos restringidos y sesiones que vencen, así que el entorno se apaga y hay que poder redesplegarlo con scripts desde cero.

El 7 de noviembre de 2026 Brayan Loaiza verificó los permisos reales del Learner Lab (us-east-1), solo con consultas de lectura y simulación de permisos, sin crear recursos. Esa verificación cambió dos servicios de la propuesta inicial (Amazon MQ y DocumentDB).

Había tres páginas de arquitectura en Lucid (Azure, AWS y GCP) con el mismo contenido, y los diagramas daban respuestas distintas para el registro de imágenes y el LLM.

## Opciones consideradas
1. **AWS:** créditos que ofreció el profesor; ECS Fargate (servicios sin estado y autoescalado sin administrar un clúster), RDS, ElastiCache, ALB y Secrets Manager. La propuesta inicial incluía también Amazon MQ y DocumentDB, que el Learner Lab no permite (ver Decisión).
2. **Azure:** la decisión previa; AKS ofrece más control, pero el costo sale del equipo.
3. **GCP:** Cloud Run, Cloud SQL y Memorystore; tampoco tiene créditos.

## Decisión
Se despliega en **AWS**, en la región us-east-1, con los servicios de la página "Despliegue en AWS (oficial)" de Lucid. Las páginas de Azure y GCP se eliminaron: AWS es la única plataforma vigente.

- Cómputo: Amazon ECS en Fargate, con las imágenes publicadas en GitHub Container Registry (GHCR) desde GitHub Actions; Fargate las descarga con credenciales guardadas en Secrets Manager.
- Entrada: un Application Load Balancer con HTTPS (certificado de ACM) delante del gateway Kong.
- Datos: una base por servicio. Cinco en una instancia de RDS PostgreSQL (hasta tamaño medium) y tres bases MongoDB (`ai_db`, `notification_db` y `analytics_db`) en un contenedor de MongoDB en Fargate con almacenamiento EFS, con bases y credenciales separadas. Solo las usan ai, notification y analytics (Sprint 3 en adelante), así que se puede aplazar.
- Mensajería: RabbitMQ como contenedor en Fargate (imagen oficial `rabbitmq:3.13-management`), que carga `contracts/rabbitmq/definitions.json` al arrancar igual que el Docker Compose de `festa-infra`.
- Permisos: las tareas de ECS usan el rol existente `LabRole` (`data "aws_iam_role"` en Terraform); no se crean roles IAM ni proveedores OIDC.
- Red: las tareas van en las subredes públicas de la VPC por defecto con IP pública, sin NAT Gateway.
- LLM: Gemini, como API externa (ADR 0003).

## Consecuencias
- Los créditos de AWS solo aplican si se avisa al profesor con los correos del equipo (SCRUM-134).
- Hay que escribir la infraestructura como código y los scripts de redespliegue (SCRUM-134), y calcular el costo en AWS por transacción y uso proyectado, sin capas gratuitas (SCRUM-131).
- La política de privacidad debe nombrar a AWS como proveedor de la nube (SCRUM-129).
- Si se prefiere ECR a GHCR, se cambia el CD de los servicios; hoy publican en GHCR.
- **Restricciones del Learner Lab** (verificadas el 7-nov-2026): RDS solo hasta tamaño medium (db.t3.micro, db.t3.medium y db.t4g.medium; db.r5.large da explicit deny); solo las regiones us-east-1 y us-west-2; ElastiCache permitido (incluido cache.t3.micro); ECS Fargate, ALB, ACM, Secrets Manager, CloudWatch Logs, EFS y S3 permitidos.
- **Sin crear roles IAM ni OIDC:** Terraform no crea roles y GitHub Actions entra con las credenciales temporales del lab guardadas como secretos, que hay que renovar en cada sesión (unas 4 horas). Un despliegue automático continuo desde Actions no es viable sin esa renovación.
- **Service discovery pendiente:** Cloud Map (`servicediscovery:CreatePrivateDnsNamespace`) salió ambiguo en la simulación. Kong necesita encontrar los servicios: ECS Service Connect lo requiere; si no funciona, la alternativa es un ALB interno. Se confirma con la primera prueba real de Terraform (SCRUM-134).
- **ElastiCache** debe usarse con *cluster mode disabled*: el reparto en las bases 0 (mapa), 1 (límite de IA) y 2 (caché de perfiles de user-service) no funciona con ElastiCache Serverless ni con el modo clúster, que solo permiten la base 0.
- **Amazon MQ y DocumentDB no están permitidos** en el lab (`mq:CreateBroker` da explicit deny y el motor `docdb` no está habilitado en `rds:CreateDBInstance`; la simulación de DocumentDB no es concluyente al 100 %). Por eso RabbitMQ y MongoDB corren como contenedores en Fargate; hay que contarlos en el modelo de costos (SCRUM-131) y tener presente que MongoDB en EFS no tiene alta disponibilidad.
- **El SNS de las notificaciones push** (fase 2) no se verificó en el lab.
- Pendiente: la prueba de redespliegue completo desde cero y el tiempo que tarda.
