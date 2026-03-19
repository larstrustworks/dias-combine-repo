# DiasUI — Architecture & Developer Guide

> **Location**: `dias/docs/DIASUI-ARCHITECTURE.md`
> **Last updated**: 2026-03-19

---

## Table of Contents

1. [Overview](#overview)
2. [Tech Stack](#tech-stack)
3. [Repository Structure](#repository-structure)
4. [BFF Server](#bff-server)
5. [Authentication](#authentication)
6. [Shared Components](#shared-components)
7. [Centralized Theme](#centralized-theme)
8. [Routing & Navigation](#routing--navigation)
9. [API Layer](#api-layer)
10. [Build & Deployment](#build--deployment)
11. [Environment Variables](#environment-variables)

---

## Overview

DiasUI is the new React-based frontend for the DIAS (Driving Instruction Administration System). It replaces the legacy Angular application (`Legacy/DiasUI/`). The application runs behind a **BFF (Backend For Frontend)** Express server that handles authentication, session management, and API proxying.

### Architecture Diagram

```
Browser
  │
  ├── Static assets (index.html, JS, CSS)
  │
  └── API calls (/api/*, /auth/*)
        │
        ▼
┌──────────────────────────┐
│   BFF Server (Express)   │  Port 3000 (prod) / 4000 (dev)
│                          │
│  /auth/*  → session mgmt │
│  /api/*   → proxy + key  │
│  /*       → static files │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│   DiasRestApi (.NET 9)   │  Port 9090 (host) / 8080 (container)
│                          │
│  /Api/AccountInternal/*  │
│  /Api/Student/*          │
│  /Api/School/*           │
│  /Api/Location/*         │
│  ...                     │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│   DiasDalApi (Node.js)   │  Port 8080
│                          │
│  MSSQL connection pools  │
│  Schema-based routing    │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│   SQL Server (MSSQL)     │  10.200.250.41:1433
│   Database: dias         │
└──────────────────────────┘
```

---

## Tech Stack

| Layer       | Technology                                          |
|-------------|-----------------------------------------------------|
| Framework   | React 18 + TypeScript + Vite                        |
| Styling     | Tailwind CSS + shadcn/ui + CSS variables            |
| Routing     | React Router v6 (hash router)                       |
| State       | Zustand (auth), React Query (server state)          |
| Forms       | react-hook-form + zod + @hookform/resolvers         |
| Tables      | @tanstack/react-table v8                            |
| i18n        | react-i18next (en, da)                              |
| Icons       | Lucide React                                        |
| HTTP        | Axios (with credentials, via BFF proxy)             |
| BFF         | Express + express-session + http-proxy-middleware    |
| Build       | Vite (frontend) + tsc (BFF)                         |
| Deploy      | Docker multi-stage → GHCR → self-hosted runner      |

---

## Repository Structure

```
DiasUI/
├── server/                    # BFF server (Express + TypeScript)
│   ├── index.ts               # Entry point — Express app, session, static serving
│   ├── auth.ts                # Auth routes — impersonate, login, me, logout
│   ├── proxy.ts               # API proxy middleware → DiasRestApi
│   ├── config.ts              # Environment config reader
│   ├── package.json           # Server-only dependencies
│   └── tsconfig.json          # Server TypeScript config
│
├── src/
│   ├── components/
│   │   ├── auth/
│   │   │   └── RequireAuth.tsx      # Route guard — redirects to /login
│   │   ├── layout/
│   │   │   ├── AppLayout.tsx        # Main layout (sidebar + header + content)
│   │   │   ├── Sidebar.tsx          # Navigation sidebar
│   │   │   ├── Header.tsx           # Top bar (user, language, logout)
│   │   │   └── Breadcrumb.tsx       # Breadcrumb navigation
│   │   ├── shared/                  # Reusable UI components
│   │   │   ├── index.ts             # Barrel export
│   │   │   ├── DataTable.tsx        # TanStack Table wrapper
│   │   │   ├── PageHeader.tsx       # Page title + create button
│   │   │   ├── SearchInput.tsx      # Debounced search input
│   │   │   ├── FormModal.tsx        # Modal with form body + save/cancel
│   │   │   ├── ConfirmDialog.tsx    # Confirmation dialog (danger/default)
│   │   │   ├── StatusBadge.tsx      # Colored badge (success/warning/etc.)
│   │   │   ├── LoadingState.tsx     # Centered spinner with message
│   │   │   └── EmptyState.tsx       # Empty state with icon
│   │   └── ui/                      # shadcn/ui primitives
│   │
│   ├── config/
│   │   └── navigation.ts           # Sidebar menu structure + role requirements
│   │
│   ├── i18n/
│   │   ├── en.json                  # English translations
│   │   └── da.json                  # Danish translations
│   │
│   ├── lib/
│   │   ├── api.ts                   # Axios instance (withCredentials, 401 redirect)
│   │   └── utils.ts                 # cn() utility for class merging
│   │
│   ├── pages/
│   │   ├── LoginPage.tsx            # Login — impersonation + Entra ID
│   │   └── DashboardPage.tsx        # Dashboard with stats cards
│   │
│   ├── stores/
│   │   └── auth.ts                  # Zustand auth store (checkSession, impersonate, logout)
│   │
│   ├── styles/
│   │   └── theme.ts                 # Centralized HSL color tokens
│   │
│   ├── App.tsx                      # Root — QueryClient + Router + checkSession
│   ├── router.tsx                   # Route definitions (RequireAuth wrapper)
│   └── index.css                    # Tailwind + CSS variables
│
├── Dockerfile.prod                  # Multi-stage Docker build
├── tailwind.config.ts               # Tailwind config with CSS variable colors
├── vite.config.ts                   # Vite config with BFF proxy
└── .env.example                     # Environment variable template
```

---

## BFF Server

The BFF (Backend For Frontend) server lives in `DiasUI/server/` and serves three purposes:

### 1. Static File Serving (production)
In production, the BFF serves the Vite-built static files from `../dist`. In development, Vite serves files directly and proxies `/api` and `/auth` to the BFF on port 4000.

### 2. Authentication & Session Management
- Uses `express-session` with signed cookies (`dias.sid`)
- Session stores the authenticated user object (id, username, email, roles, source)
- See [Authentication](#authentication) section for full details

### 3. API Proxy
- Forwards all `/api/*` requests to DiasRestApi
- Automatically attaches `X-API-KEY` header (server-side secret, never exposed to browser)
- Forwards correlation IDs for request tracing
- Strips `/api` prefix before forwarding

### Key Files

| File | Purpose |
|------|---------|
| `server/index.ts` | Express app setup, middleware, session config, static serving |
| `server/auth.ts` | Auth routes + `resolveUser()` shared function |
| `server/proxy.ts` | `http-proxy-middleware` config for `/api/*` → DiasRestApi |
| `server/config.ts` | Reads env vars: `DIAS_REST_API_URL`, `DIAS_REST_API_KEY`, `SESSION_SECRET`, etc. |

---

## Authentication

### Flow Overview

```
1. User visits any page
   └─ RequireAuth checks isAuthenticated (Zustand store)

2. If loading=true → spinner (checkSession in progress)
   If isAuthenticated=false → redirect to /login (saves original path)

3. Login page offers two methods:
   ├─ DEV:  Impersonation form (username input, no password)
   └─ PROD: Microsoft Entra ID button (placeholder)

4. Both methods call resolveUser(identifier) on the BFF:
   ├─ Queries RestApi: POST /Api/AccountInternal/GetAllUsers
   ├─ If found → extracts real roles from legacy user record
   ├─ If NOT found (dev only) → uses fallback dev roles
   └─ In production → rejects if user not found

5. Session user stored in httpOnly cookie (dias.sid):
   { id, username, email, roles[], source }

6. On success → redirect back to original page
```

### Session User Shape

```typescript
interface SessionUser {
  id: string;                              // User ID from legacy system
  username: string;                        // Username (e.g. "Anton.Kristensen")
  email: string;                           // Email address
  roles: string[];                         // Array of role names
  source: 'impersonation' | 'entra-id';   // How the user authenticated
}
```

### resolveUser() — Shared Lookup

Both impersonation and Entra ID use the same `resolveUser()` function in `server/auth.ts`. This ensures:
- Identical session shape regardless of login method
- Roles always come from the same source (legacy system)
- Production never creates fake sessions

### Frontend Auth Components

| Component | File | Purpose |
|-----------|------|---------|
| `RequireAuth` | `src/components/auth/RequireAuth.tsx` | Route guard wrapper |
| `useAuthStore` | `src/stores/auth.ts` | Zustand store: `checkSession`, `impersonate`, `logout`, `hasRole` |
| `LoginPage` | `src/pages/LoginPage.tsx` | Login UI with impersonation + Entra ID |
| `api.ts` | `src/lib/api.ts` | Axios with `withCredentials: true`, 401 → redirect |

### API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/auth/impersonate` | POST | Dev-only impersonation login |
| `/auth/login` | POST | Production Entra ID login (placeholder) |
| `/auth/me` | GET | Returns current session user or 401 |
| `/auth/logout` | POST | Destroys session, clears cookie |
| `/health` | GET | BFF health check |

---

## Shared Components

All reusable UI components live in `src/components/shared/` with a barrel export from `index.ts`.

### DataTable

```tsx
import { DataTable } from '@/components/shared';

<DataTable
  columns={columns}          // TanStack column definitions
  data={data}                // Current page data
  totalCount={totalCount}    // Total rows (for pagination)
  pageSize={20}              // Rows per page
  pageIndex={0}              // Current page (0-indexed)
  sorting={sorting}          // SortingState
  loading={isLoading}        // Show loading spinner
  onPaginationChange={...}   // Pagination callback
  onSortingChange={...}      // Sorting callback
  onRowClick={...}           // Row click handler
/>
```

### PageHeader

```tsx
<PageHeader
  titleKey="nav.students"     // i18n key for page title
  createPath="/students/create" // Optional create button path
  createLabel="common.create"   // Optional custom label
  actions={<button>...</button>} // Optional extra actions
/>
```

### SearchInput

```tsx
<SearchInput
  value={query}              // Controlled value (optional)
  placeholder="Search..."    // Placeholder text
  debounceMs={400}           // Debounce delay
  onSearch={(value) => ...}  // Callback after debounce
/>
```

### FormModal

```tsx
<FormModal
  open={isOpen}
  title="Create Student"
  loading={isSaving}
  submitLabel="common.save"
  onSubmit={handleSave}
  onClose={() => setOpen(false)}
  wide={false}               // Optional wider modal
>
  {/* Form fields go here */}
</FormModal>
```

### ConfirmDialog

```tsx
<ConfirmDialog
  open={isOpen}
  title="Delete Student"
  message="Are you sure?"
  variant="danger"           // 'danger' | 'default'
  loading={isDeleting}
  onConfirm={handleDelete}
  onCancel={() => setOpen(false)}
/>
```

### StatusBadge

```tsx
<StatusBadge
  label="Active"
  variant="success"          // 'default' | 'success' | 'warning' | 'destructive' | 'info' | 'muted'
/>
```

### LoadingState / EmptyState

```tsx
<LoadingState message="Loading students..." />
<EmptyState message="No students found" />
```

---

## Centralized Theme

Colors are defined in `src/styles/theme.ts` as HSL values and applied via CSS variables in `src/index.css`. Tailwind references these variables in `tailwind.config.ts`.

### Custom Status Colors

| Token | CSS Variable | Usage |
|-------|-------------|-------|
| `success` | `--success` | Green badges, positive states |
| `warning` | `--warning` | Amber badges, caution states |
| `info` | `--info` | Blue badges, informational states |

These are available as `bg-success`, `text-success`, `bg-warning`, etc. in Tailwind.

### Brand Colors

The DIAS brand uses a deep blue primary (`222 47% 11%` light / `213 31% 91%` dark) defined in the `:root` and `.dark` CSS selectors.

---

## Routing & Navigation

### Route Guard

All protected routes are wrapped in `RequireAuth`:

```
/login                → LoginPage (public)
/                     → RequireAuth
  └── AppLayout
      ├── /dashboard  → DashboardPage
      ├── /students   → StudentsPage (stub)
      ├── /schools    → SchoolsPage (stub)
      └── ...
```

### Navigation Config

Menu structure is defined in `src/config/navigation.ts` as an array of `NavItem` objects:

```typescript
interface NavItem {
  id: string;
  titleKey: string;         // i18n translation key
  path?: string;            // Route path
  icon?: LucideIcon;        // Sidebar icon
  requiredRole?: string;    // Role needed to see this item
  children?: NavItem[];     // Nested menu items
}
```

---

## API Layer

### Axios Configuration (`src/lib/api.ts`)

- Base URL: `/api` (proxied to DiasRestApi via BFF)
- `withCredentials: true` — sends session cookie
- 401 responses → redirect to `#/login`
- No client-side token storage

### React Query

Used for server-state management. Default config:

```typescript
{
  staleTime: 5 * 60 * 1000,   // 5 minutes
  retry: 1,
  refetchOnWindowFocus: false,
}
```

---

## Build & Deployment

### Local Development

```bash
# Terminal 1: BFF server
cd DiasUI/server && npm install && npx tsx watch index.ts

# Terminal 2: Vite dev server
cd DiasUI && npm install && npm run dev
```

Vite proxies `/api` and `/auth` to BFF on port 4000.

### Production Build

```bash
cd DiasUI
npm run build           # Builds frontend → dist/
cd server && npm run build  # Builds BFF → server/dist/
```

### Docker

`Dockerfile.prod` uses a 3-stage build:

1. **build-frontend** — `npm ci && npm run build` (Vite)
2. **build-bff** — `npm ci && npx tsc` (server TypeScript)
3. **final** — Alpine Node.js, copies both outputs, runs BFF

```bash
docker build -f Dockerfile.prod -t dias-ui .
docker run -p 3000:3000 -e DIAS_REST_API_URL=http://rest-api:8080 dias-ui
```

### CI/CD Pipeline

1. Push to `main` → triggers `.github/workflows/build-and-deploy.yml`
2. Builds Docker image → pushes to `ghcr.io/larstrustworks/dias-ui:latest`
3. Triggers `deploy.yml` in `dias-stack-deployment` repo
4. Self-hosted runner pulls new image → `docker compose up -d`

---

## Environment Variables

### BFF Server

| Variable | Default | Description |
|----------|---------|-------------|
| `BFF_PORT` | `4000` (dev) / `3000` (prod) | Port the BFF listens on |
| `DIAS_REST_API_URL` | `http://localhost:9090` | DiasRestApi base URL |
| `DIAS_REST_API_KEY` | — | API key sent as `X-API-KEY` header |
| `SESSION_SECRET` | `dev-secret-change-me` | Cookie signing secret |
| `STATIC_DIR` | `../dist` | Path to Vite build output |
| `NODE_ENV` | `development` | `production` or `development` |
| `ENTRA_TENANT_ID` | — | Microsoft Entra ID tenant (future) |
| `ENTRA_CLIENT_ID` | — | Microsoft Entra ID client (future) |
| `ENTRA_CLIENT_SECRET` | — | Microsoft Entra ID secret (future) |

### Server `.env` (10.200.250.5)

Located at `/home/dekra/dias-stack/.env`:

```env
DIAS_REST_API_URL=http://rest-api:8080
DIAS_REST_API_KEY=<same as API_KEY>
SESSION_SECRET=<secure random string>
BFF_PORT=3000
```
