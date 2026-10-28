<!--
Título del PR: <tipo>(<alcance>): <descripción> [SCRUM-<n>]
Ejemplo:      feat(mobile): pantalla de registro con correo [SCRUM-50]
Al fusionar con squash, el título queda como commit en develop. Ver CONTRIBUTING.md, secciones 1 a 3.
-->

## Tarea de Jira
<!-- Enlace a la tarea, por ejemplo: https://desparcha2.atlassian.net/browse/SCRUM-50 -->

## Tipo de cambio
- [ ] `feat` — funcionalidad nueva
- [ ] `fix` — corrección de un error
- [ ] `docs` / `test` / `refactor` / `ci` / `chore`
- [ ] Rompe un contrato (API, mensajes de RabbitMQ o esquema de base de datos): explícalo en Riesgos

## Qué cambia y por qué
<!-- Resumen breve. Si hay una decisión de diseño, di cuál y por qué. -->

## Cómo probarlo
<!-- Pasos concretos para que quien revise lo compruebe: comandos, datos de prueba y resultado esperado. -->

## Evidencia
<!-- Capturas o GIF si cambia una pantalla; salida de las pruebas o del CI si aplica. -->

## Checklist (Definition of Done)
- [ ] La rama sigue el formato `<tipo>/SCRUM-<n>-<descripcion>` y sale de `develop` (o de `main` si es un hotfix)
- [ ] El título del PR sigue el formato `<tipo>(<alcance>): <descripción> [SCRUM-<n>]`
- [ ] Cumple los criterios de aceptación de la tarea en Jira
- [ ] Tiene pruebas automatizadas y el CI pasa
- [ ] No hay secretos, llaves ni datos personales en el código
- [ ] Actualicé README, diagramas o ADR si cambió algo de la arquitectura
- [ ] Los commits con código generado por IA llevan el trailer `Co-Authored-By`
- [ ] Si usé un prompt importante, lo registré en la bitácora

## Riesgos o dudas
<!-- Qué podría romperse, qué falta o qué quieres que se revise con más atención. -->
