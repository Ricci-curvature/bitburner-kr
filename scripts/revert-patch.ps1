param(
  [Parameter(Mandatory = $true)]
  [string]$PatchId,
  [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$StatePath = Join-Path $ProjectRoot "patches\patch-state.json"
$BackupRoot = Join-Path $ProjectRoot "backups"

function Get-Sha256([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) { return $null }
  return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Load-State() {
  if (-not (Test-Path -LiteralPath $StatePath)) { throw "State file not found: $StatePath" }
  $raw = Get-Content -Raw -LiteralPath $StatePath
  if ([string]::IsNullOrWhiteSpace($raw)) { return @() }
  return @(($raw | ConvertFrom-Json))
}

function Save-State([array]$Entries) {
  $Entries | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $StatePath -Encoding UTF8
}

$state = Load-State
$candidates = @($state | Where-Object { $_.patchId -eq $PatchId -and $_.status -in @("applied", "already-applied") })
if ($candidates.Count -eq 0) { throw "No applied state entries found for patchId: $PatchId" }

$latestTime = ($candidates | Sort-Object appliedAt -Descending | Select-Object -First 1).appliedAt
$entries = @($candidates | Where-Object { $_.appliedAt -eq $latestTime })

Write-Host "Patch : $PatchId"
Write-Host "Mode  : $(if ($Apply) { 'APPLY' } else { 'DRY-RUN' })"
Write-Host "Entries: $($entries.Count)"

foreach ($entry in $entries) {
  if ($entry.status -eq "already-applied") {
    Write-Host "[skip] already-applied state has no backup: $($entry.targetPath)"
    continue
  }
  $existedBefore = $true
  if ($entry.PSObject.Properties.Name -contains "existedBefore") { $existedBefore = [bool]$entry.existedBefore }
  if ($existedBefore) {
    if ($null -eq $entry.backupPath -or -not (Test-Path -LiteralPath ([string]$entry.backupPath))) {
      throw "Backup missing for $($entry.targetPath): $($entry.backupPath)"
    }
    Write-Host "[will-revert] $($entry.targetPath) <- $($entry.backupPath)"
  } else {
    Write-Host "[will-remove] $($entry.targetPath) did not exist before apply"
  }
}

if (-not $Apply) {
  Write-Host "Dry-run complete. No files changed. Use -Apply to restore backups."
  exit 0
}

$timestamp = (Get-Date).ToString("yyyy-MM-ddTHH-mm-ss-fff")
foreach ($entry in $entries) {
  if ($entry.status -eq "already-applied") { continue }
  $target = [string]$entry.targetPath
  $preRevertBackup = Join-Path $BackupRoot (([IO.Path]::GetFileName($target)) + ".before-revert-$PatchId-$timestamp")
  if (Test-Path -LiteralPath $target) { Copy-Item -LiteralPath $target -Destination $preRevertBackup -Force }
  $existedBefore = $true
  if ($entry.PSObject.Properties.Name -contains "existedBefore") { $existedBefore = [bool]$entry.existedBefore }
  if ($existedBefore) {
    Copy-Item -LiteralPath ([string]$entry.backupPath) -Destination $target -Force
  } elseif (Test-Path -LiteralPath $target) {
    Remove-Item -LiteralPath $target -Force
  }
  $entry.status = "reverted"
  $entry | Add-Member -NotePropertyName revertedAt -NotePropertyValue (Get-Date).ToString("o") -Force
  $entry | Add-Member -NotePropertyName preRevertBackupPath -NotePropertyValue $preRevertBackup -Force
  $entry | Add-Member -NotePropertyName targetHashAfterRevert -NotePropertyValue (Get-Sha256 $target) -Force
}

Save-State $state
Write-Host "Revert complete. State updated: $StatePath"
