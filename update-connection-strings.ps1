# Create local config override
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Update Connection Strings" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$localPath = "$PSScriptRoot\DiasDalApi\dotnet_version\src\DiasDalApi\appsettings.Local.json"

Write-Host "Creating appsettings.Local.json..." -ForegroundColor Yellow
Write-Host "(This file is git-ignored)" -ForegroundColor Gray
Write-Host ""

$config = @{
    DatabaseConfiguration = @{
        ConnectionStrings = @{
            DiasConnection = "Server=localhost,1433;Database=Dias;User Id=dias4;Password=Sommer2025!;TrustServerCertificate=true;"
            UsersConnection = "Server=localhost,1433;Database=Users;User Id=dias4;Password=Sommer2025!;TrustServerCertificate=true;"
            CertificatesConnection = "Server=localhost,1433;Database=Certificates;User Id=dias4;Password=Sommer2025!;TrustServerCertificate=true;"
            DocumentsConnection = "Server=localhost,1433;Database=Documents;User Id=dias4;Password=Sommer2025!;TrustServerCertificate=true;"
        }
    }
    SchemaManagement = @{
        EnableSchemaValidation = $false
        EnableSeeding = $false
    }
}

$config | ConvertTo-Json -Depth 10 | Set-Content $localPath

Write-Host "Local config created!" -ForegroundColor Green
Write-Host ""
Write-Host "Connection strings now point to localhost:1433" -ForegroundColor Cyan
Write-Host "Schema validation: DISABLED (for local dev)" -ForegroundColor Gray
Write-Host "Original appsettings.Development.json unchanged" -ForegroundColor Gray
Write-Host ""
Write-Host "Ready to start! Run: ./start-dalapi.ps1" -ForegroundColor Yellow
Write-Host ""
