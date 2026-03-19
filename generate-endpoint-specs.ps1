#!/usr/bin/env pwsh
# Generate ENDPOINT_SPEC.md files for all JobDiasApi endpoints
# Skips Account and AccountInternal controllers (already done)

$csvPath = "Legacy/JobDiasApi/map/endpoints-list.csv"
$csv = Get-Content $csvPath -Raw
$lines = $csv -split "`n" | Where-Object { $_.Trim() -ne "" }
$header = $lines[0]
$dataLines = $lines[1..($lines.Length - 1)]

# Controller metadata for generating accurate specs
$controllerMeta = @{
