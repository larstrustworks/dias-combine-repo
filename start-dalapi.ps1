# Start DiasDalApi locally
# Connects to MSSQL server at 10.200.250.41 via VPN

Write-Host "Starting DiasDalApi on http://localhost:8082..." -ForegroundColor Green
Write-Host "Database: 10.200.250.41 (VPN required)" -ForegroundColor Yellow
Write-Host ""

Set-Location "$PSScriptRoot\DiasDalApi\dotnet_version"
$env:ASPNETCORE_ENVIRONMENT = "Development"
$env:ASPNETCORE_URLS = "http://localhost:8082"

Write-Host "Environment: $env:ASPNETCORE_ENVIRONMENT" -ForegroundColor Gray
Write-Host "URL Override: $env:ASPNETCORE_URLS" -ForegroundColor Gray
Write-Host "" 

dotnet run --no-launch-profile --project src/DiasDalApi/DiasDalApi.csproj
