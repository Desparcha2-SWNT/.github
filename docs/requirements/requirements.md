# 📄 Requerimientos del Sistema

Fuente: `Requerimientos.docx` (especificación completa, con priorización MoSCoW). Plantilla base: [`dosw-lab4-example/requirement-template.md`](https://github.com/lauherrerac/dosw-lab4-example/blob/main/docs/requirements/requirement-template.md).

## 1. Lista general de requerimientos

El sistema de Festa tiene los siguientes requerimientos (descripción a alto nivel):

### 1.1 Requerimientos funcionales

El sistema de Festa debe tener la capacidad de:

1. Registrar e iniciar sesión (correo o Google) — usuarios y comercios. *(RF1 — Must)*
2. Gestionar un perfil de usuario con intereses y preferencias de plan. *(RF2 — Must)*
3. Gestionar un perfil de comercio/organizador, con verificación manual del equipo Festa. *(RF3 — Must)*
4. Crear, editar y cancelar eventos (fecha, lugar, categoría, cupo, descripción). *(RF4 — Must)*
5. Mostrar un mapa interactivo en tiempo real con eventos activos y próximos, agrupados en clústeres por zona. *(RF5 — Must)*
6. Buscar y filtrar eventos por categoría, zona y fecha. *(RF6 — Should, alcance reducido)*
7. Confirmar asistencia a un evento, con conteo de asistentes. *(RF7 — Should, alcance reducido)*
8. Generar recomendaciones personalizadas de eventos en lenguaje natural mediante IA Generativa conversacional. *(RF8 — Must, requisito del profesor)*
9. Generar automáticamente, a partir de datos básicos del comercio, una descripción atractiva del evento redactada por IA Generativa. *(RF9 — Must, requisito del profesor)*
10. Validar asistencia mediante código QR generado por evento, de un solo uso. *(RF10 — Must, indicación del profesor)*
11. Vender boletería dentro de la app, reteniendo una comisión por cada entrada vendida. *(RF11 — Must, indicación del profesor)*
12. Enviar notificaciones push por eventos cercanos y recordatorios de asistencia. *(RF12 — Should)*
13. Compartir eventos mediante enlaces hacia redes sociales externas. *(RF13 — Could)*
14. Reportar eventos o usuarios, con revisión manual del equipo. *(RF14 — Should)*
15. Mostrar un panel de comercio simple para medir retorno (conteos de asistentes y boletos vendidos). *(RF15 — Should)*
16. Otorgar XP por asistir, crear y promocionar eventos, según reglas configurables. *(RF16 — Won't / roadmap futuro)*
17. Permitir canje de puntos por descuentos en comercios aliados, con generación y redención de cupones. *(RF17 — Won't / roadmap futuro)*
18. Mantener un sistema de reputación para creadores de eventos (ranking, insignias, mayor visibilidad). *(RF18 — Won't / roadmap futuro)*
19. Habilitar "Parches en Vivo": eventos improvisados que se activan en menos de 2 horas y expiran automáticamente. *(RF19 — Could)*

### 1.2 Requerimientos no funcionales

El sistema de Festa debe tener:

1. Rendimiento: el mapa debe cargar los eventos visibles en menos de 2 segundos. *(RNF1)*
2. Escalabilidad: arquitectura desplegable en la nube, dimensionada para el piloto en ECI. *(RNF2)*
3. Disponibilidad razonable para un piloto académico, sin SLA formal en esta etapa. *(RNF3)*
4. Seguridad: autenticación con tokens (JWT/OAuth2), cifrado en tránsito (HTTPS) y en reposo para datos personales. *(RNF4)*
5. Privacidad: uso de ubicación solo con consentimiento explícito; cumplimiento de la Ley 1581 de 2012. *(RNF5)*
6. Integración con una pasarela de pagos existente (Wompi/PayU/Mercado Pago) para la venta de boletería. *(RNF6)*
7. Anti-fraude: el código QR de validación debe ser único por boleto/asistente y de un solo uso. *(RNF7)*
8. Costo de IA controlado: descripciones (RF9) se generan una sola vez y se persisten; recomendaciones (RF8) usan un modelo de costo reducido con límite de 5–20 solicitudes por usuario por minuto. *(RNF8)*
9. Eficiencia de recursos: funcionamiento fluido en dispositivos de gama media/baja, con consumo moderado de datos y batería. *(RNF9)*
10. Compatibilidad y adaptabilidad: soporte iOS y Android desde una sola base de código (Flutter), interfaz responsive. *(RNF10)*
11. Usabilidad: interfaz intuitiva sin instrucciones previas, con prevención de errores comunes mediante validaciones claras. *(RNF11)*
12. Mantenibilidad: arquitectura modular y documentada, con pruebas automatizadas mínimas en los flujos críticos (QR y pagos). *(RNF12)*

## 2. Diagramas de caso de uso

### 2.1 Requerimiento Funcional 1

| Campo | Descripción |
|------|-------------|
| **ID** | RF-01 |
| **Nombre del requerimiento** | Registro e inicio de sesión |
| **Descripción** | El sistema debe permitir a un usuario o comercio registrarse e iniciar sesión mediante correo electrónico y contraseña, o mediante autenticación con Google (OAuth2). |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente el servicio de autenticación (Auth Service) desplegado y disponible. |
| **Actor** | Usuario, Comercio/Organizador |
| **Flujo principal** | 1. El actor abre la app y selecciona "Registrarse" o "Iniciar sesión".<br>2. El actor elige el método: correo/contraseña o Google.<br>3. El sistema valida las credenciales (o el token de Google).<br>4. El sistema genera un token JWT de sesión.<br>5. El sistema redirige al actor a su pantalla principal. |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario/Comercio → "Registrarse / Iniciar sesión" → Sistema* |
| **Poscondiciones** | Se espera como resultado que el actor quede autenticado con una sesión válida (JWT) y pueda acceder a las funcionalidades según su rol. |

### 2.2 Requerimiento Funcional 2

| Campo | Descripción |
|------|-------------|
| **ID** | RF-02 |
| **Nombre del requerimiento** | Perfil de usuario |
| **Descripción** | El sistema debe permitir al usuario configurar y editar un perfil con sus intereses y preferencias de plan (cultural, musical, deportivo, gastronómico). |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al usuario registrado e identificado (RF-01). |
| **Actor** | Usuario |
| **Flujo principal** | 1. El actor accede a "Mi perfil".<br>2. El sistema muestra las categorías de interés disponibles.<br>3. El actor selecciona una o varias categorías.<br>4. El sistema persiste las preferencias asociadas al usuario. |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario → "Editar perfil/intereses" → Sistema* |
| **Poscondiciones** | Se espera como resultado que el perfil quede actualizado con los intereses del usuario, disponibles para el motor de recomendaciones de IA (RF-08). |

### 2.3 Requerimiento Funcional 3

| Campo | Descripción |
|------|-------------|
| **ID** | RF-03 |
| **Nombre del requerimiento** | Perfil de comercio/organizador |
| **Descripción** | El sistema debe permitir a un comercio u organizador crear un perfil con datos del negocio, ubicación y categoría, sujeto a verificación manual del equipo Festa (piloto en ECI). |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al comercio registrado e identificado (RF-01). |
| **Actor** | Comercio/Organizador, Equipo Festa (revisor manual) |
| **Flujo principal** | 1. El actor accede a "Crear perfil de comercio".<br>2. El actor ingresa nombre, ubicación, categoría y descripción del negocio.<br>3. El sistema guarda el perfil con estado "pendiente de verificación".<br>4. El equipo Festa revisa manualmente la solicitud.<br>5. El sistema notifica al actor el resultado (aprobado/rechazado). |
| **Diagrama de caso de uso** | *pendiente — boceto Comercio → "Crear perfil" → Sistema → Equipo Festa "Verificar"* |
| **Poscondiciones** | Se espera como resultado que el comercio quede con un perfil verificado (o pendiente/rechazado) que determina si puede publicar eventos (RF-04). |

### 2.4 Requerimiento Funcional 4

| Campo | Descripción |
|------|-------------|
| **ID** | RF-04 |
| **Nombre del requerimiento** | Gestión de eventos (crear, editar, cancelar) |
| **Descripción** | El sistema debe permitir a usuarios y comercios crear, editar y cancelar eventos, especificando fecha, lugar, categoría, cupo y descripción. |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al actor identificado y, si es comercio, con perfil verificado (RF-03). |
| **Actor** | Usuario, Comercio/Organizador |
| **Flujo principal** | 1. El actor selecciona "Crear evento".<br>2. El actor ingresa título, fecha/hora, lugar, categoría, cupo y descripción (opcionalmente generada por IA, RF-09).<br>3. El sistema valida los datos obligatorios.<br>4. El sistema guarda el evento y lo publica en el mapa (RF-05). |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario/Comercio → "Crear/Editar/Cancelar evento" → Sistema* |
| **Poscondiciones** | Se espera como resultado que el evento quede creado, actualizado o cancelado, y visible (o no) en el mapa según corresponda. |

### 2.5 Requerimiento Funcional 5

| Campo | Descripción |
|------|-------------|
| **ID** | RF-05 |
| **Nombre del requerimiento** | Mapa interactivo en tiempo real |
| **Descripción** | El sistema debe mostrar en un mapa interactivo los eventos activos y próximos, agrupados en clústeres por zona, cargando lo visible en menos de 2 segundos (RNF1). |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al usuario identificado y haber solicitado (u omitido) el consentimiento de ubicación (RNF5). |
| **Actor** | Usuario |
| **Flujo principal** | 1. El actor abre la pantalla principal (mapa).<br>2. El sistema obtiene la ubicación del actor (o usa la ubicación por defecto del piloto ECI).<br>3. El sistema consulta los eventos activos/próximos cercanos.<br>4. El sistema agrupa eventos cercanos en clústeres y los renderiza.<br>5. El actor puede hacer zoom/pan; el sistema recalcula clústeres. |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario → "Ver mapa de eventos" → Sistema* |
| **Poscondiciones** | Se espera como resultado que el actor visualice los eventos activos y próximos cercanos, organizados por clústeres, en menos de 2 segundos. |

### 2.6 Requerimiento Funcional 6

| Campo | Descripción |
|------|-------------|
| **ID** | RF-06 |
| **Nombre del requerimiento** | Búsqueda y filtrado de eventos |
| **Descripción** | El sistema debe permitir al usuario buscar y filtrar eventos por categoría, zona y fecha (alcance MVP reducido, sin ordenamiento por popularidad). |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al actor en la pantalla del mapa o listado de eventos (RF-05). |
| **Actor** | Usuario |
| **Flujo principal** | 1. El actor abre el panel de filtros/búsqueda.<br>2. El actor ingresa texto libre y/o selecciona categoría, zona, rango de fechas.<br>3. El sistema consulta los eventos que cumplen los criterios.<br>4. El sistema actualiza el mapa/listado con los resultados filtrados. |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario → "Buscar/Filtrar eventos" → Sistema* |
| **Poscondiciones** | Se espera como resultado que el actor visualice únicamente los eventos que cumplen los criterios seleccionados. |

### 2.7 Requerimiento Funcional 7

| Campo | Descripción |
|------|-------------|
| **ID** | RF-07 |
| **Nombre del requerimiento** | Confirmación de asistencia |
| **Descripción** | El sistema debe permitir a un usuario confirmar su asistencia a un evento y mostrar un conteo de asistentes confirmados (alcance MVP reducido, sin actualización en vivo por WebSockets). |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al actor identificado y visualizando el detalle de un evento (RF-05). |
| **Actor** | Usuario |
| **Flujo principal** | 1. El actor abre el detalle de un evento.<br>2. El actor selecciona "Confirmar asistencia".<br>3. El sistema registra la confirmación asociada al actor y al evento.<br>4. El sistema actualiza el conteo de asistentes visible. |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario → "Confirmar asistencia" → Sistema* |
| **Poscondiciones** | Se espera como resultado que el actor quede registrado como asistente confirmado y el conteo público se actualice. |

### 2.8 Requerimiento Funcional 8

| Campo | Descripción |
|------|-------------|
| **ID** | RF-08 |
| **Nombre del requerimiento** | Recomendaciones personalizadas por IA Generativa |
| **Descripción** | El sistema debe generar recomendaciones de eventos en lenguaje natural, conversando con el usuario sobre sus intereses del momento, en vez de mostrar solo una lista filtrada. Requisito explícito del profesor. |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al actor identificado, idealmente con intereses configurados (RF-02). |
| **Actor** | Usuario |
| **Flujo principal** | 1. El actor escribe qué tipo de plan busca.<br>2. El sistema envía el mensaje, los intereses del actor y los eventos disponibles al modelo de IA Generativa.<br>3. El modelo genera una respuesta conversacional recomendando eventos específicos.<br>4. El sistema muestra la respuesta con enlaces directos a los eventos recomendados.<br>5. El actor puede seguir conversando para refinar la recomendación. |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario → "Pedir recomendación" → AI Service → Event Service* |
| **Poscondiciones** | Se espera como resultado que el actor reciba una recomendación personalizada en lenguaje natural, con eventos concretos que puede explorar o confirmar. |

### 2.9 Requerimiento Funcional 9

| Campo | Descripción |
|------|-------------|
| **ID** | RF-09 |
| **Nombre del requerimiento** | Descripción de evento generada por IA |
| **Descripción** | El sistema debe generar automáticamente, a partir de datos básicos ingresados por el comercio, una descripción atractiva del evento redactada por IA Generativa. Requisito explícito del profesor. |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al comercio creando un evento con los datos básicos ya ingresados (RF-04). |
| **Actor** | Comercio/Organizador |
| **Flujo principal** | 1. El actor ingresa nombre, ubicación y tipo de actividad del evento.<br>2. El actor selecciona "Generar descripción con IA".<br>3. El sistema envía los datos básicos al modelo de IA Generativa.<br>4. El modelo genera una descripción atractiva.<br>5. El sistema muestra la descripción para revisión del actor.<br>6. El actor acepta o edita la descripción.<br>7. El sistema persiste la descripción final (no se regenera en visualizaciones futuras). |
| **Diagrama de caso de uso** | *pendiente — boceto Comercio → "Generar descripción" → AI Service → Event Service* |
| **Poscondiciones** | Se espera como resultado que el evento quede con una descripción atractiva generada (o editada) por IA, lista para publicarse. |

### 2.10 Requerimiento Funcional 10

| Campo | Descripción |
|------|-------------|
| **ID** | RF-10 |
| **Nombre del requerimiento** | Validación de asistencia por QR |
| **Descripción** | El sistema debe generar un código QR único por boleto/asistente (de un solo uso, RNF7), escaneado al ingreso del evento para validar la asistencia. Indicación explícita del profesor. |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al actor con una confirmación de asistencia o boleto para el evento (RF-07 o RF-11). |
| **Actor** | Usuario (presenta el QR), Comercio/Organizador (escanea el QR) |
| **Flujo principal** | 1. El sistema genera un código QR único al confirmar la asistencia o compra del actor.<br>2. El actor presenta el QR al ingreso del evento.<br>3. El comercio escanea el QR con la app.<br>4. El sistema valida que el QR sea auténtico, corresponda al evento y no haya sido usado antes.<br>5. El sistema marca el QR como usado y registra el check-in. |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario → "Mostrar QR" / Comercio → "Escanear QR" → Sistema* |
| **Poscondiciones** | Se espera como resultado que el check-in quede registrado de forma única e irrepetible, visible en tiempo real para el organizador. |

### 2.11 Requerimiento Funcional 11

| Campo | Descripción |
|------|-------------|
| **ID** | RF-11 |
| **Nombre del requerimiento** | Venta de boletería con comisión |
| **Descripción** | El sistema debe permitir vender boletería dentro de la app para eventos que lo requieran, reteniendo una comisión por cada entrada vendida (split payment vía Wompi). Indicación explícita del profesor. |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al actor identificado y un evento de pago con cupo disponible. |
| **Actor** | Usuario (comprador) |
| **Flujo principal** | 1. El actor abre el detalle de un evento de pago y selecciona "Comprar entrada".<br>2. El sistema inicia el pago con Wompi, indicando el split entre organizador y comisión Festa.<br>3. El actor completa el pago.<br>4. Wompi confirma el pago al sistema.<br>5. El sistema distribuye el pago automáticamente.<br>6. El sistema genera el boleto con su QR (RF-10) y descuenta el cupo. |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario → "Comprar entrada" → Payment Service → Wompi* |
| **Poscondiciones** | Se espera como resultado que el actor quede con un boleto válido (con QR) y el pago distribuido entre el organizador y Festa según la comisión acordada. |

### 2.12 Requerimiento Funcional 12

| Campo | Descripción |
|------|-------------|
| **ID** | RF-12 |
| **Nombre del requerimiento** | Notificaciones push |
| **Descripción** | El sistema debe enviar notificaciones push al usuario sobre eventos cercanos relevantes y recordatorios de asistencia a eventos confirmados. |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al actor identificado y con permiso de notificaciones otorgado en el dispositivo. |
| **Actor** | Usuario |
| **Flujo principal** | 1. Ocurre un evento relevante en el sistema (evento nuevo cercano, o recordatorio de un evento confirmado).<br>2. El sistema encola la notificación correspondiente.<br>3. El sistema envía el push al dispositivo del actor vía Firebase Cloud Messaging.<br>4. El actor recibe la notificación y puede tocarla para ir al detalle del evento. |
| **Diagrama de caso de uso** | *pendiente — boceto Sistema → "Enviar notificación" → Usuario (vía FCM)* |
| **Poscondiciones** | Se espera como resultado que el actor reciba oportunamente notificaciones sobre eventos relevantes cercanos y recordatorios de eventos confirmados. |

### 2.13 Requerimiento Funcional 13

| Campo | Descripción |
|------|-------------|
| **ID** | RF-13 |
| **Nombre del requerimiento** | Compartir eventos en redes sociales |
| **Descripción** | El sistema debe permitir compartir eventos mediante enlaces hacia redes sociales externas, usando el mecanismo nativo de compartir del sistema operativo. |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente el evento publicado y visible (RF-04). |
| **Actor** | Usuario |
| **Flujo principal** | 1. El actor abre el detalle de un evento.<br>2. El actor selecciona "Compartir".<br>3. El sistema invoca el mecanismo nativo de compartir del sistema operativo con un enlace al evento.<br>4. El actor elige el destino (red social, chat, etc.) y envía. |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario → "Compartir evento" → Sistema* |
| **Poscondiciones** | Se espera como resultado que se genere y envíe un enlace público al evento hacia el destino elegido por el actor. |

### 2.14 Requerimiento Funcional 14

| Campo | Descripción |
|------|-------------|
| **ID** | RF-14 |
| **Nombre del requerimiento** | Reporte de eventos o usuarios |
| **Descripción** | El sistema debe permitir reportar eventos o usuarios; para el piloto en ECI, la moderación es una revisión manual del equipo (no automatizada). |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al actor identificado y visualizando el evento o usuario a reportar. |
| **Actor** | Usuario, Equipo Festa (revisor manual) |
| **Flujo principal** | 1. El actor selecciona "Reportar" sobre un evento o usuario.<br>2. El actor indica el motivo del reporte.<br>3. El sistema registra el reporte y lo pone en cola de revisión.<br>4. El equipo Festa revisa manualmente el reporte y toma una acción (advertencia, retiro del contenido, ninguna acción). |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario → "Reportar" → Sistema → Equipo Festa* |
| **Poscondiciones** | Se espera como resultado que el reporte quede registrado y, si aplica, se tome una acción de moderación sobre el evento o usuario reportado. |

### 2.15 Requerimiento Funcional 15

| Campo | Descripción |
|------|-------------|
| **ID** | RF-15 |
| **Nombre del requerimiento** | Panel de comercio |
| **Descripción** | El sistema debe mostrar al comercio un panel simple para medir retorno (conteos de asistentes y boletos vendidos), sin ser un dashboard completo con gráficas en el MVP. |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al comercio identificado y con al menos un evento publicado. |
| **Actor** | Comercio/Organizador |
| **Flujo principal** | 1. El actor accede a "Mi panel".<br>2. El sistema consulta los eventos del comercio y sus métricas (asistentes confirmados, boletos vendidos).<br>3. El sistema muestra los conteos por evento. |
| **Diagrama de caso de uso** | *pendiente — boceto Comercio → "Ver panel de retorno" → Sistema* |
| **Poscondiciones** | Se espera como resultado que el comercio pueda ver el retorno (asistencia y ventas) atribuible a sus eventos publicados. |

### 2.16 Requerimiento Funcional 16

| Campo | Descripción |
|------|-------------|
| **ID** | RF-16 |
| **Nombre del requerimiento** | Otorgamiento de XP (roadmap futuro) |
| **Descripción** | El sistema debe otorgar XP por asistir, crear y promocionar eventos, según reglas configurables. *Fuera del alcance del MVP de este semestre (Won't).* |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente definido un sistema de reglas de puntuación configurable. |
| **Actor** | Usuario |
| **Flujo principal** | 1. El actor realiza una acción elegible (asistir, crear o promocionar un evento).<br>2. El sistema evalúa la acción contra las reglas configurables.<br>3. El sistema otorga la XP correspondiente al actor. |
| **Diagrama de caso de uso** | *pendiente — fuera de alcance MVP* |
| **Poscondiciones** | Se espera como resultado que el actor acumule XP visible en su perfil, según las reglas vigentes. |

### 2.17 Requerimiento Funcional 17

| Campo | Descripción |
|------|-------------|
| **ID** | RF-17 |
| **Nombre del requerimiento** | Canje de puntos por descuentos (roadmap futuro) |
| **Descripción** | El sistema debe permitir el canje de puntos por descuentos en comercios aliados, con generación y redención de cupones. *Fuera del alcance del MVP de este semestre (Won't).* |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al actor con puntos acumulados (RF-16) y comercios aliados configurados. |
| **Actor** | Usuario, Comercio aliado |
| **Flujo principal** | 1. El actor selecciona un descuento disponible para canjear.<br>2. El sistema valida que el actor tenga puntos suficientes.<br>3. El sistema genera un cupón y descuenta los puntos.<br>4. El actor redime el cupón en el comercio aliado. |
| **Diagrama de caso de uso** | *pendiente — fuera de alcance MVP* |
| **Poscondiciones** | Se espera como resultado que el actor obtenga un cupón válido y sus puntos se descuenten en consecuencia. |

### 2.18 Requerimiento Funcional 18

| Campo | Descripción |
|------|-------------|
| **ID** | RF-18 |
| **Nombre del requerimiento** | Sistema de reputación (roadmap futuro) |
| **Descripción** | El sistema debe mantener un sistema de reputación para creadores de eventos: ranking, insignias y mayor visibilidad en el mapa. *Fuera del alcance del MVP de este semestre (Won't).* |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente un historial de eventos creados y su desempeño (asistencia, calificaciones). |
| **Actor** | Comercio/Organizador |
| **Flujo principal** | 1. El sistema calcula la reputación del actor a partir de su historial de eventos.<br>2. El sistema asigna insignias y posición en el ranking según reglas definidas.<br>3. El sistema aumenta la visibilidad en el mapa de los actores con mejor reputación. |
| **Diagrama de caso de uso** | *pendiente — fuera de alcance MVP* |
| **Poscondiciones** | Se espera como resultado que los organizadores con mejor desempeño obtengan mayor visibilidad e insignias visibles en su perfil. |

### 2.19 Requerimiento Funcional 19

| Campo | Descripción |
|------|-------------|
| **ID** | RF-19 |
| **Nombre del requerimiento** | Parches en Vivo |
| **Descripción** | El sistema debe permitir crear eventos improvisados ("Parches en Vivo") que se activan en menos de 2 horas y expiran automáticamente. |
| **Precondiciones** | Para que el sistema cumpla con este requerimiento, Festa debe tener previamente al actor identificado. |
| **Actor** | Usuario, Comercio/Organizador |
| **Flujo principal** | 1. El actor crea un "Parche en Vivo" indicando lugar, hora de inicio (dentro de las próximas 2 horas) y descripción breve.<br>2. El sistema publica el evento inmediatamente en el mapa, marcado como "en vivo".<br>3. El sistema expira automáticamente el evento al cumplirse su ventana de tiempo. |
| **Diagrama de caso de uso** | *pendiente — boceto Usuario/Comercio → "Crear parche en vivo" → Sistema* |
| **Poscondiciones** | Se espera como resultado que el parche quede visible en el mapa mientras esté vigente, y desaparezca automáticamente al expirar. |

## 3. Preguntas

- ¿El piloto en ECI requiere registro en el RNBD (Registro Nacional de Bases de Datos) ante la SIC antes del lanzamiento, o solo si se supera cierto volumen de usuarios? *(ver RN6)*
- ¿Wompi permite configurar el split payment (RF-11) directamente desde el ambiente de pruebas/sandbox para la sustentación, o requiere cuenta comercial verificada?
- ¿Cuál es el límite exacto de solicitudes de IA por usuario/minuto que se va a implementar en el MVP (RNF8 menciona un rango de 5–20)?
