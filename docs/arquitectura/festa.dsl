workspace "Festa" "Aplicación de descubrimiento de eventos y visibilidad para comercios locales, construida por Soluciones Tecnológicas de Ingeniería" {

    !identifiers hierarchical

    model {
        persona = person "Persona interesada en eventos" "Descubre eventos y planes en un mapa en tiempo real, recibe recomendaciones y confirma su asistencia."
        comercio = person "Comercio / organizador" "Crea y gestiona eventos, y mide el retorno obtenido desde su panel."

        pagos = softwareSystem "Pasarela de pagos" "Servicio externo que procesa el cobro de boletos y distribuye la comisión entre las partes." "External"
        recomendacionesIA = softwareSystem "Servicio de recomendaciones por IA" "Servicio externo que genera descripciones de eventos y recomendaciones personalizadas." "External"
        notificaciones = softwareSystem "Servicio de notificaciones" "Servicio externo que entrega notificaciones push al dispositivo del usuario." "External"
        identidad = softwareSystem "Proveedor de identidad" "Servicio externo de autenticación federada para iniciar sesión." "External"

        group "Soluciones Tecnológicas de Ingeniería" {
            administrador = person "Administrador de la plataforma" "Verifica comercios y modera eventos publicados; soporte interno del producto."

            festa = softwareSystem "Festa" "Aplicación que centraliza el descubrimiento de eventos en un mapa en tiempo real, con recomendaciones por IA y venta de boletería." {
                gateway = container "API Gateway" "Punto de entrada único; enruta peticiones, valida tokens y aplica rate limiting." "Kong / Apache APISIX"
                auth = container "Auth Service" "Registro, inicio de sesión y emisión/validación de tokens." "Spring Boot (Java)"
                user = container "User Service" "CRUD de perfiles de usuario y comercio, preferencias, verificación manual." "Node.js + Express"
                event = container "Event Service" "CRUD de eventos, 'Parches en Vivo', búsqueda y filtrado, soporte al mapa." "Node.js + Express"
                booking = container "Booking Service" "Confirmación de asistencia y generación/validación del código QR." "Node.js + Express"
                payment = container "Payment Service" "Integración con la pasarela de pagos: venta de boletería y split payment de comisiones." "Node.js + Express"
                ai = container "AI Service" "Genera descripciones de eventos y recomendaciones personalizadas." "Python + FastAPI"
                notification = container "Notification Service" "Envío de notificaciones push." "Node.js"
                analytics = container "Analytics Service" "Alimenta el panel de comercios con asistentes y boletos vendidos." "Node.js / Python"
                admin = container "Admin Panel" "Interfaz interna para que el administrador modere eventos y verifique comercios." "React"
                broker = container "Message Broker" "Comunicación asíncrona confiable entre microservicios." "RabbitMQ" {
                    tags "Queue"
                }

                gateway -> auth "Valida tokens" "JWT"
                gateway -> user "Enruta peticiones" "REST"
                gateway -> event "Enruta peticiones" "REST"
                gateway -> booking "Enruta peticiones" "REST"
                gateway -> payment "Enruta peticiones" "REST"
                gateway -> ai "Enruta peticiones" "REST"
                admin -> gateway "Modera eventos y verifica comercios" "REST"
                event -> broker "Publica eventos de dominio" "AMQP"
                booking -> broker "Publica confirmaciones y QR" "AMQP"
                payment -> broker "Publica eventos de pago" "AMQP"
                ai -> broker "Consume y publica mensajes" "AMQP"
                broker -> notification "Notifica eventos relevantes" "AMQP"
                broker -> analytics "Alimenta métricas" "AMQP"
            }
        }

        persona -> festa "Descubre eventos y confirma su asistencia"
        comercio -> festa "Crea eventos y consulta su panel"
        administrador -> festa.admin "Modera eventos y verifica comercios"
        festa.payment -> pagos "Procesa el pago de boletería"
        festa.ai -> recomendacionesIA "Solicita descripciones y recomendaciones"
        festa.notification -> notificaciones "Envía notificaciones push"
        festa.auth -> identidad "Autentica usuarios"
    }

    views {
        systemContext festa "ContextoFesta" {
            include *
            autolayout lr
        }

        container festa "ContenedoresFesta" {
            include *
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
            element "Queue" {
                shape pipe
                background #7A3B2E
                stroke #4A1F18
                color #FBF1DE
            }
            relationship "Relationship" {
                thickness 2
                color #6B4F3B
            }
        }
    }

    configuration {
        scope softwaresystem
    }
}
