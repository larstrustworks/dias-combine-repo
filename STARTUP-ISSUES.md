# DIAS Local Development - Startup Issues

## DiasDalApi - Status: ❌ FAILED

### Critical Issues

#### 1. Database Authentication Failure ⚠️ CRITICAL
**Error**: `SqlException Error 1326` - "Brugernavnet eller adgangskoden er forkert" (Username or password is incorrect)

**Details**:
- Server: `10.200.250.41` (via VPN)
- User: `dias4`
- Password: `Sommer2025!`
- Databases: Dias, Users, Certificates, Documents

**Root Cause**:
SQL Server port 1433 is **blocked/not accessible** from your computer to `10.200.250.41`.

**Test Results**:
- ✅ Server is reachable (ping succeeds, RTT: 13ms)
- ✅ RDP works (port 3389)
- ❌ SQL Server port 1433 is **BLOCKED** (`TcpTestSucceeded: False`)
- ✅ Credentials are correct (dias4 / Sommer2025!)

**Solution Options**:
1. **Request firewall access** (RECOMMENDED) - Contact network/DB admin to:
   - Allow SQL Server port 1433 from your IP (`172.16.0.1`) to `10.200.250.41`
   - Add your computer to SQL Server firewall whitelist
   
2. **Check VPN routing** - Verify VPN routes SQL traffic (not just RDP)
   
3. **Alternative SQL endpoint** - Ask if there's a different:
   - Port number for SQL Server
   - VPN-specific SQL endpoint
   - Azure SQL Database connection string
   
4. **Local SQL Server** - Install SQL Server locally and use `localhost` (requires database schemas/data)

**Impact**: 
- DiasDalApi cannot start without database access
- All other services (RestApi, AdminUI, EduHub) depend on DalApi
- **BLOCKS ALL LOCAL DEVELOPMENT**

---

### Secondary Issues

#### 2. Application Shutdown After Database Failure
**Status**: Expected behavior - app shuts down when critical dependency (database) is unavailable

**Log Evidence**:
```
[19:08:12 ERR] An error occurred using the connection to database 'Dias' on server '10.200.250.41'.
[19:08:12 ERR] An error occurred using the connection to database 'Users' on server '10.200.250.41'.
[19:08:12 ERR] An error occurred using the connection to database 'Certificates' on server '10.200.250.41'.
[19:08:12 ERR] An error occurred using the connection to database 'Documents' on server '10.200.250.41'.
...
[19:08:47 INF] Application is shutting down...
```

---

## Next Steps

### Immediate Actions Required:
1. ✅ **Verify VPN connection** to `10.200.250.41`
2. ⚠️ **Test database credentials** using SQL client
3. ⚠️ **Update appsettings.Development.json** if credentials are wrong
4. ⚠️ **Restart DiasDalApi** after fixing credentials

### Testing Order:
Once DiasDalApi is fixed:
1. Test DiasDalApi (port 8082)
2. Test RestApi (port 8081) - depends on DalApi
3. Test AdminUI (port 3001) - depends on RestApi
4. Test EduHub (port 5174) - depends on RestApi

---

## Configuration Files to Check

### Database Connection Strings:
- **Primary**: `DiasDalApi\dotnet_version\src\DiasDalApi\appsettings.Development.json`
  - Lines 47-50: Connection strings for all 4 databases

### Environment Variables:
- `.env.development` - Contains Docker-specific config (not used for local non-container runs)

---

## Questions to Answer:

1. **Are you connected to VPN?** (Required to access 10.200.250.41)
2. **Do you have the correct database credentials?** (Contact DB admin if unsure)
3. **Does the `dias4` user exist on the SQL Server?**
4. **Does `dias4` have permissions on all 4 databases?** (Dias, Users, Certificates, Documents)

---

## Status Summary

| Service    | Status | Port | Blocker                          |
|------------|--------|------|----------------------------------|
| DiasDalApi | ⚠️     | 8082 | Schema validation fails - needs DDL files |
| RestApi    | ⏸️     | 8081 | Waiting for DalApi               |
| AdminUI    | ⏸️     | 3001 | Waiting for RestApi              |
| EduHub     | ⏸️     | 5174 | Waiting for RestApi              |

**Overall Status**: 🟡 **PROGRESS** - Database connects, but schema validation fails

### Latest Update (20:10)
✅ **Local SQL Server running** in Docker
✅ **Database connections working** - all 4 databases connect successfully
✅ **appsettings.Local.json** created and loaded
❌ **Schema validation fails** - DDL files not found, app shuts down

**Current Error**:
```
Schema validation error for Dias: MissingTable - DDL file not found: database-schemas\dias.sql
Schema validation error for Users: MissingTable - DDL file not found: database-schemas\users.sql
Schema validation error for Certificates: MissingTable - DDL file not found: database-schemas\Certificates.sql
Schema validation error for Documents: MissingTable - DDL file not found: database-schemas\Documents.sql
```

**Next Step**: Copy database schema files to the correct location or disable schema validation
