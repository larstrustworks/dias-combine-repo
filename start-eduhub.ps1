# Start DiasUI locally (React + Express proxy)
# Depends on RestApi running on http://localhost:8081

Write-Host "Starting DiasUI on http://localhost:5174..." -ForegroundColor Green
Write-Host "Make sure RestApi is running on http://localhost:8081" -ForegroundColor Yellow
Write-Host ""

Set-Location "$PSScriptRoot\DiasUI"

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Cyan
    npm install
}

# Run dev server
npm run dev
