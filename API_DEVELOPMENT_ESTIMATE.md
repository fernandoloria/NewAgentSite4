# Estimación de Desarrollo de API .NET

> Este documento resume la estimación ejecutiva para crear una API RESTful en .NET que reemplace gradualmente la funcionalidad del WebForms legacy y sea consumida por una Angular PWA. La estimación se basa en el inventario actual de `Report`, `Popup` y `Services`, y debe validarse con negocio, DBA y el equipo técnico antes de cerrar presupuesto o cronograma contractual.

## 1. Resumen ejecutivo

Con base en el inventario actual, la estimación realista para crear el API en .NET es de **5 a 9 meses calendario**, dependiendo del tamaño del equipo, el alcance exacto, la disponibilidad de reglas de negocio y el nivel de validación contra el WebForms original.

El proyecto no debe tratarse como una simple conversión de reportes. La aplicación contiene:

- **104 pantallas en `Report`**.
- **19 popups en `Popup`**.
- **20 handlers en `Services`**.
- Uso intensivo de `Session`, `QueryString`, permisos y stored procedures.
- Operaciones de lectura y también operaciones transaccionales de `INSERT`, `UPDATE`, `DELETE` y `EXEC stored procedure`.

La estimación recomendada para una migración completa, segura y lista para Angular PWA es:

> **6 a 9 meses calendario con 2 desarrolladores backend, QA y apoyo de negocio.**

Para un primer MVP usable:

> **8 a 12 semanas.**

## 2. Escenarios de estimación

| Escenario | Alcance | Equipo sugerido | Tiempo calendario estimado |
|---|---|---:|---:|
| MVP API básica | Login JWT, estructura base, catálogos, dashboards, algunos reportes simples | 1 backend + QA parcial | 8 a 12 semanas |
| API funcional por módulos principales | Reportes principales, services actuales, filtros, paginación, JWT, Swagger, primeros CRUD controlados | 2 backend + 1 QA | 4 a 6 meses |
| Migración completa razonable | Reports + Popups + Services + operaciones INSERT/UPDATE/DELETE + validación contra WebForms + seguridad + Angular-ready | 2-3 backend + QA + apoyo negocio | 6 a 9 meses |
| Migración completa conservadora | Refactor fuerte, SP complejos, auditoría, pruebas completas, reportes grandes, exportaciones y hardening | 3 backend + QA + DevOps + negocio | 9 a 12 meses |

## 3. Estimación por fases

| Fase | Descripción | Duración estimada | Comentarios |
|---|---|---:|---|
| 1 | API base y seguridad | 2 a 4 semanas | Proyecto API, configuración, JWT, refresh token, Swagger, logging, middleware de errores |
| 2 | Catálogos, contexto y services simples | 3 a 5 semanas | Agentes, jugadores, jerarquía, deportes, filtros, permisos y menú |
| 3 | Reportes simples | 6 a 8 semanas | Reportes read-only, filtros server-side, paginación, ordenamiento y comparación contra WebForms |
| 4 | Reportes complejos y exportaciones | 8 a 10 semanas | Weekly reports, historial, open bets, exposure, reportes con totales, exportaciones y optimización |
| 5 | Popups y handlers actuales | 5 a 7 semanas | Reemplazo de ASHX, popups de consulta, popups transaccionales y normalización de respuestas |
| 6 | CRUD y procesos transaccionales | 8 a 12 semanas | Inserts, updates, deletes, pagos, free play, límites, perfiles, mensajes, void wager y auditoría |
| 7 | QA, Angular, seguridad y despliegue | 4 a 8 semanas | Pruebas manuales, comparación WebForms vs API, integración Angular, hardening, monitoreo y release |

## 4. Estimación por tipo de endpoint

| Tipo de endpoint | Tiempo estimado por endpoint | Riesgo típico |
|---|---:|---|
| Catálogo simple | 0.5 a 1 día | Bajo |
| Consulta simple | 1 a 2 días | Bajo/Medio |
| Reporte simple | 1 a 3 días | Medio |
| Reporte complejo | 3 a 8 días | Medio/Alto |
| Insert | 2 a 5 días | Medio/Alto |
| Update | 3 a 6 días | Alto |
| Delete | 4 a 10 días | Alto |
| Proceso financiero o transaccional crítico | 5 a 10 días | Alto/Muy alto |
| Exportación de reporte grande | 3 a 8 días | Medio/Alto |
| Endpoint de seguridad/JWT | 2 a 5 días | Alto |

