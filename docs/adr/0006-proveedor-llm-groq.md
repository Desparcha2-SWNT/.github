# ADR 0006 — Proveedor de LLM: Groq (reemplaza al ADR 0003)

- **Estado:** Aceptada
- **Fecha:** 2026-11-25
- **Participantes:** decidido por el equipo Desparcha2.
- **Historias relacionadas (Jira):** SCRUM-30 (RF8), SCRUM-31 (RF9), SCRUM-98

## Contexto
El [ADR 0003](0003-proveedor-llm-gemini.md) eligió Gemini. En las pruebas, la cuota de Gemini se agotaba rápido y seguir con él obligaba a pagar desde el desarrollo. `festa-ai-service` ya tenía un cliente con varios proveedores (`LLM_PROVIDER`), así que cambiar de proveedor no toca el chat ni las descripciones.

## Opciones consideradas
1. **Seguir con Gemini:** sin cambios de código, pero con el costo y la cuota que motivaron este ADR. Además, `gemini-2.5-flash` se apaga el 1 de diciembre de 2026.
2. **Groq:** sirve modelos abiertos (Llama, gpt-oss) con una API compatible con la de OpenAI, soporta salida JSON y tiene un plan con límites por minuto y por día. El cliente reutiliza el código de OpenAI cambiando solo la URL.
3. **OpenAI o Anthropic:** ya soportados por el cliente, pero sin un plan de uso para el piloto.

## Decisión
Se usa **Groq** con el modelo `llama-3.3-70b-versatile` para el chat (RF8) y las descripciones (RF9). Se configura con `LLM_PROVIDER=groq`, `LLM_CHAT_MODEL` y `LLM_DESCRIPTION_MODEL`; la llave va en el secreto `LLM_API_KEY`. Se eligió un modelo que no razona antes de responder, porque el chat debe devolver JSON dentro de un tope de 500 tokens.

## Consecuencias
- Código: festa-ai-service#3 (quita Gemini y agrega Groq) y festa-infra#27 (valores predeterminados de Terraform, Compose y ejemplos de los contratos). Se fusionan juntos.
- Falta probar con una llave real que el modelo devuelva el JSON del chat solo con eventos reales y descripciones aceptables en español.
- El modelo de costos (`docs/costos/`) y el XLSM siguen calculados con Gemini; hay que recalcular el cupo de IA de Festa Pro con los precios de Groq, sin contar capas gratuitas.
- La política de privacidad nombra a Groq como proveedor del modelo de lenguaje.
- Los diagramas (C4 y Lucid) deben mostrar Groq como sistema externo.
