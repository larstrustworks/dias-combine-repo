# Legacy DiasUI — System Overview

The legacy DiasUI is an **Angular 5+** single-page application for managing driving instruction administration (DIAS — Driving Instruction Administration System). It runs on IIS at `https://api.dekra.nu` (prod) / `http://localhost:30659` (dev).

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Angular 5+ with PrimeNG, ngx-datatable, Bootstrap |
| State | Angular services + RxJS Observables |
| i18n | `@ngx-translate/core` |
| Forms | Reactive Forms (`FormBuilder`, `FormGroup`, `Validators`) |
| Grid | Custom `grid-view` component wrapping PrimeNG DataTable |
| HTTP | `HttpClient` via service classes extending `BaseAPIService` |
| Auth | Token-based (localStorage), role-checked menu visibility |

## Architecture

```
Browser (Angular SPA)
  └─ BaseAPIService.WebApiUrl ──────────► IIS DiasAPI (port 80/30659)
  └─ BaseAPIService.DiasServicesApiUrl ─► IIS Gateway/DiasServices (port 60022)
  └─ BaseAPIService.HenteOpsamledeDataApiUrl ► Efteruddannelse API (port 53134)
  └─ BaseAPIService.UvmIndberetningUrl ─► UVM Indberetning API (port 63334)
  └─ ConfigModel.BillingServiceUrl ─────► BillingService API (port 5196)
  └─ environment.businessCentralApiUrl ─► Business Central OData API
```

## Key Source Directories

| Path | Description |
|------|-------------|
| `Legacy/DiasUI/src/app/pages/` | All page modules (67 folders) |
| `Legacy/DiasUI/src/app/pages/services/gen/` | 60+ API service classes |
| `Legacy/DiasUI/src/app/pages/dtos/gen/` | 180+ DTO interfaces |
| `Legacy/DiasUI/src/app/pages/Models/Enum/globals.ts` | Enums (OrderDirection, TextSearchOptions, Operator, ObjectType, etc.) |
| `Legacy/DiasUI/src/app/theme/components/menu/menu.ts` | Menu definitions with role requirements |
| `Legacy/DiasUI/src/app/pages/pages.routing.ts` | Top-level lazy-loaded routes |
| `Legacy/DiasUI/src/environments/` | Environment configs (dev, prod, uat) |
| `Legacy/DiasUI/src/app/pages/WebApiServices/ConfigModel.ts` | Static URL configuration |

## Related Documentation

- [Roles](./roles.md) — All 50+ legacy roles with descriptions
- [Menu Items](./menu-items.md) — Full menu tree with role→route mapping
- [API Endpoints](./api-endpoints.md) — All legacy API endpoints grouped by service
- [External Services](./external-services.md) — External service URLs and purposes
- [DTOs](./dtos.md) — Key DTO interfaces
- [Page Inventory](./page-inventory.md) — Complete list of pages with conversion status
