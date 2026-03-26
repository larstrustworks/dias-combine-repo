param(
  [string]$TargetHost = "10.200.250.5",
  [int]$RestApiPort = 9090,
  [int]$DalApiPort = 8080,
  [int]$UiPort = 3000,
  [int]$TimeoutSeconds = 10
)

$targets = @(
  @{ Name = 'DiasRestApi'; Url = "http://$TargetHost`:$RestApiPort/version" },
  @{ Name = 'DiasDalApi'; Url = "http://$TargetHost`:$DalApiPort/version" },
  @{ Name = 'DiasUI'; Url = "http://$TargetHost`:$UiPort/version" }
)

function Resolve-Value {
  param(
    [Parameter(Mandatory = $false)]$Value,
    [Parameter(Mandatory = $true)][string]$Default
  )

  if ($null -eq $Value -or [string]::IsNullOrWhiteSpace([string]$Value)) {
    return $Default
  }

  return [string]$Value
}

Write-Output ("Checking service versions on host: {0}" -f $TargetHost)

foreach ($target in $targets) {
  try {
    $response = Invoke-RestMethod -Uri $target.Url -TimeoutSec $TimeoutSeconds -Method GET

    $version = $response.version
    if (-not $version -and $response.versionLabel) {
      $version = $response.versionLabel
    }

    $releaseVersion = $response.releaseVersion
    if (-not $releaseVersion) {
      $releaseVersion = $response.release_version
    }

    $buildNumber = $response.buildNumber
    if (-not $buildNumber) {
      $buildNumber = $response.build_number
    }

    $safeVersion = Resolve-Value -Value $version -Default 'n/a'
    $safeRelease = Resolve-Value -Value $releaseVersion -Default 'n/a'
    $safeBuild = Resolve-Value -Value $buildNumber -Default 'n/a'

    Write-Output ("{0} | OK | version={1} | release={2} | build={3}" -f $target.Name, $safeVersion, $safeRelease, $safeBuild)
  }
  catch {
    $status = $null
    if ($_.Exception.Response) {
      $status = [int]$_.Exception.Response.StatusCode
    }
    $safeStatus = Resolve-Value -Value $status -Default 'n/a'
    Write-Output ("{0} | ERROR | status={1} | url={2} | message={3}" -f $target.Name, $safeStatus, $target.Url, $_.Exception.Message)
  }
}
