# Stop all DIAS services running locally
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Stopping DIAS Stack - Local Dev" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Stop EduHub (port 5174)
Write-Host "Stopping EduHub (port 5174)..." -ForegroundColor Yellow
$connection = Get-NetTCPConnection -LocalPort 5174 -ErrorAction SilentlyContinue
if ($connection) {
    $processId = $connection.OwningProcess
    Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
    Write-Host "  Stopped EduHub" -ForegroundColor Green
} else {
    Write-Host "  EduHub not running" -ForegroundColor Gray
}

# Stop AdminUI (port 3001)
Write-Host "Stopping AdminUI (port 3001)..." -ForegroundColor Yellow
$connection = Get-NetTCPConnection -LocalPort 3001 -ErrorAction SilentlyContinue
if ($connection) {
    $processId = $connection.OwningProcess
    Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
    Write-Host "  Stopped AdminUI" -ForegroundColor Green
} else {
    Write-Host "  AdminUI not running" -ForegroundColor Gray
}

# Stop RestApi (port 8081)
Write-Host "Stopping RestApi (port 8081)..." -ForegroundColor Yellow
$connection = Get-NetTCPConnection -LocalPort 8081 -ErrorAction SilentlyContinue
if ($connection) {
    $processId = $connection.OwningProcess
    Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
    Write-Host "  Stopped RestApi" -ForegroundColor Green
} else {
    Write-Host "  RestApi not running" -ForegroundColor Gray
}

# Stop DalApi (port 8082)
Write-Host "Stopping DalApi (port 8082)..." -ForegroundColor Yellow
$connection = Get-NetTCPConnection -LocalPort 8082 -ErrorAction SilentlyContinue
if ($connection) {
    $processId = $connection.OwningProcess
    Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
    Write-Host "  Stopped DalApi" -ForegroundColor Green
} else {
    Write-Host "  DalApi not running" -ForegroundColor Gray
}

Write-Host ""
Write-Host "All services stopped!" -ForegroundColor Green
