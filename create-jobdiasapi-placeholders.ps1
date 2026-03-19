$csvPath = "Legacy/JobDiasApi/map/endpoints-list.csv"
$baseDir = "DiasRestApi/dotnet_version/src/Controllers/JobDiasApi"

# Read CSV
$lines = Get-Content $csvPath
$header = $lines[0]
$dataLines = $lines[1..($lines.Length - 1)]

$updatedLines = @()
$updatedLines += "$header;dias_controller_path;conversion_status"

foreach ($line in $dataLines) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    
    $parts = $line.Split(';')
    if ($parts.Length -lt 4) { continue }
    $key = $parts[0]
    $endpoint = $parts[1]
    $controller = $parts[2]
    $logic = $parts[3]
    
    # Parse method and path from endpoint
    $epParts = $endpoint.Split(' ', 2)
    $method = $epParts[0].ToLower()
    $path = $epParts[1].TrimStart('/')
    
    # Sanitize path - remove ? from optional params for folder names
    $sanitizedPath = $path.Replace('?', '')
    
    # Build folder path
    $folderPath = "$baseDir/$method/$sanitizedPath"
    
    # Create folder structure
    New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
    New-Item -ItemType Directory -Path "$folderPath/services" -Force | Out-Null
    New-Item -ItemType Directory -Path "$folderPath/models" -Force | Out-Null
    New-Item -ItemType Directory -Path "$folderPath/tests" -Force | Out-Null
    New-Item -ItemType Directory -Path "$folderPath/docs" -Force | Out-Null
    
    # Build legacy endpoint path for the route
    $legacyRoute = "/legacy/JobDiasApi/$sanitizedPath"
    
    # Build namespace from folder path
    $nsParts = $folderPath.Replace("DiasRestApi/dotnet_version/src/", "").Replace("/", ".").Replace("{", "_").Replace("}", "_")
    $nsName = "DiasRestApi.$nsParts"
    
    # Determine HTTP method attribute
    $httpAttr = switch ($method) {
        "get" { "HttpGet" }
        "post" { "HttpPost" }
        "put" { "HttpPut" }
        "delete" { "HttpDelete" }
        default { "HttpGet" }
    }
    
    # Create controller file
    $controllerContent = @"
/*
    This endpoint was created from legacy endpoint key: $key
*/

using Microsoft.AspNetCore.Mvc;

namespace $nsName
{
    [ApiController]
    public class NotImplementedHandlerController : ControllerBase
    {
        [$httpAttr("$legacyRoute")]
        public IActionResult Handle()
        {
            return StatusCode(501, "Not Implemented");
        }
    }
}
"@
    
    Set-Content -Path "$folderPath/notimplemented_handler_controller.cs" -Value $controllerContent
    
    $updatedLines += "$line;$folderPath;PLACEHOLDER_CREATED"
}

# Write updated CSV
Set-Content -Path $csvPath -Value ($updatedLines -join "`n")

Write-Host "Created placeholders for $($dataLines.Count) endpoints"
