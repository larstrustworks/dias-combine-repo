# Setup Local SQL Server for DIAS Development
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DIAS Local Database Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker
Write-Host "Checking Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "Docker not found!" -ForegroundColor Red
    exit 1
}

# Clean up existing container
Write-Host ""
Write-Host "Cleaning up..." -ForegroundColor Yellow
docker stop sqlserver_local 2>$null
docker rm sqlserver_local 2>$null

# Start SQL Server
Write-Host ""
Write-Host "Starting SQL Server..." -ForegroundColor Cyan
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=DevPassword123!" -p 1433:1433 --name sqlserver_local -d mcr.microsoft.com/mssql/server:2022-latest

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to start container" -ForegroundColor Red
    exit 1
}

Write-Host "SQL Server started" -ForegroundColor Green
Write-Host ""
Write-Host "Waiting for SQL Server to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Test connection
$connected = $false
$attempt = 0
while ($attempt -lt 10 -and -not $connected) {
    $attempt++
    try {
        $conn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1433;User Id=sa;Password=DevPassword123!;TrustServerCertificate=true;Connection Timeout=5;")
        $conn.Open()
        $connected = $true
        $conn.Close()
        Write-Host "SQL Server is ready!" -ForegroundColor Green
    } catch {
        Write-Host "Waiting... attempt $attempt" -ForegroundColor Gray
        Start-Sleep -Seconds 3
    }
}

if (-not $connected) {
    Write-Host "Failed to connect" -ForegroundColor Red
    exit 1
}

# Create databases
Write-Host ""
Write-Host "Creating databases..." -ForegroundColor Cyan
$databases = @("Dias", "Users", "Certificates", "Documents")
$connStr = "Server=localhost,1433;User Id=sa;Password=DevPassword123!;TrustServerCertificate=true;"

foreach ($db in $databases) {
    Write-Host "Creating $db..." -ForegroundColor Yellow
    try {
        $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
        $conn.Open()
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'$db') CREATE DATABASE [$db]"
        $cmd.ExecuteNonQuery() | Out-Null
        $conn.Close()
        Write-Host "Database $db created" -ForegroundColor Green
    } catch {
        Write-Host "Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Create user
Write-Host ""
Write-Host "Creating dias4 user..." -ForegroundColor Cyan
try {
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'dias4') CREATE LOGIN dias4 WITH PASSWORD = 'Sommer2025!'"
    $cmd.ExecuteNonQuery() | Out-Null
    
    foreach ($db in $databases) {
        $cmd.CommandText = "USE [$db]; IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'dias4') BEGIN CREATE USER dias4 FOR LOGIN dias4; ALTER ROLE db_owner ADD MEMBER dias4; END"
        $cmd.ExecuteNonQuery() | Out-Null
    }
    
    $conn.Close()
    Write-Host "User dias4 created with permissions" -ForegroundColor Green
} catch {
    Write-Host "Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Connection: localhost,1433" -ForegroundColor Cyan
Write-Host "User: dias4" -ForegroundColor Cyan
Write-Host "Password: Sommer2025!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: Run ./update-connection-strings.ps1" -ForegroundColor Yellow
Write-Host ""
