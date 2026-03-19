# Legacy External Services

All external service URLs used by the legacy DiasUI Angular application.
Source: `Legacy/DiasUI/src/environments/environment.ts` and `environment.prod.ts`.

## Service URLs

| Service | Config Key | Dev URL | Prod URL | New DiasUI Prefix |
|---------|-----------|---------|----------|-------------------|
| DiasAPI (main WebApi) | `WebApiUrl` | `http://localhost:30659` | `https://api.dekra.nu` | `/api/legacy/API/Api/...` |
| DiasServices / Gateway | `DiasServicesApiUrl` | `http://localhost:60022/api/` | `https://gatewaydemo.dekra.nu/api/` | `/api/legacy/Gateway/...` |
| Efteruddannelse | `HenteOpsamledeDataApiUrl` | `http://localhost:53134/` | `http://localhost:53134/` | `/api/legacy/Efteruddannelse/...` |
| Voksenuddannelse | `VoksenuddannelseUrl` | `https://fx.voksenuddannelse.dk` | `https://voksenuddannelse.dk` | _(external website, not proxied)_ |
| UVM Indberetning | `UvmIndberetningUrl` | `http://localhost:63334/api/` | `https://uvmindberetningprod.dekra.nu:63334/api/` | `/api/legacy/ReportingToUVM/...` |
| BillingService | `billingServiceUrl` | `http://localhost:5196/api/` | `https://dockerprodenv.dekra.nu:8443/api/` | BFF handles server-side |
| BillingCatalog | `billingCatalogApiUrl` | `http://localhost:5205/api/` | `https://dockerprodenv.dekra.nu:8453/api/` | BFF handles server-side |
| Business Central | `businessCentralApiUrl` | `https://api.businesscentral.dynamics.com/.../TestConvertJune/ODataV4/` | `https://api.businesscentral.dynamics.com/.../Production/ODataV4/` | `/api/bc/...` |

## How Each Service Is Used

### DiasAPI (`WebApiUrl`)
The main legacy API. Hosts all CRUD controllers for the core domain:
- Students, Schools, Locations, Sessions, Courses, Prices, Fees
- Users, Groups, Roles, Templates, Documents
- Reports, Protocols, Signups, Activities
- ~200+ endpoints across 50+ controllers

### DiasServices / Gateway (`DiasServicesApiUrl`)
Secondary API for specialized services:
- `Signup/` — EU order signups, school signups
- `ManuelEU/` — Manual EU service operations
- Used by `ManuelEUService` and `SignupService`

### Efteruddannelse (`HenteOpsamledeDataApiUrl`)
API for adult education (efteruddannelse) data:
- Used by `VoksenUddannelseService` for course info sync
- School calendar sync operations

### UVM Indberetning (`UvmIndberetningUrl`)
Reporting to UVM (Danish Ministry of Education):
- `RepportToUVMService` — get/send/resend UVM reports
- Endpoints: `GetAll`, `ReportToUVM`, `ResendToUVM`

### BillingService (`billingServiceUrl`)
Internal billing operations:
- `BillingService` — invoice management, billing types, chosen billing types
- Token endpoint for Business Central authentication
- API key required (`billingServiceApiKey`)

### Business Central (`businessCentralApiUrl`)
Microsoft Dynamics 365 Business Central OData API:
- Financial data integration
- BFF handles token acquisition server-side via BillingService
- Never expose tokens to browser

## New DiasUI Request Flow

In the new architecture, the browser **never** calls these services directly. All requests go through the BFF:

```
Browser → /api/legacy/API/Api/...     → BFF → DiasRestApi → Route Switcher → IIS DiasAPI
Browser → /api/legacy/Gateway/...     → BFF → DiasRestApi → Route Switcher → IIS Gateway
Browser → /api/legacy/Efteruddannelse/... → BFF → DiasRestApi → Route Switcher → Efteruddannelse API
Browser → /api/legacy/ReportingToUVM/... → BFF → DiasRestApi → Route Switcher → UVM API
Browser → /api/bc/...                 → BFF → (gets token from BillingService) → Business Central
```

## IIS Server Details

- **IP**: `10.200.250.31` (Windows/legacy)
- **DiasAPI**: HTTP port 80, HTTPS port 30659
- **Gateway**: Port 60022
- **Other services**: See `docs/LEGACY-PORT-VERIFICATION.md` and `DiasRestApi/dotnet_version/config/routes.json`
