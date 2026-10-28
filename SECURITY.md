# Política de seguridad — Festa

## Cómo reportar una vulnerabilidad

No abras un issue público. Avísale directamente al equipo por el chat del grupo o al correo del proyecto (`Desparcha2@pruebacorreoescuelaingeduco.onmicrosoft.com`), con:

- el repositorio y la rama afectados,
- los pasos para reproducirlo,
- el impacto que crees que tiene.

El equipo confirmará la recepción, corregirá el problema en una rama `fix/` o `hotfix/` y registrará el cambio en Jira.

## Qué cubrimos en el proyecto

- **Secretos:** nunca en el repositorio; escaneo automático en el CI.
- **Dependencias:** revisión de vulnerabilidades conocidas en cada pull request.
- **Código:** análisis estático en el CI.
- **Autenticación:** JWT con expiración corta emitido por `festa-auth-service` y validado en `festa-gateway`.
- **Pagos:** solo llaves de sandbox de Wompi durante el proyecto académico.
- **Datos personales:** tratamiento conforme a la Ley 1581 de 2012.

Este es un proyecto académico en fase de desarrollo: no hay soporte formal de versiones ni garantías de seguridad en producción.
