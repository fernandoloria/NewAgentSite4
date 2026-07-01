# Estimación Ejecutiva para Creación de API .NET

## 1. Estimación ejecutiva

| Escenario | Alcance | Equipo sugerido | Tiempo calendario estimado |
|---|---|---|---|
| MVP API básica | Login JWT, estructura base, catálogos, dashboards, algunos reportes simples | 1 backend + 1 QA parcial | 8 a 12 semanas |
| API funcional por módulos principales | Reportes principales, services actuales, filtros, paginación, JWT, Swagger, primeros CRUD controlados | 2 backend + 1 QA | 4 a 6 meses |
| Migración completa razonable | Reports + Popups + Services + operaciones INSERT/UPDATE/DELETE + validación contra WebForms + seguridad + Angular-ready | 2-3 backend + QA + apoyo negocio | 6 a 9 meses |
| Migración completa conservadora | Incluye refactor fuerte, SP complejos, auditoría, pruebas completas, reportes grandes, exportaciones y hardening | 3 backend + QA + DevOps + negocio | 9 a 12 meses |

Mi recomendación sería planificar **6 meses** como objetivo realista inicial, con un margen de seguridad hacia **9 meses** si aparecen reglas de negocio no documentadas o stored procedures complejos.

## 2. Estimación por esfuerzo de desarrollo

En el documento de planificación se dejó una estimación por fases. Sumando las duraciones realistas de forma serial, el esfuerzo total ronda aproximadamente **40 semanas-persona** para una migración completa inicial.

| Fase | Estimación realista |
|---|---:|
| Análisis detallado y validación funcional | 4 semanas |
| Base API, JWT, Swagger, logging | 2 semanas |
| Migración de reportes simples | 6 semanas |
| Migración de reportes complejos | 8 semanas |
| Migración de popups y services | 6 semanas |
| Migración de CRUD/transacciones | 8 semanas |
| QA, Angular, Swagger, despliegue | 6 semanas |
| **Total aproximado serial** | **40 semanas-persona** |

Con **2 desarrolladores backend trabajando en paralelo**, más QA y apoyo de negocio, eso puede traducirse en aproximadamente **20 a 28 semanas calendario**, es decir, **5 a 7 meses**.

## 3. Recomendación concreta para este proyecto

Para este caso, yo no empezaría intentando migrar todo de una vez. Recomendaría una estrategia de **API nueva por fases**, manteniendo el WebForms funcionando. El plan ya marca como recomendada una estrategia híbrida por fases, porque permite mantener la aplicación actual operativa mientras se crea la API.

## 4. Arquitectura recomendada

| Opción | Recomendación |
|---|---|
| ASP.NET Web API 2 en .NET Framework 4.8 | Buena opción si hay mucha lógica o librerías legacy difíciles de mover. Menor fricción inicial. |
| ASP.NET Core API nueva | Mejor opción estratégica si quieren una API moderna, mantenible y lista para Angular PWA. Requiere más adaptación. |
| Híbrida por fases | Mi recomendación principal: empezar con API separada, exponer módulos gradualmente y comparar resultados contra WebForms. |

Si la prioridad es **velocidad y compatibilidad**, usaría **ASP.NET Web API 2 sobre .NET Framework 4.8**.

Si la prioridad es **futuro, mantenibilidad, seguridad y Angular PWA**, usaría **ASP.NET Core**, aunque agregaría entre **15% y 30% más esfuerzo inicial** por adaptación de librerías, configuración, autenticación, acceso a datos y despliegue.

## 5. Estimación por tipo de endpoint

La regla base propuesta en el plan es:

| Tipo de endpoint | Tiempo estimado por endpoint |
|---|---:|
| Catálogo simple | 0.5 a 1 día |
| Reporte simple | 1 a 3 días |
| Reporte complejo | 3 a 8 días |
| Operación transaccional | 2 a 8 días |
| Delete / proceso financiero / proceso crítico | 4 a 10 días |

Esta regla está documentada como base para la estimación endpoint-by-endpoint.

El inventario de endpoints propuesto incluye endpoints para reportes, services y popups, con estimaciones individuales de **1-3 días** para consultas simples y **2-5 días o más** para endpoints con mayor riesgo o escritura.

## 6. Parte crítica: operaciones de escritura

Lo que más afecta la estimación no son los reportes simples, sino las operaciones que modifican datos.

El inventario detectó operaciones como:

- creación de agentes;
- creación de jugadores;
- pagos;
- free play;
- límites de crédito;
- edición de perfiles;
- mensajes;
- ocultamiento de ligas;
- cancelación de wagers;
- cambio de subagente;
- operaciones sobre permisos y menús.

Estas operaciones están marcadas con riesgo medio/alto o alto porque requieren validación, permisos, auditoría y pruebas con escenarios inválidos.

Por ejemplo, `CancelWagerPopUp` usa una operación crítica relacionada con `VoidWager`, y `FreePlayAdd` usa `InsertPlayerTransaction`, ambas clasificadas como riesgo alto.

## 7. Estimación recomendada por fases

### Fase 1 — API base y seguridad

**Duración estimada:** 2 a 4 semanas.

