workspace "Festa" "Aplicación de descubrimiento de eventos y visibilidad para comercios locales, construida por Soluciones Tecnológicas de Ingeniería" {

    !identifiers hierarchical

    # Fuente: repositorios Desparcha2-SWNT/festa-* (24-oct-2026) y decisión de despliegue en Azure (25-oct-2026).
    # Lo marcado como "propuesto" depende de los ADR 0001 (plataforma) y 0002 (almacén por servicio).

    model {
        persona = person "Persona interesada en eventos" "Descubre eventos y planes en un mapa en tiempo real, recibe recomendaciones y confirma su asistencia."
        comercio = person "Comercio / organizador" "Crea y gestiona eventos, vende boletería y mide el retorno desde su panel."

        pagos = softwareSystem "Wompi (pasarela de pagos)" "Servicio externo que procesa el cobro de boletos y reparte la comisión (8 % Festa, 92 % organizador)." "External"
        ia = softwareSystem "Azure OpenAI" "Servicio gestionado de IA generativa para descripciones de eventos y recomendaciones (proveedor propuesto)." "External"
        notificaciones = softwareSystem "FCM / APNs" "Servicios de Google y Apple que entregan notificaciones push al dispositivo." "External"
        identidad = softwareSystem "Google Identity" "Proveedor externo de autenticación federada (OAuth2) para iniciar sesión." "External"
        mapas = softwareSystem "Mapbox" "Servicio externo de mapas que usa la app para mostrar eventos y clústeres." "External"

        group "Soluciones Tecnológicas de Ingeniería" {
            administrador = person "Administrador de la plataforma" "Verifica comercios y modera eventos publicados; soporte interno del producto."
            equipoPlataforma = person "Equipo de plataforma (DevOps)" "Perfil técnico interno: despliega, configura y monitorea la infraestructura de Festa."

            festa = softwareSystem "Festa" "Aplicación que centraliza el descubrimiento de eventos en un mapa en tiempo real, con recomendaciones por IA y venta de boletería." {
                mobile = container "festa-mobile" "App del usuario y vista de comercio (panel simple, RF15): mapa, escáner y generador de QR, caché local del QR." "Flutter (iOS y Android)" "Mobile"
                gateway = container "festa-gateway" "Punto de entrada único: enruta peticiones, valida el JWT y aplica rate limiting (RNF8)." "Kong 3.9 DB-less (pod en AKS)"
                auth = container "festa-auth-service" "RF1: registro e inicio de sesión con correo y Google; emite el JWT." "Spring Boot 3.5 (pod en AKS)"
                user = container "festa-user-service" "RF2 y RF3: perfiles de usuario y comercio, preferencias, verificación manual de comercios." "Pod en Azure Kubernetes Service (AKS)"
                event = container "festa-event-service" "RF4, RF5, RF6 y RF19: CRUD de eventos, mapa con clústeres, búsqueda y filtros, Parches en Vivo." "Pod en Azure Kubernetes Service (AKS)"
                booking = container "festa-booking-service" "RF7 y RF10: confirmación de asistencia y QR único de un solo uso." "Pod en Azure Kubernetes Service (AKS)" {
                    api = component "API de asistencia y QR" "Endpoints REST: confirmar asistencia, obtener el QR y validarlo en la puerta." "REST"
                    asistencia = component "Gestor de asistencia" "Confirma la asistencia (RF7) y registra el ingreso al evento." "Servicio"
                    generador = component "Generador de QR" "Crea el token firmado de un solo uso para cada boleto (RF10)." "Servicio"
                    validador = component "Validador de QR" "Verifica firma y vigencia y marca el QR como usado; rechaza repetidos (RNF7)." "Servicio"
                    consumidor = component "Consumidor de pagos" "Escucha el pago aprobado y emite el boleto." "Consumidor AMQP"
                    repo = component "Repositorio" "Lee y escribe asistencias y boletos." "Acceso a datos"
                    api -> asistencia "Confirma asistencia"
                    api -> generador "Pide el QR del boleto"
                    api -> validador "Valida el QR escaneado"
                    consumidor -> generador "Emite el boleto"
                    asistencia -> repo "Guarda asistencias"
                    generador -> repo "Guarda el boleto"
                    validador -> repo "Marca el QR como usado"
                }
                payment = container "festa-payment-service" "RF11: boletería con Wompi y split de pago (comisión del 8 %)." "Pod en Azure Kubernetes Service (AKS)" {
                    api = component "API de pagos" "Endpoints REST para iniciar la compra y consultar su estado." "REST"
                    cobro = component "Servicio de cobro" "Orquesta la compra de un boleto (RF11)." "Servicio"
                    split = component "Calculador de split" "Divide el valor: 8 % para Festa y 92 % para el organizador." "Servicio"
                    wompi = component "Cliente Wompi" "Crea el cobro con split en la pasarela." "Cliente HTTP"
                    webhook = component "Receptor de webhooks" "Recibe la confirmación del pago y verifica su firma." "REST"
                    publicador = component "Publicador de eventos" "Publica pago aprobado o rechazado." "Productor AMQP"
                    repo = component "Repositorio" "Lee y escribe pagos y comisiones." "Acceso a datos"
                    api -> cobro "Inicia la compra"
                    cobro -> split "Calcula la comisión"
                    cobro -> wompi "Crea el cobro"
                    cobro -> repo "Guarda el pago"
                    webhook -> cobro "Actualiza el estado"
                    cobro -> publicador "Notifica el resultado"
                }
                ai = container "festa-ai-service" "RF8 y RF9: recomendaciones y descripciones con IA; límite de solicitudes por usuario (RNF8)." "Pod en Azure Kubernetes Service (AKS)" {
                    api = component "API de IA" "Endpoints REST para pedir recomendaciones y descripciones." "REST"
                    limitador = component "Limitador de solicitudes" "Aplica el tope por usuario y por minuto (RNF8)." "Middleware"
                    orquestador = component "Orquestador de prompts" "Arma el prompt con contexto del evento y del usuario (RF8, RF9)." "Servicio"
                    descripciones = component "Persistencia de descripciones" "Guarda las descripciones generadas para no volver a pedirlas (RNF8)." "Acceso a datos"
                    cliente = component "Cliente Azure OpenAI" "Llama al modelo y maneja errores y reintentos." "Cliente HTTP"
                    api -> limitador "Valida el cupo"
                    api -> orquestador "Solicita la generación"
                    orquestador -> descripciones "Reutiliza o guarda descripciones"
                    orquestador -> cliente "Envía el prompt"
                }
                notification = container "festa-notification-service" "RF12: envío de notificaciones push (fase 2)." "Pod en Azure Kubernetes Service (AKS)"
                analytics = container "festa-analytics-service" "RF15: conteos de asistentes y boletos vendidos para el panel de comercio." "Pod en Azure Kubernetes Service (AKS)"

                # festa-infra
                broker = container "RabbitMQ" "Mensajería asíncrona entre microservicios y contratos de mensajes." "RabbitMQ (pod en AKS)" "Queue"
                auth_db = container "auth_db" "Cuentas y sesiones de festa-auth-service (propuesto)." "Azure Database for PostgreSQL Flexible Server (una base de datos por servicio)" "Database"
                user_db = container "user_db" "Perfiles, intereses y comercios de festa-user-service (propuesto)." "Azure Database for PostgreSQL Flexible Server (una base de datos por servicio)" "Database"
                event_db = container "event_db" "Categorías, eventos y descripciones de festa-event-service, con consultas geoespaciales (propuesto)." "Azure Database for PostgreSQL Flexible Server + PostGIS (una base de datos por servicio)" "Database"
                booking_db = container "booking_db" "Asistencias, boletos y códigos QR de festa-booking-service (propuesto)." "Azure Database for PostgreSQL Flexible Server (una base de datos por servicio)" "Database"
                payment_db = container "payment_db" "Pagos y webhooks de festa-payment-service (propuesto)." "Azure Database for PostgreSQL Flexible Server (una base de datos por servicio)" "Database"
                ai_db = container "ai_db" "Recomendaciones de festa-ai-service (propuesto)." "Azure Cosmos DB API para MongoDB" "Database"
                analytics_db = container "analytics_db" "Conteos de asistentes y boletos de festa-analytics-service (propuesto)." "Azure Cosmos DB API para MongoDB" "Database"
                notification_db = container "notification_db" "Registros de envío de festa-notification-service (propuesto)." "Azure Cosmos DB API para MongoDB" "Database"
                cache = container "Redis" "Una instancia con bases lógicas separadas: caché del mapa (festa-event-service) y límite de solicitudes de IA (festa-ai-service). La validación rápida de QR de booking es una propuesta." "Azure Cache for Redis" "Database"
                observabilidad = container "Prometheus + Grafana" "Recolecta métricas de los servicios y las muestra en tableros con alertas." "Prometheus y Grafana"

                # Usuarios hacia la app
                mobile -> gateway "Consume la API" "HTTPS / WSS"
                mobile -> mapas "Muestra el mapa" "SDK Mapbox"

                # Gateway hacia servicios
                gateway -> auth "Valida credenciales y tokens" "REST / JWT"
                gateway -> user "Enruta peticiones" "REST"
                gateway -> event "Enruta peticiones" "REST"
                gateway -> booking "Enruta peticiones" "REST"
                gateway -> payment "Enruta peticiones" "REST"
                gateway -> ai "Enruta peticiones" "REST"
                gateway -> analytics "Enruta peticiones del panel" "REST"

                # Mensajería
                event -> broker "Publica eventos de dominio" "AMQP"
                booking -> broker "Publica confirmaciones y QR" "AMQP"
                payment -> broker "Publica eventos de pago" "AMQP"
                ai -> broker "Consume y publica mensajes" "AMQP"
                broker -> notification "Entrega eventos a notificar" "AMQP"
                broker -> analytics "Entrega eventos para métricas" "AMQP"
                broker -> booking "Entrega pagos aprobados" "AMQP"

                # Datos (propuesto)
                auth -> auth_db "Lee y escribe credenciales y sesiones" "SQL"
                user -> user_db "Lee y escribe perfiles" "SQL"
                event -> event_db "Lee y escribe eventos (PostGIS)" "SQL"
                booking -> booking_db "Lee y escribe asistencias y QR" "SQL"
                payment -> payment_db "Lee y escribe pagos" "SQL"
                booking -> cache "Valida QR de un solo uso (propuesto)" "TCP"
                event -> cache "Cachea consultas del mapa" "TCP"
                ai -> cache "Controla límite de solicitudes" "TCP"
                ai -> ai_db "Guarda recomendaciones" "Protocolo MongoDB"
                analytics -> analytics_db "Guarda conteos" "Protocolo MongoDB"
                notification -> notification_db "Guarda registros de envío" "Protocolo MongoDB"

                # Observabilidad
                observabilidad -> gateway "Recolecta métricas" "HTTP"
            }
        }

        festa.booking.repo -> festa.booking_db "Lee y escribe" "SQL"
        festa.booking.validador -> festa.cache "Comprueba y bloquea el QR" "TCP"
        festa.booking.consumidor -> festa.broker "Consume pagos aprobados" "AMQP"
        festa.gateway -> festa.booking.api "Enruta peticiones" "REST"
        festa.payment.repo -> festa.payment_db "Lee y escribe" "SQL"
        festa.payment.wompi -> pagos "Crea el cobro con split" "HTTPS"
        pagos -> festa.payment.webhook "Confirma el pago" "HTTPS"
        festa.payment.publicador -> festa.broker "Publica eventos de pago" "AMQP"
        festa.gateway -> festa.payment.api "Enruta peticiones" "REST"
        festa.ai.cliente -> ia "Solicita generación" "HTTPS"
        festa.ai.limitador -> festa.cache "Cuenta solicitudes" "TCP"
        festa.gateway -> festa.ai.api "Enruta peticiones" "REST"

        persona -> festa.mobile "Descubre eventos, confirma asistencia y muestra su QR"
        comercio -> festa.mobile "Crea eventos y consulta su panel"
        administrador -> festa "Verifica comercios y modera eventos"
        equipoPlataforma -> festa.observabilidad "Monitorea la plataforma"
        equipoPlataforma -> festa "Despliega y configura la plataforma"

        festa.payment -> pagos "Procesa el cobro y el split" "HTTPS"
        festa.ai -> ia "Solicita descripciones y recomendaciones" "HTTPS"
        festa.notification -> notificaciones "Envía notificaciones push (vía Azure Notification Hubs)" "HTTPS"
        festa.auth -> identidad "Autentica usuarios" "OAuth2"
    }

    views {
        systemContext festa "ContextoFesta" "C4 nivel 1: Festa frente a sus actores y sistemas externos." {
            include *
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

        component festa.payment "ComponentesPayment" "C4 nivel 3: festa-payment-service (cobro y split con Wompi)." {
            include *
            autolayout lr
        }

        component festa.ai "ComponentesAI" "C4 nivel 3: festa-ai-service (recomendaciones y descripciones con límite de uso)." {
            include *
            autolayout lr
        }

        dynamic festa "CompraBoleto" "Compra de un boleto y generación del QR (RF11 y RF10)." {
            persona -> festa.mobile "Elige un evento de pago y pulsa Comprar"
            festa.mobile -> festa.gateway "POST /tickets/checkout con el JWT"
            festa.gateway -> festa.payment "Enruta la compra"
            festa.payment -> pagos "Crea el cobro con split (8 % / 92 %)"
            pagos -> festa.payment "Confirma el pago aprobado"
            festa.payment -> festa.broker "Publica pago aprobado"
            festa.broker -> festa.booking "Entrega pago aprobado"
            festa.mobile -> festa.gateway "Consulta su boleto (GET /tickets/{id}/qr)"
            festa.gateway -> festa.booking "Enruta la consulta"
            festa.booking -> festa.gateway "Devuelve el QR único generado"
            festa.gateway -> festa.mobile "Entrega el QR (la app lo guarda en caché local)"
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
