# Angular PWA API Requirements

> Recomendaciones para consumir la API RESTful desde una Angular PWA con lazy loading, guards, preloading y operación segura.

## 1. Contratos base

- Todas las respuestas deben usar `ApiResponse<T>` con `success`, `data`, `errors` y `metadata`.
- Los listados deben aceptar `page`, `pageSize`, `sort`, `filters` y devolver `totalRecords`.
- Los reportes grandes deben soportar `POST /query` y `POST /export` asíncrono si exceden el umbral definido.

## 2. Seguridad SPA

| Necesidad Angular | Endpoint/API requerido | Notas |
|---|---|---|
| Login | `POST /api/auth/login` | Devuelve access token, refresh token y contexto mínimo |
| Refresh | `POST /api/auth/refresh` | Rotación de refresh token |
| Logout | `POST /api/auth/logout` | Revoca refresh token |
| Guards | `GET /api/me` y `GET /api/navigation` | Permisos y menú por usuario/agente |
| Cambio subagente | `POST /api/security/context/sub-agent` | Reemplaza `ChangeSubAgent.ashx` |

## 3. Lazy loading y preloading

- Cada ruta Angular debe tener un endpoint de bootstrap: `/api/screens/{screen}/bootstrap` o endpoints específicos `filters`, `lookups`, `permissions`.
- Precargar catálogos de agentes, jugadores, deportes, monedas, perfiles y permisos cuando el usuario entra al módulo.
- Evitar que pantallas dependan de ViewState; todo estado debe vivir en router params, store cliente o requests explícitos.

## 4. Caché e invalidación

| Tipo de dato | Cache recomendado | Invalidación |
|---|---|---|
| Catálogos estables | HTTP cache/ETag 5-30 min | cambios administrativos |
| Permisos/menú | cache por sesión | refresh/login/cambio subagente |
| Reportes | no-cache o cache corto por filtros | cambio de transacciones |
| Escrituras | nunca cachear | invalidar queries relacionadas |

## 5. Errores y UX

- Usar códigos de error estables: `VALIDATION_ERROR`, `FORBIDDEN`, `NOT_FOUND`, `CONFLICT`, `BUSINESS_RULE_FAILED`.
- Incluir `correlationId` para soporte.
- Angular debe mostrar estados loading, empty state y retry para consultas; confirmaciones dobles para deletes/pagos/free play.

## 6. Offline PWA

- Offline solo para lectura de catálogos o últimas consultas cacheadas si negocio lo permite.
- No permitir pagos, void wager, límites, free play ni perfiles offline.
- Si se implementa cola offline para notas de bajo riesgo, debe usar idempotency key y resolución de conflictos.

## 7. Endpoints auxiliares prioritarios

1. `GET /api/me`
2. `GET /api/navigation`
3. `GET /api/permissions`
4. `GET /api/lookups/agents`
5. `GET /api/lookups/players?agentId=`
6. `GET /api/lookups/sports`
7. `GET /api/reports/{name}/filters`
8. `POST /api/reports/{name}/query`
9. `POST /api/reports/{name}/export`
10. `GET /api/exports/{jobId}`