## 5. Estimación por tamaño de equipo

| Equipo | Velocidad esperada | Tiempo calendario recomendado |
|---|---|---:|
| 1 backend full-time | Avance lineal, alto riesgo de cuello de botella | 9 a 12 meses |
| 2 backend + QA parcial | Balance adecuado para migración por módulos | 6 a 9 meses |
| 3 backend + QA + DBA parcial | Mejor paralelización, requiere coordinación fuerte | 4.5 a 6.5 meses |
| 3+ backend sin QA/negocio disponible | Riesgo de retrabajo alto | No recomendado |

## 6. Arquitectura recomendada para estimación

La opción recomendada sigue siendo una **migración híbrida por fases**:

1. Mantener WebForms funcionando.
2. Crear una API separada en .NET.
3. Migrar primero endpoints read-only y catálogos.
4. Comparar resultados de API vs WebForms.
5. Migrar reportes complejos.
6. Migrar operaciones transaccionales.
7. Dejar deletes y procesos financieros para fases con mayor control.
8. Integrar gradualmente Angular PWA.

### Opción rápida

Crear una API con **ASP.NET Web API 2 sobre .NET Framework 4.8** puede reducir fricción inicial si existen librerías legacy difíciles de mover.

### Opción estratégica

Crear una API nueva en **ASP.NET Core** es mejor para seguridad, mantenibilidad, Swagger, hosting moderno, dependency injection y consumo desde Angular PWA. Puede agregar entre **15% y 30% más esfuerzo inicial** por adaptación.

## 7. Alcance recomendado para MVP

Un MVP de **8 a 12 semanas** debería incluir:

1. Proyecto API base.
2. Configuración por ambiente.
3. JWT access token.
4. Refresh token.
5. Swagger/OpenAPI.
6. Middleware de errores estándar.
7. Logging con correlationId.
8. `POST /api/auth/login`.
9. `POST /api/auth/refresh`.
10. `GET /api/me`.
11. `GET /api/navigation`.
12. Catálogo de agentes.
13. Catálogo de jugadores.
14. `Dashboard`.
15. `WelcomeReport`.
16. `PlayerAccess` read-only.
17. 3 a 5 reportes simples.
18. Comparación manual contra WebForms.
19. Primer contrato JSON estándar.
20. Prueba inicial de consumo desde Angular.

## 8. Principales factores que pueden aumentar el tiempo

| Factor | Impacto |
|---|---|
| Stored procedures sin documentación | Aumenta análisis y pruebas |
| Reglas de negocio en code-behind | Aumenta riesgo de omitir validaciones |
| Operaciones financieras o de balance | Exige auditoría y pruebas exhaustivas |
| Uso intensivo de Session | Requiere rediseñar contexto en JWT/DTO |
| Popups que modifican datos | Puede ocultar procesos críticos |
| Falta de ambientes de prueba con datos confiables | Aumenta QA y retrabajo |
| Reportes grandes sin paginación | Exige optimización y posible exportación asíncrona |
| Permisos no centralizados | Aumenta complejidad de seguridad |
| Integración Angular simultánea | Requiere coordinación de contratos y mocks |

## 9. Recomendación de planificación

Para planificación formal, usaría esta línea base:

| Concepto | Recomendación |
|---|---|
| Presupuesto base | 6 meses |
| Reserva de riesgo | +30% |
| Plan contractual prudente | 8 a 9 meses |
| MVP demostrable | 8 a 12 semanas |
| Primer release productivo parcial | 4 a 6 meses |
| Release completo recomendado | 6 a 9 meses |

## 10. Respuesta corta

La creación del API en .NET para este proyecto debería estimarse así:

- **MVP funcional:** 8 a 12 semanas.
- **API por módulos principales:** 4 a 6 meses.
- **Migración completa y segura:** 6 a 9 meses.
- **Escenario conservador con alto control:** 9 a 12 meses.

La estimación más responsable para presentar al negocio es:

> **6 a 9 meses para una API .NET completa, segura, documentada, validada contra WebForms y lista para ser consumida por Angular PWA.**

