# Copy database schemas to the correct location for DiasDalApi
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Copy Database Schemas" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$sourceDir = "$PSScriptRoot\DiasDalApi\database-schemas"
$targetDir = "$PSScriptRoot\DiasDalApi\dotnet_version\src\DiasDalApi\database-schemas"

if (-not (Test-Path $sourceDir)) {
    Write-Host "Source directory not found: $sourceDir" -ForegroundColor Red
    exit 1
}

Write-Host "Copying schemas from:" -ForegroundColor Yellow
Write-Host "  $sourceDir" -ForegroundColor Gray
Write-Host "To:" -ForegroundColor Yellow
Write-Host "  $targetDir" -ForegroundColor Gray
Write-Host ""

# Create target directory if it doesn't exist
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    Write-Host "Created target directory" -ForegroundColor Green
}

# Copy all schema files
Copy-Item -Path "$sourceDir\*" -Destination $targetDir -Recurse -Force

Write-Host ""
Write-Host "Schema files copied successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Files copied:" -ForegroundColor Cyan
Get-ChildItem $targetDir -Recurse -File | ForEach-Object {
    Write-Host "  $($_.Name)" -ForegroundColor White
}

Write-Host ""
Write-Host "Ready to start DalApi!" -ForegroundColor Yellow
Write-Host ""