Incluye:

- proyecto API;
- configuración;
- conexión a base de datos;
- JWT;
- refresh token;
- Swagger/OpenAPI;
- middleware de errores;
- logging;
- endpoint `/api/auth/login`;
- endpoint `/api/me`;
- permisos base.

El plan propone JWT con access token corto y refresh token rotativo.

### Fase 2 — Catálogos, contexto y servicios simples

**Duración estimada:** 3 a 5 semanas.

Incluye:

- agentes;
- jugadores;
- jerarquía;
- deportes;
- filtros;
- permisos;
- menú;
- endpoints auxiliares para Angular.

Angular necesita endpoints como login, refresh, logout, `/api/me`, `/api/navigation` y cambio de subagente.

### Fase 3 — Reportes simples

**Duración estimada:** 6 a 8 semanas.

Incluye:

- reportes read-only;
- filtros server-side;
- paginación;
- ordenamiento;
- comparación contra WebForms;
- respuesta JSON estándar.

Los reportes deben devolver JSON con estructura estándar, paginación y metadata.

### Fase 4 — Reportes complejos y exportaciones

**Duración estimada:** 8 a 10 semanas.

Incluye:

- reportes semanales;
- historial;
- open bets;
- exposure;
- reportes con totales;
- reportes grandes;
- exportaciones;
- optimización de queries/SP;
- paginación real server-side.

Para Angular PWA, los reportes grandes deberían soportar `POST /query` y posiblemente `POST /export` asíncrono.

### Fase 5 — Popups y handlers actuales

**Duración estimada:** 5 a 7 semanas.

Incluye:

- reemplazo de ASHX;
- popups que consultan datos;
- popups que modifican datos;
- normalización de respuestas;
- validaciones;
- eliminación de dependencia de Session.

El inventario incluye **19 popups** y **20 services/handlers** que deberán ser reemplazados o clasificados como obsoletos.

### Fase 6 — CRUD y procesos transaccionales

**Duración estimada:** 8 a 12 semanas.

Incluye:

- insert;
- update;
- delete;
- pagos;
- free play;
- límites;
- perfiles;
- mensajes;
- cancelación de wagers;
- auditoría;
- idempotencia;
- rollback;
- validación de permisos.

Esta fase es la más delicada por impacto financiero y de seguridad.

### Fase 7 — QA, Angular, seguridad y despliegue

**Duración estimada:** 4 a 8 semanas.

Incluye:

- pruebas manuales por pantalla;
- comparación WebForms vs API;
- pruebas con Angular;
- Swagger final;
- hardening de seguridad;
- logs;
- monitoreo;
- despliegue;
- documentación de operación.

## 8. Estimación total recomendada

Si se hace bien, sin sobreoptimizar:

| Tipo de estimación | Tiempo calendario |
|---|---:|
| Optimista | 4 a 5 meses |
| Realista | 6 a 9 meses |
| Conservadora | 9 a 12 meses |

## 9. Estimación en personas

| Rol | Dedicación sugerida |
|---|---:|
| Arquitecto / Tech Lead .NET | 25% a 50% |
| Backend .NET Developer 1 | 100% |
| Backend .NET Developer 2 | 100% |
| QA funcional/técnico | 50% a 100% |
| DBA o apoyo SQL Server | 25% |
| Frontend Angular | 25% al inicio, 50%-100% en integración |
| Product Owner / negocio | disponibilidad semanal |

Con solo **1 desarrollador backend**, la migración completa podría irse fácilmente a **9 a 12 meses**.

Con **2 backend + QA + apoyo de negocio**, yo estimaría **6 a 9 meses**.

Con **3 backend bien coordinados**, podría bajarse a **4.5 a 6.5 meses**, pero solo si hay buena documentación de reglas de negocio y acceso rápido a validación.

## 10. Primer MVP recomendado

Para no esperar 6 meses antes de ver valor, haría un MVP de **8 a 12 semanas** con:

1. API base en .NET.
2. JWT.
3. Swagger.
4. `/api/auth/login`.
5. `/api/auth/refresh`.
6. `/api/me`.
7. `/api/navigation`.
8. Catálogo de agentes.
9. Catálogo de jugadores.
10. Dashboard.
11. WelcomeReport.
12. PlayerAccess.
13. 3 a 5 reportes simples.
14. Modelo estándar de errores.
15. Pruebas comparativas contra WebForms.

Después de ese MVP, ya se puede empezar a conectar Angular PWA con lazy loading, guards, interceptors y precarga de datos. Los endpoints auxiliares prioritarios para Angular están listados en el documento de requisitos PWA.

## 11. Respuesta corta

Mi estimación profesional sería:

> Crear el API en .NET para este WebForms legacy tomaría aproximadamente entre **6 y 9 meses** para una versión completa y segura, lista para Angular PWA.

Si buscan primero un MVP funcional:

> Un primer API base usable podría estar en **8 a 12 semanas**.

Si el alcance incluye todas las operaciones críticas, reportes, popups, services, pagos, free play, deletes, permisos, auditoría, Swagger y pruebas contra WebForms:

> Planificaría **9 meses** como estimación responsable.
