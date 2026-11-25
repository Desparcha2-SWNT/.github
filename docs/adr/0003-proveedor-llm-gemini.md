# ADR 0003 — Proveedor de LLM: Gemini

- **Estado:** Aceptada
- **Fecha:** 2026-11-01
- **Participantes:** decidido por Juan Sebastián Guayazán Clavijo; el equipo Desparcha2 debe ratificarlo.
- **Historias relacionadas (Jira):** SCRUM-30 (RF8), SCRUM-31 (RF9), SCRUM-98

## Contexto
`festa-ai-service` necesita un modelo de lenguaje para recomendar eventos (RF8) y generar descripciones (RF9), con límite de solicitudes por usuario y descripciones guardadas para no pagarlas dos veces (RNF8).

Los diagramas daban tres respuestas distintas: Amazon Bedrock (Lucid, AWS), Azure OpenAI (Lucid y C4, Azure) y Gemini (`festa-infra`, `.env.example` con `LLM_PROVIDER=gemini` y los contratos de eventos con `"provider": "gemini"`). El despliegue en la nube sigue abierto (ADR 0001), así que el proveedor del modelo no debería depender de la nube elegida.

## Opciones consideradas
1. **Gemini (API de Google):** ya está configurado en `festa-infra`; funciona igual desde Azure, AWS o GCP; el modelo `gemini-2.5-flash` es el más económico de la familia. Es un proveedor externo y sus datos salen de la nube del proyecto.
2. **Azure OpenAI:** integrado con Azure, pero obliga a esa nube y a pedir acceso al servicio.
3. **Amazon Bedrock:** integrado con AWS, con el mismo vínculo a una sola nube.

## Decisión
Se usa **Gemini** como proveedor de LLM, llamado como API externa desde `festa-ai-service` con `LLM_PROVIDER=gemini` y `LLM_CHAT_MODEL` / `LLM_DESCRIPTION_MODEL` definidos en `festa-infra`. Azure OpenAI y Bedrock quedan descartados.

## Consecuencias
- Los diagramas de Lucid (AWS, Azure, microservicios y casos de uso), `festa.dsl` y `alcance.md` muestran "Google Gemini API" como sistema externo, sin ícono de la nube.
- La clave de la API va en el gestor de secretos de la nube (Key Vault o Secrets Manager), nunca en el código.
- La política de privacidad debe nombrar a Google como proveedor del modelo (SCRUM-129) y avisar que los mensajes al asistente se envían a un tercero.
- Hay que fijar el límite de solicitudes (5 a 20 por usuario por minuto) y guardar cada descripción generada (RNF8).
- Si en el futuro se cambia de proveedor, se crea un ADR nuevo; el código lo permite por la variable `LLM_PROVIDER`.
- Pendiente: calcular el costo por solicitud de Gemini para SCRUM-131 (sin capas gratuitas).
