# Legacy Service Port Verification

> **Status**: IIS bindings verified from `10.200.250.31` on 2025-03-19. 12 of 19 services confirmed. 7 services need further investigation.

## IIS Server: `10.200.250.31`

---

## Confirmed Services (from IIS)

| # | routes.json Service | IIS Site Name | Port | Status | Endpoints |
|---|---------------------|---------------|------|--------|-----------|
| 1 | `legacy-api` | DiasAPI | 30659 | ✅ Confirmed | 481 |
| 2 | `legacy-gateway` | Gateway | 60022 | ✅ Confirmed | 145 |
| 3 | `legacy-reporting-to-uvm` | UvmIndberetning | 63334 | ✅ Confirmed | 13 |
| 4 | `legacy-efteruddannelse` | Efteruddannelse | 53134 | ✅ Confirmed | 61 |
| 5 | `legacy-certificate` | Certificate | 63599 | ✅ Confirmed | 9 |
| 6 | `legacy-amu-certificate` | AMUCertificateService | 46690 | ✅ Confirmed | 7 |
| 7 | `legacy-school-calendars` | SchoolCalendar | 63032 | ✅ Confirmed | 7 |
| 8 | `legacy-offer` | Offer | 65187 | ✅ Confirmed | 3 |
| 9 | `legacy-document-api` | Document | 64341 | ✅ Confirmed | 29 |
| 10 | `legacy-messages` | Message | 64569 | ✅ Confirmed | 7 |
| 11 | `legacy-queue-api` | Queue | 55314 | ✅ Confirmed | 9 |
| 12 | `legacy-pdf-document` | DocumentGenerator | 21295 | ✅ Confirmed | 3 |

## Resolved Services (not in IIS)

| # | routes.json Service | BaseUrl | Resolution | Endpoints |
|---|---------------------|---------|------------|-----------|
| 13 | `legacy-billing-catalog` | `https://dockerprodenv.dekra.nu:8453` | Docker host (prod URL) | 13 |
| 14 | `legacy-billing-service` | `https://dockerprodenv.dekra.nu:8443` | Docker host (prod URL) | 50 |
| 15 | `legacy-cvr` | `http://10.200.250.31:30659` | Part of DiasAPI (CVRController found in Legacy/API) | 3 |
| 16 | `legacy-email` | `http://10.200.250.31:30659` | Part of DiasAPI (EmailController found in Legacy/API) | 2 |
| 17 | `legacy-umo-service` | `http://10.200.250.31:30659` | Part of DiasAPI (UMOLogController found in Legacy/API) | 2 |
| 18 | `legacy-dias-job` | `http://10.200.250.31:32761` | ⚠️ Placeholder port — not in IIS, verify on prod | 1 |
| 19 | `legacy-job-dias-api` | `http://10.200.250.31:30660` | ⚠️ Placeholder port — Legacy\JobDiasApi, verify on prod | 359 |

## IIS Sites NOT in routes.json

These IIS sites exist but have no matching DiasRestApi controller folder:

| IIS Site | Port | Notes |
|---|---|---|
| Datavarehuset (DWH) | 49685 | Called from DiasAPI server-side, not from UI |
| Uvm | 63333 | ReportingToUVM downstream (separate from UvmIndberetning 63334) |
| Logger | 50195 | NLog service — internal |
| Qualifications | 62161 | Ocelot downstream |
| Settings | 62854 | Ocelot downstream |
| DiasDataTransfer | 20250 | Data transfer utility |
| DataAnalyticsAPI | 443 (HTTPS only) | Analytics |

---

## Request Flow (end-to-end)

```
Browser → /api/legacy/API/Api/Student/GetAll
  ↓
BFF (port 4000) strips /api → /legacy/API/Api/Student/GetAll
  ↓
DiasRestApi (port 9090) route switcher matches /legacy/API/*
  → DestinationType: External → legacy-api service
  → BuildTargetUri strips /legacy/API → /Api/Student/GetAll
  ↓
Legacy DIAS.API on http://10.200.250.31:30659/Api/Student/GetAll
```

## Business Central Flow

```
Browser → /api/bc/Company('DEKRA')/SalesInvoice
  ↓
BFF (port 4000) handles directly:
  1. Gets BC token from BillingService (server-side, API key in BFF env)
  2. Calls BC OData API with Bearer token
  3. Returns response to browser
  ↓
No API keys or tokens ever reach the browser
```
