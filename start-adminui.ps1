# Start DiasAdminUi locally (React + Express)
# Depends on RestApi running on http://localhost:8081

Write-Host "Starting DiasAdminUi on http://localhost:3001..." -ForegroundColor Green
Write-Host "Make sure RestApi is running on http://localhost:8081" -ForegroundColor Yellow
Write-Host ""

Set-Location "$PSScriptRoot\DiasAdminUi"

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Cyan
    npm install
}

# Run dev server (Vite + Express backend)
npm run dev
