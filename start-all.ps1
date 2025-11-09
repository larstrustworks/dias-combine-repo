# Start all DIAS services locally
# Opens each service in a new PowerShell window

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting DIAS Stack - Local Dev" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Prerequisites:" -ForegroundColor Yellow
Write-Host "  - VPN connected to access MSSQL (10.200.241.41)" -ForegroundColor Yellow
Write-Host "  - .NET 9 SDK installed" -ForegroundColor Yellow
Write-Host "  - Node.js 20+ installed" -ForegroundColor Yellow
Write-Host ""
Write-Host "Services will start in this order:" -ForegroundColor Green
Write-Host "  1. DalApi      -> http://localhost:8082" -ForegroundColor White
Write-Host "  2. RestApi     -> http://localhost:8081" -ForegroundColor White
Write-Host "  3. AdminUI     -> http://localhost:3001" -ForegroundColor White
Write-Host "  4. EduHub      -> http://localhost:5174" -ForegroundColor White
Write-Host ""

# Start DalApi first (database layer)
Write-Host "Starting DalApi..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-File", "$PSScriptRoot\start-dalapi.ps1"
Start-Sleep -Seconds 5

# Start RestApi (depends on DalApi)
Write-Host "Starting RestApi..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-File", "$PSScriptRoot\start-restapi.ps1"
Start-Sleep -Seconds 5

# Start AdminUI (depends on RestApi)
Write-Host "Starting AdminUI..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-File", "$PSScriptRoot\start-adminui.ps1"
Start-Sleep -Seconds 3

# Start EduHub (depends on RestApi)
Write-Host "Starting EduHub..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-File", "$PSScriptRoot\start-eduhub.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  All services starting!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Check each window for startup status." -ForegroundColor White
Write-Host "Press Ctrl+C in each window to stop services." -ForegroundColor White
