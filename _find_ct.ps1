$ErrorActionPreference = 'SilentlyContinue'
$candidates = @(
  "$env:USERPROFILE\CloudTAK",
  "$env:CLOUDTAK",
  "$env:USERPROFILE\Documents\CloudTAK",
  "$env:USERPROFILE\source\CloudTAK",
  "$env:USERPROFILE\repos\CloudTAK",
  "$env:USERPROFILE\dev\CloudTAK",
  "$env:USERPROFILE\code\CloudTAK",
  "C:\CloudTAK",
  "D:\CloudTAK"
)
$docs = Join-Path $env:USERPROFILE 'OneDrive - Hamilton County Sheriff''s Office\Documents'
$candidates += (Join-Path $docs 'CloudTAK')
$candidates += (Join-Path $docs 'VS Code Projects\CloudTAK')
$vs = Join-Path $docs 'VS Code Projects'
if (Test-Path -LiteralPath $vs) {
  Get-ChildItem -LiteralPath $vs -Directory | ForEach-Object { $_.FullName }
}
Write-Host '---CANDIDATES---'
foreach ($c in $candidates) {
  if (-not $c) { continue }
  $api = Join-Path $c 'api'
  $map = Join-Path $c 'api\web\src\stores\map.ts'
  $exists = Test-Path -LiteralPath $c
  $hasApi = Test-Path -LiteralPath $api
  $hasMap = Test-Path -LiteralPath $map
  Write-Host ("EXISTS={0} API={1} MAP={2} PATH={3}" -f $exists, $hasApi, $hasMap, $c)
}
Write-Host '---SEARCH HOME---'
Get-ChildItem -LiteralPath $env:USERPROFILE -Directory | ForEach-Object { $_.Name }
Write-Host '---SEARCH DOCS---'
if (Test-Path -LiteralPath $docs) {
  Get-ChildItem -LiteralPath $docs -Directory | ForEach-Object { $_.Name }
}
Write-Host '---WHERE GH---'
where.exe gh 2>$null
where.exe git 2>$null
