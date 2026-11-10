# Evidencia de seguridad del proyecto

Complementa la [política de seguridad](../../SECURITY.md) (cómo reportar y qué cubrimos) con la evidencia: qué se
analizó, con qué herramienta, qué se encontró y qué se decidió. Se actualiza en cada entrega. Basado en el kit de
integración AppSec del curso, adaptado a lo que el equipo ya tiene.

## 1. Alcance autorizado
- Organización: `Desparcha2-SWNT`, repositorios `festa-*` y `.github`.
- Entorno de pruebas dinámicas: el que despliega el equipo en el AWS Learner Lab (`festa-infra`, SCRUM-134). Se enciende solo para
  demostraciones y pruebas porque el crédito es de USD 50 en total.
- Fuera de alcance: sistemas de terceros (Wompi, Google, Gemini, Mapbox), datos reales de personas y pruebas destructivas o
  de denegación de servicio.

## 2. Herramientas y estado
| Control | Tipo | Dónde corre | Estado |
|---|---|---|---|
| CodeQL | SAST | CI reutilizable, en cada pull request, activable por repositorio (`enable-codeql`) | Activo donde se configuró; se omite en `festa-mobile` |
| Trivy | Secretos, dependencias y configuración | CI reutilizable, en cada pull request | Activo |
| Pruebas, linter y formato | Calidad | CI de cada repositorio | Activo |
| Reglas de ramas | Control de cambios | `main` y `develop` de cada repositorio | Activo: una aprobación de otra persona, hilos resueltos, sin force-push |
| Dependabot | SCA | Cada repositorio | Este repositorio desde este PR; los `festa-*` están pendientes (ejemplo en `docs/plantillas/dependabot-ejemplo.yml`) |
| Secret scanning y push protection de GitHub | Secretos | Ajustes del repositorio | Por verificar en *Settings, Security* de cada repositorio |
| OWASP ZAP baseline | DAST pasivo | Workflow manual `DAST pasivo (ZAP)` de este repositorio | Pendiente: necesita el backend encendido |

No incluimos Semgrep ni Gitleaks del kit: CodeQL y Trivy ya cubren el análisis estático y los secretos, y duplicarlos
genera alertas repetidas.

## 3. Hallazgos y gestión
| ID | Categoría | Descripción | Riesgo | Ruta | Decisión | Estado |
|---|---|---|---|---|---|---|
| F-01 | CWE-352 (CSRF) | CodeQL avisó que `SecurityConfig` desactiva la protección CSRF (`http.csrf(c -> c.disable())`) | Bajo | `festa-auth-service`, `config/SecurityConfig.java` | Falso positivo: la API no tiene sesión ni cookies; autentica con un JWT en el encabezado `Authorization`, que el navegador no envía solo. Se resolvió el hilo en el pull request | Cerrado |

## 4. Validación antes y después
- Evidencia inicial: alerta de CodeQL y su hilo en el pull request de `festa-auth-service` (release del Sprint 1).
- Corrección: no hubo cambio de código; la decisión quedó documentada en esta tabla.
- Riesgo residual: si el servicio llegara a usar cookies de sesión, hay que reactivar CSRF.

## 5. Pendientes para la sustentación técnica
- Correr el DAST pasivo una vez con el backend encendido y adjuntar `informe-zap` aquí.
- Activar Dependabot en los `festa-*`.
- Verificar secret scanning y push protection.
- Pentest autorizado y no destructivo sobre el entorno del equipo: hipótesis, solicitudes inocuas, resultado y prueba de
  regresión, con el formato de [`INFORME_HALLAZGOS.md`](INFORME_HALLAZGOS.md).
