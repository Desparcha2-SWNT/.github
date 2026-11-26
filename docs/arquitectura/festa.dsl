workspace "Festa" "Aplicación de descubrimiento de eventos y visibilidad para comercios locales, construida por Soluciones Tecnológicas de Ingeniería" {

    !identifiers hierarchical

    # Fuente: código en develop de Desparcha2-SWNT/festa-* y PR abiertos de la app, revisados el 23-nov-2026.
    # Despliegue en AWS: ADR 0001. Proveedor de LLM: ADR 0003.

    model {
        persona = person "Persona interesada en eventos" "Descubre eventos y planes en un mapa, recibe recomendaciones, confirma su asistencia y entra con un QR."
        comercio = person "Comercio / organizador" "Crea y gestiona eventos, valida entradas con QR y mide el retorno desde su panel."

        pagos = softwareSystem "Wompi (pasarela de pagos, versión futura)" "Cobro de boletas en un checkout firmado, confirmado por webhook. Construido, pero no se activa en el MVP (RF11)." "External"
        ia = softwareSystem "Groq API" "Modelo de lenguaje externo para descripciones de eventos y recomendaciones (ADR 0006)." "External"
        notificaciones = softwareSystem "Firebase Cloud Messaging" "Servicio de Google que entrega las notificaciones push al dispositivo Android." "External"
        identidad = softwareSystem "Google Identity" "Autenticación federada (OAuth2). El backend la soporta; el inicio de sesión con Google en la app queda fuera del MVP." "External"
        mapas = softwareSystem "Mapbox" "Servicio externo de mapas que usa la app para mostrar eventos." "External"

        group "Soluciones Tecnológicas de Ingeniería" {
            administrador = person "Administrador de la plataforma" "Verifica comercios y modera reportes; soporte interno del producto."
            equipoPlataforma = person "Equipo de plataforma (DevOps)" "Perfil técnico interno: despliega, configura y monitorea la infraestructura de Festa."

            festa = softwareSystem "Festa" "Aplicación que centraliza el descubrimiento de eventos en un mapa, con recomendaciones por IA y entrada con QR." {
                mobile = container "festa-mobile" "App del usuario y vista de comercio: mapa, chat con IA, compra, pases QR, escáner y panel (RF15). Caché local del último listado." "Flutter (Android)" "Mobile"
                gateway = container "festa-gateway" "Punto de entrada único: enruta peticiones, valida el JWT y aplica rate limiting (RNF8)." "Kong 3.9 DB-less (tarea en Amazon ECS Fargate)"
                auth = container "festa-auth-service" "RF1: registro e inicio de sesión con correo y Google; emite el JWT." "Spring Boot 3.5 (tarea en Amazon ECS Fargate)" {
                    api = component "Controlador de autenticación" "Endpoints REST: registro, inicio y cierre de sesión, renovación, Google, datos propios y roles de administrador." "REST"
                    servicio = component "Servicio de autenticación" "Crea cuentas, valida credenciales y bloquea la cuenta tras 5 intentos fallidos." "Servicio"
                    tokens = component "Emisor de tokens" "Emite JWT firmados con RS256 y gestiona los tokens de renovación." "Servicio"
                    verificador = component "Verificador de Google" "Valida el id_token de Google antes de abrir o crear la sesión." "Servicio"
                    cuentas = component "Repositorio de cuentas" "Guarda cuentas, roles y tokens de renovación." "Repositorio"
                    privacidad = component "Autorización de datos" "Registra la autorización de datos personales conforme a la Ley 1581 y cifra los datos sensibles." "Servicio"
                    publicador = component "Publicador (outbox)" "Publica los eventos guardados en la base." "Productor AMQP"
                    consumidor = component "Consumidor (inbox)" "Procesa una sola vez los eventos de moderación." "Consumidor AMQP"

                    api -> servicio "Registra, inicia y cierra sesión"
                    servicio -> tokens "Pide un JWT"
                    servicio -> verificador "Valida el token de Google"
                    verificador -> identidad "Valida con Google"
                    servicio -> cuentas "Lee y escribe cuentas"
                    servicio -> privacidad "Registra la autorización"
                    servicio -> publicador "Guarda el evento en la misma transacción"
                    consumidor -> servicio "Suspende o reactiva la cuenta"
                }
                user = container "festa-user-service" "RF2, RF3 y RF14: perfiles, preferencias, verificación manual de comercios, reportes y moderación." "Spring Boot (tarea en Amazon ECS Fargate)" {
                    api = component "Controladores REST" "Perfil, preferencias, intereses, consentimientos, comercios, reportes y moderación." "REST"
                    perfiles = component "Servicios de perfil" "Perfil, preferencias, intereses y consentimientos." "Servicio"
                    comercios = component "Servicios de comercio" "Solicitud, verificación manual y perfil público del comercio." "Servicio"
                    moderacion = component "Servicio de moderación" "Ocultar o restaurar eventos, suspender o reactivar cuentas y resolver reportes." "Servicio"
                    perfilCache = component "Caché de perfiles" "Guarda perfiles en Redis para no consultarlos en cada petición." "Caché"
                    manejadores = component "Manejadores de eventos (inbox)" "Procesa una sola vez el registro y la eliminación de cuentas." "Consumidor AMQP"
                    publicador = component "Publicador (outbox)" "Publica los cambios de perfil, comercio y moderación." "Productor AMQP"

                    api -> perfiles "Perfil, preferencias e intereses"
                    api -> comercios "Solicitud y verificación de comercio"
                    api -> moderacion "Moderación (administración)"
                    perfiles -> perfilCache "Lee y actualiza el perfil"
                    perfiles -> publicador "Guarda el evento en la misma transacción"
                }
                event = container "festa-event-service" "RF4, RF5, RF6 y RF19: CRUD de eventos, búsqueda geográfica, filtros y Parches en Vivo." "Node.js (tarea en Amazon ECS Fargate)" {
                    api = component "Rutas REST de eventos" "Crear, listar, buscar por zona, editar, cancelar y registrar vistas." "REST"
                    autenticacion = component "Middleware de autenticación" "Verifica el JWT de cada petición." "Middleware"
                    ciclo = component "Ciclo de vida" "Reglas de estado: publicado, oculto, cancelado y expirado." "Servicio"
                    busqueda = component "Búsqueda geográfica" "Filtros por categoría, fecha y distancia, y agrupación por zona con PostGIS." "Servicio"
                    repo = component "Repositorio de eventos" "Guarda y consulta eventos en PostgreSQL." "Repositorio"
                    expira = component "Expiración de eventos" "Marca como expirados los eventos vencidos." "Trabajo programado"
                    inbox = component "Consumidor (inbox)" "Procesa una sola vez asistencia, comercios, moderación y cuentas." "Consumidor AMQP"
                    outbox = component "Publicador (outbox)" "Publica los cambios de evento." "Productor AMQP"

                    api -> autenticacion "Verifica el JWT"
                    api -> ciclo "Aplica las reglas de estado"
                    api -> busqueda "Busca y filtra"
                    ciclo -> repo "Lee y escribe"
                    busqueda -> repo "Consulta"
                    expira -> repo "Marca eventos vencidos"
                    inbox -> repo "Actualiza el evento"
                    repo -> outbox "Guarda el cambio en la misma transacción"
                }
                booking = container "festa-booking-service" "RF7 y RF10: confirmación de asistencia y QR único de un solo uso." "Node.js (tarea en Amazon ECS Fargate)" {
                    api = component "API de asistencia y pases" "Endpoints REST: confirmar y cancelar asistencia, listar planes y pases, y hacer check-in." "REST"
                    asistencia = component "Gestor de asistencia" "Confirma asistencia con cupo y sube attendanceVersion en la misma transacción (RF7)." "Servicio"
                    pases = component "Gestor de pases" "Emite pases, los revoca y marca el check-in una sola vez (RF10, RNF7)." "Servicio"
                    qr = component "Codec de QR" "Genera y verifica el QR firmado con HMAC." "Servicio"
                    inbox = component "Consumidor (inbox)" "Procesa una sola vez eventos de cuenta, evento y orden; emite pases al aprobarse un pago." "Consumidor AMQP"
                    outbox = component "Publicador (outbox)" "Publica los eventos guardados en la base." "Productor AMQP"
                    api -> asistencia "Confirma o cancela asistencia"
                    api -> pases "Consulta pases y hace check-in"
                    pases -> qr "Genera y verifica el QR"
                    inbox -> pases "Emite o revoca pases"
                }
                payment = container "festa-payment-service" "RF11: órdenes, retención de cupo, checkout de Wompi, reembolsos y liquidación al comercio." "Node.js (tarea en Amazon ECS Fargate)" {
                    api = component "API de pagos" "Endpoints REST: cotizar, crear y consultar órdenes, reembolsos y liquidaciones." "REST"
                    ordenes = component "Gestor de órdenes" "Crea la orden con Idempotency-Key, retiene el cupo y aplica el resultado del pago." "Servicio"
                    precios = component "Calculador de precios" "Calcula el total y la comisión de Wompi que se descuenta al comercio." "Servicio"
                    checkout = component "Checkout Wompi" "Firma la referencia y arma la URL del checkout." "Servicio"
                    webhook = component "Receptor de webhooks" "Recibe la confirmación del pago y verifica su firma." "REST"
                    expiracion = component "Expirador de órdenes" "Libera el cupo de las órdenes vencidas." "Tarea programada"
                    inbox = component "Consumidor (inbox)" "Mantiene su copia de eventos y comercios verificados." "Consumidor AMQP"
                    outbox = component "Publicador (outbox)" "Publica order.approved y los demás eventos de pago." "Productor AMQP"
                    api -> ordenes "Crea y consulta órdenes"
                    api -> checkout "Pide los datos del checkout"
                    ordenes -> precios "Calcula el precio"
                    webhook -> ordenes "Aplica el resultado del pago"
                    expiracion -> ordenes "Expira órdenes pendientes"
                }
                ai = container "festa-ai-service" "RF8 y RF9: chat de recomendaciones y descripciones con IA; límite por usuario (RNF8)." "Python, FastAPI (tarea en Amazon ECS Fargate)" {
                    api = component "API de IA" "Endpoints REST de chat y descripciones." "REST"
                    limitador = component "Limitador de solicitudes" "Aplica el tope por usuario y por minuto en Redis (RNF8)." "Servicio"
                    chat = component "Chat de recomendaciones" "Arma el contexto con eventos reales y descarta los que no estén entre los candidatos (RF8)." "Servicio"
                    descripciones = component "Generador de descripciones" "Genera la descripción y la guarda para no volver a pedirla (RF9)." "Servicio"
                    cliente = component "Cliente LLM (Groq)" "Llama al modelo y controla errores." "Cliente HTTP"
                    inbox = component "Consumidor (inbox)" "Mantiene catálogo, preferencias y comercios desde RabbitMQ." "Consumidor AMQP"
                    outbox = component "Publicador (outbox)" "Publica el uso de la IA para analítica." "Productor AMQP"
                    api -> limitador "Valida el cupo"
                    api -> chat "Solicita una recomendación"
                    api -> descripciones "Solicita una descripción"
                    chat -> cliente "Envía el prompt"
                    descripciones -> cliente "Envía el prompt"
                }
                notification = container "festa-notification-service" "RF12: push, bandeja en la app y recordatorios (fase 2)." "Node.js (tarea en Amazon ECS Fargate)" {
                    api = component "Rutas de notificaciones" "Registra dispositivos, guarda la ubicación con consentimiento, muestra la bandeja y marca lecturas." "REST"
                    notificador = component "Notificador" "Decide a quién enviar cada aviso y evita enviarlo dos veces." "Servicio"
                    push = component "Envío push (FCM)" "Entrega las notificaciones push a los dispositivos Android." "Cliente FCM"
                    recordatorios = component "Recordatorios" "Programa recordatorios de asistencia a eventos confirmados." "Trabajo programado"
                    manejadores = component "Manejadores de eventos (inbox)" "Procesa una sola vez eventos de publicación, asistencia, pagos, comercios y reportes." "Consumidor AMQP"
                    publicador = component "Publicador (outbox)" "Publica el evento push.sent." "Productor AMQP"

                    manejadores -> notificador "Genera avisos"
                    recordatorios -> notificador "Envía recordatorios"
                    notificador -> push "Envía el aviso"
                    push -> notificaciones "Envía a FCM"
                    notificador -> publicador "Registra el envío"
                }
                analytics = container "festa-analytics-service" "RF15: consume eventos y calcula las métricas del panel de comercio." "Node.js (tarea en Amazon ECS Fargate)" {
                    api = component "Rutas de métricas" "Métricas del comercio, de un evento y resumen de administración." "REST"
                    acceso = component "Control de acceso" "Verifica que cada comercio vea solo sus métricas y que el resumen sea de administración." "Middleware"
                    consultas = component "Consultas de métricas" "Calcula conteos de asistentes y boletos vendidos." "Servicio"
                    manejadores = component "Manejadores de eventos (inbox)" "Aplica cada evento una sola vez y solo si su versión es mayor a la guardada." "Consumidor AMQP"

                    api -> acceso "Verifica el rol"
                    api -> consultas "Pide las métricas"
                }

                # festa-infra
                broker = container "RabbitMQ" "Mensajería asíncrona entre microservicios con contratos versionados." "RabbitMQ (contenedor en ECS Fargate)" "Queue"
                auth_db = container "auth_db" "Cuentas y tokens de renovación." "Amazon RDS for PostgreSQL" "Database"
                user_db = container "user_db" "Perfiles, preferencias, comercios, consentimientos y reportes." "Amazon RDS for PostgreSQL" "Database"
                event_db = container "event_db" "Eventos con ubicación geográfica." "Amazon RDS for PostgreSQL + PostGIS" "Database"
                booking_db = container "booking_db" "Asistencias, pases y copia de los eventos." "Amazon RDS for PostgreSQL" "Database"
                payment_db = container "payment_db" "Órdenes, webhooks, liquidaciones y copia de eventos." "Amazon RDS for PostgreSQL" "Database"
                ai_db = container "ai_db" "Conversaciones, descripciones, catálogo y preferencias." "MongoDB (contenedor en ECS Fargate con EFS)" "Database"
                analytics_db = container "analytics_db" "Métricas por evento, comercio, usuario y día." "MongoDB (contenedor en ECS Fargate con EFS)" "Database"
                notification_db = container "notification_db" "Dispositivos, bandeja y recordatorios." "MongoDB (contenedor en ECS Fargate con EFS)" "Database"
                cache = container "Redis" "Una instancia con bases lógicas: caché de perfiles (user) y límite de solicitudes de IA (ai)." "Amazon ElastiCache for Redis" "Database"
                observabilidad = container "Prometheus + Grafana" "Métricas y tableros de los servicios. Corren en Docker Compose; en AWS se usan los logs de CloudWatch." "Prometheus y Grafana"

                # Usuarios hacia la app
                mobile -> gateway "Consume la API" "HTTPS"
                mobile -> mapas "Muestra el mapa" "SDK Mapbox"

                # Gateway hacia servicios
                gateway -> auth "Enruta autenticación" "REST"
                gateway -> user "Enruta peticiones" "REST"
                gateway -> event "Enruta peticiones" "REST"
                gateway -> booking "Enruta peticiones" "REST"
                gateway -> payment "Enruta peticiones" "REST"
                gateway -> ai "Enruta peticiones" "REST"
                gateway -> analytics "Enruta peticiones del panel" "REST"
                gateway -> notification "Enruta peticiones" "REST"

                # Mensajería (según contracts/rabbitmq/definitions.json)
                auth -> broker "Publica y consume eventos" "AMQP"
                user -> broker "Publica y consume eventos" "AMQP"
                event -> broker "Publica y consume eventos" "AMQP"
                booking -> broker "Publica y consume eventos" "AMQP"
                payment -> broker "Publica y consume eventos" "AMQP"
                ai -> broker "Publica y consume eventos" "AMQP"
                notification -> broker "Publica y consume eventos" "AMQP"
                broker -> analytics "Entrega eventos para métricas" "AMQP"
                broker -> booking "Entrega order.approved" "AMQP"

                # Datos: una base por servicio
                auth -> auth_db "Lee y escribe" "SQL"
                user -> user_db "Lee y escribe" "SQL"
                event -> event_db "Lee y escribe (PostGIS)" "SQL"
                booking -> booking_db "Lee y escribe" "SQL"
                payment -> payment_db "Lee y escribe" "SQL"
                ai -> ai_db "Lee y escribe" "Protocolo MongoDB"
                analytics -> analytics_db "Lee y escribe" "Protocolo MongoDB"
                notification -> notification_db "Lee y escribe" "Protocolo MongoDB"
                user -> cache "Cachea perfiles" "TCP"
                ai -> cache "Controla el límite de solicitudes" "TCP"

                # Observabilidad
                observabilidad -> gateway "Recolecta métricas" "HTTP"
            }
        }

        festa.booking.asistencia -> festa.booking_db "Guarda asistencia, cupo y outbox" "SQL"
        festa.booking.pases -> festa.booking_db "Guarda pases y check-in" "SQL"
        festa.broker -> festa.booking.inbox "Entrega eventos" "AMQP"
        festa.booking.outbox -> festa.broker "Publica eventos" "AMQP"
        festa.gateway -> festa.booking.api "Enruta peticiones" "REST"
        festa.payment.ordenes -> festa.payment_db "Lee y escribe órdenes" "SQL"
        pagos -> festa.payment.webhook "Confirmará el pago (versión futura)" "HTTPS"
        festa.broker -> festa.payment.inbox "Entrega eventos" "AMQP"
        festa.payment.outbox -> festa.broker "Publica eventos de pago" "AMQP"
        festa.gateway -> festa.payment.api "Enruta peticiones" "REST"
        festa.ai.cliente -> ia "Solicita generación" "HTTPS"
        festa.ai.limitador -> festa.cache "Cuenta solicitudes" "TCP"
        festa.ai.chat -> festa.ai_db "Guarda la conversación" "Protocolo MongoDB"
        festa.ai.descripciones -> festa.ai_db "Guarda la descripción" "Protocolo MongoDB"
        festa.broker -> festa.ai.inbox "Entrega eventos" "AMQP"
        festa.ai.outbox -> festa.broker "Publica uso de IA" "AMQP"
        festa.gateway -> festa.ai.api "Enruta peticiones" "REST"

        persona -> festa.mobile "Descubre eventos, confirma asistencia y muestra su QR"
        persona -> pagos "Pagará en el checkout (versión futura)" "HTTPS"
        comercio -> festa.mobile "Crea eventos, valida QR y consulta su panel"
        administrador -> festa "Verifica comercios y modera reportes"
        equipoPlataforma -> festa.observabilidad "Monitorea la plataforma"
        equipoPlataforma -> festa "Despliega y configura la plataforma"

        festa.ai -> ia "Solicita descripciones y recomendaciones" "HTTPS"
        festa.notification -> notificaciones "Envía notificaciones push" "HTTPS"
        festa.auth -> identidad "Valida el id_token de Google" "OAuth2"
    }

    views {
        systemContext festa "ContextoFesta" "C4 nivel 1: Festa frente a sus actores y sistemas externos del MVP." {
            include *
            # Fuera del MVP (decisión del equipo, 25-nov-2026): el inicio con Google y las notificaciones push.
            # Siguen en el modelo porque auth-service y notification-service ya los integran (vistas de componentes).
            exclude identidad notificaciones
            autolayout lr
        }

        container festa "ContenedoresFesta" "C4 nivel 2: aplicación móvil, gateway, microservicios y componentes de festa-infra." {
            include *
            autolayout lr
        }

        component festa.booking "ComponentesBooking" "C4 nivel 3: festa-booking-service (asistencia y QR de un solo uso)." {
            include *
            autolayout lr
        }

        component festa.payment "ComponentesPayment" "C4 nivel 3: festa-payment-service (órdenes y checkout de Wompi)." {
            include *
            autolayout lr
        }

        component festa.ai "ComponentesAI" "C4 nivel 3: festa-ai-service (recomendaciones y descripciones con límite de uso)." {
            include *
            autolayout lr
        }

        component festa.auth "ComponentesAuth" "C4 nivel 3: festa-auth-service (registro, inicio de sesión y emisión del JWT)." {
            include *
            autolayout lr
        }

        component festa.user "ComponentesUser" "C4 nivel 3: festa-user-service (perfiles, comercios, consentimientos y moderación)." {
            include *
            autolayout lr
        }

        component festa.event "ComponentesEvent" "C4 nivel 3: festa-event-service (eventos, mapa y Parches en Vivo)." {
            include *
            autolayout lr
        }

        component festa.analytics "ComponentesAnalytics" "C4 nivel 3: festa-analytics-service (métricas del panel de comercio)." {
            include *
            autolayout lr
        }

        component festa.notification "ComponentesNotification" "C4 nivel 3: festa-notification-service (push, bandeja y recordatorios)." {
            include *
            autolayout lr
        }

        dynamic festa "CompraBoleto" "Compra de un boleto y emisión del pase con QR (RF11 y RF10)." {
            persona -> festa.mobile "Elige la cantidad y pulsa Comprar"
            festa.mobile -> festa.gateway "POST /api/payments/orders con Idempotency-Key y JWT"
            festa.gateway -> festa.payment "Enruta la compra"
            festa.payment -> festa.payment_db "Crea la orden PENDING y retiene el cupo"
            festa.payment -> festa.gateway "Devuelve la orden y el checkout firmado"
            festa.gateway -> festa.mobile "Entrega el checkout"
            persona -> pagos "Paga en el checkout de Wompi"
            pagos -> festa.payment "Confirma el pago por webhook firmado"
            festa.payment -> festa.broker "Publica order.approved"
            festa.broker -> festa.booking "Entrega order.approved"
            festa.booking -> festa.booking_db "Crea la asistencia y un pase por boleta"
            festa.mobile -> festa.gateway "GET /api/bookings/passes/mine"
            festa.gateway -> festa.booking "Enruta la consulta"
            festa.booking -> festa.gateway "Devuelve los pases con QR"
            festa.gateway -> festa.mobile "Muestra Mis entradas"
            autolayout lr
        }

        styles {
            element "Element" {
                shape roundedbox
                strokeWidth 2
            }
            element "Person" {
                shape person
                background #C97B5D
                stroke #7A3E2A
                color #FBF1DE
            }
            element "Software System" {
                background #6B7B58
                stroke #3F4A32
                color #FBF1DE
            }
            element "External" {
                background #D4A017
                stroke #8A6410
                color #3B2A0E
            }
            element "Container" {
                background #4C7A7A
                stroke #2C4A4A
                color #FBF1DE
            }
            element "Mobile" {
                shape mobiledeviceportrait
            }
            element "Database" {
                shape cylinder
                background #5B6F8A
                stroke #34445A
            }
            element "Queue" {
                shape pipe
                background #7A3B2E
                stroke #4A1F18
                color #FBF1DE
            }
            element "Component" {
                background #7FA3A3
                stroke #2C4A4A
                color #1F2F2F
            }
            relationship "Relationship" {
                thickness 2
                color #6B4F3B
            }
        }
    }
}
