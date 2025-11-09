# Start DiasDalApi locally
# Connects to MSSQL server at 10.200.241.41 via VPN

Write-Host "Starting DiasDalApi on http://localhost:8082..." -ForegroundColor Green
Write-Host "Database: 10.200.241.41 (VPN required)" -ForegroundColor Yellow
Write-Host ""

Set-Location "$PSScriptRoot\DiasDalApi\dotnet_version"
$env:ASPNETCORE_ENVIRONMENT = "Development"
$env:ASPNETCORE_URLS = "http://localhost:8082"

dotnet run --project src/DiasDalApi/DiasDalApi.csproj
