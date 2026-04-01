# Serve the latest Flutter web build (run build_web_preview.ps1 first).
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$web = Join-Path $root "build\web"
if (-not (Test-Path (Join-Path $web "index.html"))) {
  Write-Host "Missing build\web. Run .\build_web_preview.ps1 first." -ForegroundColor Red
  exit 1
}
$port = 8092
if ($args.Count -ge 1) { $port = [int]$args[0] }
Set-Location $web
Write-Host "Serving CarWale from: $web" -ForegroundColor Green
Write-Host "http://127.0.0.1:$port/iphone_preview.html" -ForegroundColor Cyan
python -m http.server $port
