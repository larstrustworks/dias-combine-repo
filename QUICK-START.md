# DIAS Local Development - Quick Start

## First Time Setup

```powershell
# 1. Setup local SQL Server (requires Docker)
./setup-local-database.ps1

# 2. Update connection strings
./update-connection-strings.ps1

# 3. Start all services
./start-all.ps1
```

**Done!** All services should be running.

---

## Daily Usage

### Start Everything
```powershell
./start-all.ps1
```

### Stop Everything
```powershell
./stop-all.ps1
```

---

## Service URLs

| Service  | URL                       | Purpose                    |
|----------|---------------------------|----------------------------|
| DalApi   | http://localhost:8082     | Database API layer         |
| RestApi  | http://localhost:8081     | REST API                   |
| AdminUI  | http://localhost:3001     | Admin interface            |
| EduHub   | http://localhost:5174     | Education hub              |

---

## Prerequisites

- ✅ VPN connected (for remote database)
- ✅ .NET 9 SDK installed
- ✅ Node.js 20+ installed
- ✅ Docker Desktop (for local SQL Server)

---

## Troubleshooting

### Services won't start
```powershell
# Check if ports are in use
./stop-all.ps1

# Try again
./start-all.ps1
```

### Database connection fails
```powershell
# Check SQL Server is running
docker ps | Select-String sqlserver_local

# Start if stopped
docker start sqlserver_local
```

### Need to reset everything
```powershell
# Stop all services
./stop-all.ps1

# Remove SQL Server
docker rm -f sqlserver_local

# Start fresh
./setup-local-database.ps1
./update-connection-strings.ps1
./start-all.ps1
```

---

## Useful Commands

```powershell
# Check Docker status
docker ps

# View SQL Server logs
docker logs sqlserver_local

# Connect to SQL Server
# Server: localhost,1433
# User: dias4
# Password: Sommer2025!
```

---

## Documentation

- **LOCAL-DATABASE-SETUP.md** - Detailed database setup guide
- **PORTS.md** - Port configuration details
- **STARTUP-ISSUES.md** - Known issues and solutions
