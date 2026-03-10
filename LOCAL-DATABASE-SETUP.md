# Local SQL Server Setup Guide

## Problem
Port 1433 to the remote SQL Server (10.200.250.41) is blocked from your computer.

## Solution
Run SQL Server locally in Docker.

---

## Prerequisites

- **Docker Desktop** must be installed
- Check with: `docker --version`

If Docker is not installed:
1. Download from: https://www.docker.com/products/docker-desktop
2. Install (may require admin approval)
3. Restart computer

---

## Setup Steps

### 1. Setup Local SQL Server

Run the setup script:

```powershell
./setup-local-database.ps1
```

This will:
- ✅ Start SQL Server 2022 in Docker (port 1433)
- ✅ Create 4 databases: Dias, Users, Certificates, Documents
- ✅ Create `dias4` user with password `Sommer2025!`
- ✅ Grant db_owner permissions on all databases

**Time**: ~30 seconds

### 2. Update Connection Strings

Run the update script:

```powershell
./update-connection-strings.ps1
```

This will:
- ✅ Update `appsettings.Development.json`
- ✅ Change server from `10.200.250.41` to `localhost,1433`
- ✅ Keep same credentials (dias4 / Sommer2025!)

### 3. Start DIAS Services

```powershell
./start-all.ps1
```

All services should now start successfully!

---

## What Gets Created

### Docker Container
- **Name**: `sqlserver_local`
- **Image**: `mcr.microsoft.com/mssql/server:2022-latest`
- **Port**: 1433 (localhost only)
- **SA Password**: `DevPassword123!`

### Databases
- `Dias` - Main application database
- `Users` - User management
- `Certificates` - Certificate data
- `Documents` - Document storage

### User Account
- **Username**: `dias4`
- **Password**: `Sommer2025!`
- **Permissions**: db_owner on all 4 databases

---

## Managing SQL Server

### Start SQL Server
```powershell
docker start sqlserver_local
```

### Stop SQL Server
```powershell
docker stop sqlserver_local
```

### View Logs
```powershell
docker logs sqlserver_local
```

### Connect with SQL Client
Use any SQL client (Azure Data Studio, SSMS, etc.):
- **Server**: `localhost,1433`
- **Authentication**: SQL Server Authentication
- **Username**: `dias4` or `sa`
- **Password**: `Sommer2025!` or `DevPassword123!`

### Remove Container (Clean Slate)
```powershell
docker rm -f sqlserver_local
# Then run setup-local-database.ps1 again
```

---

## Database Schemas

The database schemas are located in:
```
DiasDalApi/database-schemas/
├── dias.sql
├── users.sql
├── Certificates.sql
├── Documents.sql
└── seed-data/
    ├── dias-seed.sql
    ├── users-seed.sql
    ├── certificates-seed.sql
    └── documents-seed.sql
```

**Note**: The setup script creates empty databases. Schema and seed data will be applied automatically by DiasDalApi on first run (if migrations are enabled).

---

## Troubleshooting

### Docker not found
- Install Docker Desktop
- Make sure Docker Desktop is running (check system tray)

### Port 1433 already in use
```powershell
# Check what's using port 1433
Get-NetTCPConnection -LocalPort 1433

# Stop any existing SQL Server
docker stop sqlserver_local
# Or stop Windows SQL Server service
Stop-Service MSSQLSERVER
```

### Container won't start
```powershell
# Check Docker logs
docker logs sqlserver_local

# Remove and recreate
docker rm -f sqlserver_local
./setup-local-database.ps1
```

### Connection fails after setup
```powershell
# Test connection
$connectionString = "Server=localhost,1433;User Id=dias4;Password=Sommer2025!;TrustServerCertificate=true;"
$connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
$connection.Open()
Write-Host "Connected!"
$connection.Close()
```

---

## Switching Back to Remote Database

If you later get firewall access to 10.200.250.41:

1. Stop local SQL Server:
   ```powershell
   docker stop sqlserver_local
   ```

2. Manually edit `appsettings.Development.json`:
   - Change `localhost,1433` back to `10.200.250.41`

3. Restart services

---

## Notes

- **Data is persistent** - Stored in Docker volume, survives container restarts
- **No admin rights needed** - Docker runs in user space
- **Isolated environment** - Won't affect other SQL Server instances
- **Same credentials** - Uses same dias4/Sommer2025! as remote server
