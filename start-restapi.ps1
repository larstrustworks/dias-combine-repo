# Start DiasRestApi locally
# Depends on DalApi running on http://localhost:8082

Write-Host "Starting DiasRestApi on http://localhost:8081..." -ForegroundColor Green
Write-Host "Make sure DalApi is running on http://localhost:8082" -ForegroundColor Yellow
Write-Host ""

Set-Location "$PSScriptRoot\DiasRestApi\dotnet_version"
$env:ASPNETCORE_ENVIRONMENT = "Development"
$env:ASPNETCORE_URLS = "http://localhost:8081"
$env:DalApiUrl = "http://localhost:8082"

dotnet run --project src/DiasRestApi/DiasRestApi.csproj
