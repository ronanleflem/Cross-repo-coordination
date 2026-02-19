param(
  [string]$InitId
)

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $scriptDir
$repos = Get-Content "$root\config\repos.json" -Raw | ConvertFrom-Json

$targets = @(
  @{ Name='angular'; Path=$repos.angular },
  @{ Name='spring'; Path=$repos.spring },
  @{ Name='python'; Path=$repos.python }
)

$requiredPatterns = @(
  '## BMAD Stage',
  'Cross-Repo Initiative',
  'Upstream Dependencies',
  'Contract Version',
  'Context7 Decision'
)

$errors = @()

foreach ($t in $targets) {
  $dir = Join-Path $t.Path 'tickets\active'
  if (-not (Test-Path $dir)) { continue }

  $files = Get-ChildItem $dir -File -Filter *.md
  if ($InitId) { $files = $files | Where-Object { $_.Name -like "$InitId*" } }

  foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    foreach ($p in $requiredPatterns) {
      if ($content -notmatch [regex]::Escape($p)) {
        $errors += "[$($t.Name)] Missing '$p' in $($f.FullName)"
      }
    }
  }
}

if ($errors.Count -gt 0) {
  Write-Output 'Validation FAILED:'
  $errors | ForEach-Object { Write-Output "- $_" }
  exit 1
}

Write-Output 'Validation OK: required metadata found in scanned tickets.'
