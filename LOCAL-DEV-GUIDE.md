# DIAS Stack - Local Development Guide

## Prerequisites

- **VPN Connection**: Required to access MSSQL Server at `10.200.241.41`
- **.NET 9 SDK**: For DalApi and RestApi
- **Node.js 20+**: For AdminUI and EduHub
- **Git**: Already configured

## Database Configuration

All services connect to the shared MSSQL server via VPN:
- **Server**: `10.200.241.41`
- **User**: `dias4`
- **Password**: `Sommer2025!`
- **Databases**: `Dias`, `Users`, `Certificates`, `Documents`

## Service Architecture

```
┌─────────────┐
│  AdminUI    │ :3001 ──┐
└─────────────┘         │
                        ├──> ┌─────────────┐      ┌─────────────┐      ┌─────────────┐
┌─────────────┐         │    │  RestApi    │ :8081│   DalApi    │ :8082│   MSSQL     │
│  EduHub     │ :5174 ──┘    │             │─────>│             │─────>│ 10.200.241  │
└─────────────┘              └─────────────┘      └─────────────┘      └─────────────┘
```

## Quick Start

### Option 1: Start All Services Together

```powershell
cd c:\Users\A246428\dias
.\start-all.ps1
```

This opens 4 PowerShell windows, one for each service. Services start in dependency order:
1. DalApi (database layer)
2. RestApi (business logic)
3. AdminUI (admin interface)
4. EduHub (education hub)

### Option 2: Start Services Individually

Open separate PowerShell terminals and run:

```powershell
# Terminal 1 - DalApi (start first)
cd c:\Users\A246428\dias
.\start-dalapi.ps1

# Terminal 2 - RestApi (wait for DalApi to be ready)
cd c:\Users\A246428\dias
.\start-restapi.ps1

# Terminal 3 - AdminUI (wait for RestApi to be ready)
cd c:\Users\A246428\dias
.\start-adminui.ps1

# Terminal 4 - EduHub (wait for RestApi to be ready)
cd c:\Users\A246428\dias
.\start-eduhub.ps1
```

## Service URLs

| Service | URL | Description |
|---------|-----|-------------|
| **DalApi** | http://localhost:8082 | Data Access Layer - connects to MSSQL |
| **RestApi** | http://localhost:8081 | REST API - business logic |
| **AdminUI** | http://localhost:3001 | Admin interface (React + Express) |
| **EduHub** | http://localhost:5174 | Education hub (React + Express) |

## Configuration Files

### .NET Services (DalApi, RestApi)
- `appsettings.Development.json` - Development configuration (already configured for VPN MSSQL)
- Connection strings point to `10.200.241.41` with SQL authentication

### Node Services (AdminUI, EduHub)
- `.env.local` - Local environment variables (created, not in Git)
- Contains API URLs and keys for local development

## Troubleshooting

### DalApi fails to connect to database
- ✅ Verify VPN is connected
- ✅ Test connection: `Test-NetConnection -ComputerName 10.200.241.41 -Port 1433`
- ✅ Check credentials: `dias4` / `Sommer2025!`

### RestApi can't reach DalApi
- ✅ Ensure DalApi is running on http://localhost:8082
- ✅ Check DalApi terminal for errors

### AdminUI or EduHub can't reach RestApi
- ✅ Ensure RestApi is running on http://localhost:8081
- ✅ Check `.env.local` files have correct URLs

### Node dependencies missing
- Run `npm install` in the project directory:
  ```powershell
  cd DiasAdminUi
  npm install
  
  cd ..\dias-edu-hub
  npm install
  ```

### Port already in use
- Check what's using the port:
  ```powershell
  netstat -ano | findstr :8082  # or :8081, :3001, :5174
  ```
- Kill the process or change the port in startup scripts

## Development Workflow

1. **Connect VPN** (required for database access)
2. **Start services** using `start-all.ps1` or individual scripts
3. **Develop** - make code changes
4. **Hot reload** - Most services auto-reload on file changes:
   - .NET: Manual restart required (Ctrl+C, then re-run)
   - Node: Vite auto-reloads on save
5. **Test** - Access services via browser
6. **Stop** - Press Ctrl+C in each terminal window

## Next Steps: Deployment to Linux Server

Once local development is working, you can deploy to your Linux server:

1. **Push to GitHub** - Commit and push your changes
2. **GitHub Actions** - Automatically builds Docker images
3. **Self-hosted runner** - Deploys to your Ubuntu server
4. **Production** - Services run in Docker containers

See `DEV_DEPLOYMENT.md` for full deployment architecture.

## File Structure

```
c:\Users\A246428\dias\
├── start-all.ps1              # Start all services
├── start-dalapi.ps1           # Start DalApi only
├── start-restapi.ps1          # Start RestApi only
├── start-adminui.ps1          # Start AdminUI only
├── start-eduhub.ps1           # Start EduHub only
├── LOCAL-DEV-GUIDE.md         # This file
├── DEV_DEPLOYMENT.md          # Linux deployment guide
│
├── DiasDalApi/
│   └── dotnet_version/
│       └── src/DiasDalApi/
│           └── appsettings.Development.json  # VPN MSSQL config
│
├── DiasRestApi/
│   └── dotnet_version/
│       └── src/DiasRestApi/
│           └── appsettings.Development.json
│
├── DiasAdminUi/
│   └── .env.local             # Local API URLs (not in Git)
│
└── dias-edu-hub/
    └── .env.local             # Local API URLs (not in Git)
```

## Support

If you encounter issues:
1. Check the terminal output for error messages
2. Verify VPN connection
3. Ensure all prerequisites are installed
4. Review this guide's troubleshooting section
