# DIAS — Combined Projects Monorepo

> Driving Instruction Administration System — DEKRA Denmark

## Repositories

| Repo | Description | Tech | Port (dev) |
|------|-------------|------|------------|
| `DiasUI/` | New React frontend + BFF server | React 18, Express, TypeScript | 5173 (Vite) + 4000 (BFF) |
| `DiasRestApi/` | .NET REST API layer | .NET 9, C# | 9090 |
| `DiasDalApi/` | Node.js data access layer | Express, mssql | 8080 |
| `DiasAdminUi/` | Admin panel | React | 3001 |
| `Legacy/` | Legacy Angular UI + reference code | AngularJS | — |
| `dias-stack-deployment/` | Docker Compose + CI/CD | Docker, GitHub Actions | — |

## Documentation

| Document | Location | Content |
|----------|----------|---------|
| **DiasUI Architecture** | [`docs/DIASUI-ARCHITECTURE.md`](docs/DIASUI-ARCHITECTURE.md) | BFF server, auth flow, shared components, theme, routing, deployment |
| **Test Users & Roles** | [`docs/DIASUI-TEST-USERS.md`](docs/DIASUI-TEST-USERS.md) | Database roles, groups, test user list by role profile |
| **Local Database Setup** | [`LOCAL-DATABASE-SETUP.md`](LOCAL-DATABASE-SETUP.md) | SQL Server connection, schema setup |
| **Quick Start** | [`QUICK-START.md`](QUICK-START.md) | Getting the stack running locally |
| **Port Reference** | [`PORTS.md`](PORTS.md) | All service ports |
| **Startup Issues** | [`STARTUP-ISSUES.md`](STARTUP-ISSUES.md) | Common problems and solutions |

## Infrastructure

| Resource | Address | Notes |
|----------|---------|-------|
| SQL Server | `10.200.250.41:1433` | Database: `dias`, `users`, `DEKRAUsers` |
| Linux Server | `10.200.250.5` | Docker host for DIAS 4 stack |
| Windows Server | `10.200.250.31` | Legacy server |
| Container Registry | `ghcr.io/larstrustworks` | GitHub Container Registry |

## Quick Start

```bash
# Start everything locally
.\start-all.ps1

# Or start individual services
.\start-dalapi.ps1     # DiasDalApi on :8080
.\start-restapi.ps1    # DiasRestApi on :9090
.\start-eduhub.ps1     # DiasUI (Vite) on :5173 + BFF on :4000
.\start-adminui.ps1    # DiasAdminUi on :3001
.\stop-all.ps1         # Stop all services
```
