# Política de privacidad y autorización de tratamiento de datos personales — Festa

**Versión:** 1.0 (borrador para revisión del equipo)
**Normativa:** Ley 1581 de 2012 y Decreto 1377 de 2013 (Colombia)
**Historia de Jira:** [SCRUM-129](https://desparcha2.atlassian.net/browse/SCRUM-129)

> Este texto es un borrador del equipo Desparcha2 para el piloto académico. Antes de usarlo fuera del piloto debe revisarlo quien tenga la responsabilidad legal del tratamiento. Los datos que aún no están definidos aparecen entre corchetes.

## 1. Quién trata tus datos

Festa es una aplicación para descubrir eventos en Bogotá, desarrollada por el equipo Desparcha2 como proyecto del curso Innovación Software Apoyada en Nuevas Tecnologías de la Escuela Colombiana de Ingeniería Julio Garavito.

- **Responsable del tratamiento:** equipo Desparcha2 [razón social o representante por definir].
- **Contacto para consultas y reclamos:** `Desparcha2@pruebacorreoescuelaingeduco.onmicrosoft.com`.

## 2. Qué datos recogemos

| Dato | Cuándo | Para qué |
|---|---|---|
| Correo electrónico y nombre | Al registrarte (con correo o con Google) | Crear y identificar tu cuenta |
| Contraseña | Al registrarte con correo | Iniciar sesión. Solo guardamos una huella cifrada, nunca la contraseña |
| Foto e intereses (cultural, musical, deportivo, gastronómico) | Cuando completas tu perfil | Personalizar el perfil y las recomendaciones |
| Datos del comercio (nombre, ubicación, categoría, descripción) | Si registras un comercio | Verificarlo y mostrarlo a los usuarios |
| Ubicación del dispositivo | Solo si la autorizas en el mapa | Mostrar los eventos cercanos. Si la rechazas, usamos una ubicación predeterminada del piloto |
| Asistencias, entradas, códigos QR y compras | Cuando confirmas asistencia o compras | Gestionar tu ingreso y el pago |
| Mensajes al asistente de IA | Cuando usas las recomendaciones | Responderte con eventos según lo que pides |

No recogemos datos sensibles ni datos de menores de edad. La app está dirigida a mayores de 18 años.

## 3. Para qué usamos tus datos

- Crear tu cuenta y mantener tu sesión.
- Mostrarte eventos y recomendaciones acordes a tus intereses y a tu zona.
- Gestionar la asistencia, la compra de entradas y la validación del código QR.
- Verificar manualmente los perfiles de comercio.
- Atender consultas, reclamos y reportes.
- Cumplir obligaciones legales y proteger la seguridad del servicio.

No vendemos tus datos ni los usamos para fines distintos a estos sin pedirte una nueva autorización.

## 4. Con quién los compartimos

Solo con los proveedores necesarios para que Festa funcione, que los tratan por encargo nuestro:

- el proveedor de la nube donde se despliega el servicio [por definir: Azure, AWS o GCP];
- Wompi, para procesar los pagos (Festa no almacena números de tarjeta);
- Mapbox, para mostrar el mapa;
- el proveedor del modelo de lenguaje de las recomendaciones [por definir];
- Google, si eliges iniciar sesión con tu cuenta de Google.

Podemos transferir datos fuera de Colombia cuando alguno de estos proveedores opere en otro país, con las garantías que exige la ley.

## 5. Cómo protegemos tus datos

- Comunicaciones cifradas con TLS.
- El correo y el nombre se guardan cifrados en la base de datos (AES-256).
- Cada servicio tiene su propia base de datos y ninguno lee la base de otro.
- Las contraseñas se guardan con un algoritmo de huella unidireccional.
- Los secretos y claves no se guardan en el código.
- Límite de intentos de inicio de sesión para frenar accesos no autorizados.

## 6. Tus derechos como titular

Puedes, en cualquier momento:

1. **Conocer** los datos que tenemos sobre ti.
2. **Actualizar y rectificar** tus datos.
3. **Pedir prueba** de la autorización que nos diste.
4. **Ser informado** del uso que hacemos de tus datos.
5. **Presentar quejas** ante la Superintendencia de Industria y Comercio por infracciones a la ley.
6. **Revocar la autorización y pedir la supresión** de tus datos. En la app, el borrado de cuenta elimina tus datos personales, cierra tus sesiones y avisa a los demás servicios para que también los eliminen.
7. **Acceder gratuitamente** a tus datos.

Para ejercer estos derechos escribe al correo de contacto de la sección 1. Responderemos las consultas en máximo 10 días hábiles y los reclamos en máximo 15 días hábiles, como indica la ley.

## 7. Cuánto tiempo los conservamos

Mientras tu cuenta esté activa. Si la eliminas, borramos tus datos personales. Podemos conservar, de forma anonimizada o por el tiempo que exija la ley, los registros de pagos y de seguridad.

## 8. Cambios en esta política

Si la política cambia, publicaremos la nueva versión y te lo avisaremos en la app. Guardamos junto a tu cuenta la fecha y la versión de la política que autorizaste.

---

## Texto de la autorización en la app (aviso corto)

Se muestra en la pantalla de registro, junto a una casilla que debe marcarse para poder crear la cuenta. Es el texto que enlaza a esta política:

> **Autorizo el tratamiento de mis datos personales.** Autorizo a Festa a recolectar, almacenar y usar mis datos personales (correo, nombre, perfil, intereses y, si lo permito, mi ubicación) para crear mi cuenta, recomendarme eventos y gestionar mis entradas, según la [Política de privacidad](./politica-de-privacidad.md) (versión 1.0). Puedo conocer, actualizar, rectificar y suprimir mis datos y revocar esta autorización cuando quiera, escribiendo a Desparcha2@pruebacorreoescuelaingeduco.onmicrosoft.com o eliminando mi cuenta en la app.

Si la persona no marca la casilla, el registro no se completa (el servicio responde 400). Al registrarse se guardan la fecha y la versión de la política autorizada (SCRUM-126).
