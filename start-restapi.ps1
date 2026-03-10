# Start DiasRestApi locally
# Depends on DalApi running on http://localhost:8082

Write-Host "Starting DiasRestApi on http://localhost:8081..." -ForegroundColor Green
Write-Host "Make sure DalApi is running on http://localhost:8082" -ForegroundColor Yellow
Write-Host ""

Set-Location "$PSScriptRoot\DiasRestApi\dotnet_version"
$env:ASPNETCORE_ENVIRONMENT = "Development"
$env:ASPNETCORE_URLS = "http://localhost:8081"
$env:DalApiUrl = "http://localhost:8082"

Write-Host "Environment: $env:ASPNETCORE_ENVIRONMENT" -ForegroundColor Gray
Write-Host "URL Override: $env:ASPNETCORE_URLS" -ForegroundColor Gray
Write-Host "DalApi URL: $env:DalApiUrl" -ForegroundColor Gray
Write-Host ""

dotnet run --no-launch-profile --project src/DiasRestApi/DiasRestApi.csproj
