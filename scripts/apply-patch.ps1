param(
  [Parameter(Mandatory = $true)]
  [string]$Patch,
  [string]$GameRoot = "D:\SteamLibrary\steamapps\common\Bitburner",
  [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$BackupRoot = Join-Path $ProjectRoot "backups"
$StatePath = Join-Path $ProjectRoot "patches\patch-state.json"

function Resolve-ProjectPath([string]$Path) {
  if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
  return [IO.Path]::GetFullPath((Join-Path $ProjectRoot $Path))
}

function Resolve-GamePath([string]$Path) {
  if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
  return [IO.Path]::GetFullPath((Join-Path $GameRoot $Path))
}

function Assert-UnderRoot([string]$Path, [string]$Root, [string]$Label) {
  $fullPath = [IO.Path]::GetFullPath($Path)
  $fullRoot = [IO.Path]::GetFullPath($Root).TrimEnd('\') + '\'
  if (-not $fullPath.StartsWith($fullRoot, [StringComparison]::OrdinalIgnoreCase)) {
    throw "$Label path is outside allowed root. Path: $fullPath Root: $fullRoot"
  }
}

function Get-Sha256([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) { return $null }
  return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Count-Literal([string]$Text, [string]$Needle) {
  if ([string]::IsNullOrEmpty($Needle)) { throw "Cannot count an empty string." }
  return [regex]::Matches($Text, [regex]::Escape($Needle)).Count
}

function Read-Utf8([string]$Path) {
  return [IO.File]::ReadAllText($Path)
}

function Write-Utf8NoBom([string]$Path, [string]$Text) {
  [IO.File]::WriteAllText($Path, $Text, [Text.UTF8Encoding]::new($false))
}

function Load-State() {
  if (-not (Test-Path -LiteralPath $StatePath)) { return @() }
  $raw = Get-Content -Raw -LiteralPath $StatePath
  if ([string]::IsNullOrWhiteSpace($raw)) { return @() }
  $parsed = $raw | ConvertFrom-Json
  if ($null -eq $parsed) { return @() }
  return @($parsed)
}

function Save-State([array]$Entries) {
  $dir = Split-Path -Parent $StatePath
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  $Entries | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $StatePath -Encoding UTF8
}

function Convert-LegacyPatch($PatchObject) {
  if ($PatchObject.PSObject.Properties.Name -contains "operations") {
    return @($PatchObject.operations)
  }

  if (($PatchObject.PSObject.Properties.Name -contains "target") -and ($PatchObject.PSObject.Properties.Name -contains "replacements")) {
    $ops = @()
    $i = 0
    foreach ($replacement in @($PatchObject.replacements)) {
      $i++
      $expected = 1
      if ($replacement.PSObject.Properties.Name -contains "expectedCount") { $expected = [int]$replacement.expectedCount }
      $allowRemaining = $false
      if ($replacement.PSObject.Properties.Name -contains "allowRemainingSource") { $allowRemaining = [bool]$replacement.allowRemainingSource }
      $ops += [pscustomobject]@{
        type = "replace"
        file = $PatchObject.target
        source = $replacement.from
        target = $replacement.to
        expectedCount = $expected
        allowRemainingSource = $allowRemaining
        allowExistingTarget = $true
        id = if ($replacement.PSObject.Properties.Name -contains "id") { $replacement.id } else { "replacement_$i" }
      }
    }
    return $ops
  }

  throw "Unsupported patch manifest shape. Expected operations[] or target/replacements."
}

$PatchPath = Resolve-ProjectPath $Patch
if (-not (Test-Path -LiteralPath $PatchPath)) { throw "Patch file not found: $PatchPath" }
Assert-UnderRoot $PatchPath $ProjectRoot "Patch"

$patchObject = Get-Content -Raw -LiteralPath $PatchPath | ConvertFrom-Json
$patchId = if ($patchObject.PSObject.Properties.Name -contains "patchId") { $patchObject.patchId } elseif ($patchObject.PSObject.Properties.Name -contains "id") { $patchObject.id } else { [IO.Path]::GetFileNameWithoutExtension($PatchPath) }
$gameVersion = if ($patchObject.PSObject.Properties.Name -contains "gameVersion") { $patchObject.gameVersion } else { $null }
$operations = Convert-LegacyPatch $patchObject

Write-Host "Patch: $patchId"
Write-Host "Mode : $(if ($Apply) { 'APPLY' } else { 'DRY-RUN' })"
Write-Host "Game : $GameRoot"
Write-Host "Ops  : $($operations.Count)"

New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null

$planned = @()
$contentByPath = @{}
$hashBeforeByPath = @{}
$failures = @()

foreach ($op in $operations) {
  $type = [string]$op.type
  switch ($type) {
    "copy" {
      $source = Resolve-ProjectPath ([string]$op.source)
      $target = Resolve-GamePath ([string]$op.target)
      Assert-UnderRoot $source $ProjectRoot "Copy source"
      Assert-UnderRoot $target $GameRoot "Copy target"
      if (-not (Test-Path -LiteralPath $source)) { $failures += "Copy source missing: $source"; continue }
      $sourceHash = Get-Sha256 $source
      $targetHash = Get-Sha256 $target
      $status = if ($targetHash -eq $sourceHash) { "already-applied" } else { "will-copy" }
      $planned += [pscustomobject]@{ type=$type; path=$target; sourcePath=$source; status=$status; beforeHash=$targetHash; afterHash=$sourceHash; existedBefore=(Test-Path -LiteralPath $target) }
      Write-Host "[$status] copy $source -> $target"
    }
    "insertBefore" {
      $path = Resolve-GamePath ([string]$op.file)
      Assert-UnderRoot $path $GameRoot "Target"
      if (-not (Test-Path -LiteralPath $path)) { $failures += "Target file missing: $path"; continue }
      if (-not $contentByPath.ContainsKey($path)) {
        $contentByPath[$path] = Read-Utf8 $path
        $hashBeforeByPath[$path] = Get-Sha256 $path
      }
      $text = [string]$contentByPath[$path]
      $targetContains = if ($op.PSObject.Properties.Name -contains "targetContains") { [string]$op.targetContains } else { $null }
      $allowExisting = ($op.PSObject.Properties.Name -contains "allowExistingTarget") -and [bool]$op.allowExistingTarget
      if ($allowExisting -and $targetContains -and $text.Contains($targetContains)) {
        $planned += [pscustomobject]@{ type=$type; path=$path; status="already-applied"; beforeHash=$hashBeforeByPath[$path]; afterHash=$hashBeforeByPath[$path]; existedBefore=$true }
        Write-Host "[already-applied] insertBefore $path contains '$targetContains'"
        continue
      }
      $anchor = [string]$op.anchor
      $expected = if ($op.PSObject.Properties.Name -contains "expectedCount") { [int]$op.expectedCount } else { 1 }
      $count = Count-Literal $text $anchor
      if ($count -ne $expected) { $failures += "insertBefore expectedCount mismatch for $path. Expected $expected, found $count."; continue }
      $newText = $text.Replace($anchor, ([string]$op.insert) + $anchor)
      $contentByPath[$path] = $newText
      $planned += [pscustomobject]@{ type=$type; path=$path; status="will-insert"; beforeHash=$hashBeforeByPath[$path]; afterHash=$null; existedBefore=$true }
      Write-Host "[will-insert] $path anchor matches: $count"
    }
    "replace" {
      $path = Resolve-GamePath ([string]$op.file)
      Assert-UnderRoot $path $GameRoot "Target"
      if (-not (Test-Path -LiteralPath $path)) { $failures += "Target file missing: $path"; continue }
      if (-not $contentByPath.ContainsKey($path)) {
        $contentByPath[$path] = Read-Utf8 $path
        $hashBeforeByPath[$path] = Get-Sha256 $path
      }
      $text = [string]$contentByPath[$path]
      $source = [string]$op.source
      $target = [string]$op.target
      $expected = if ($op.PSObject.Properties.Name -contains "expectedCount") { [int]$op.expectedCount } else { 1 }
      $allowExisting = ($op.PSObject.Properties.Name -contains "allowExistingTarget") -and [bool]$op.allowExistingTarget
      $sourceCount = Count-Literal $text $source
      $targetCount = Count-Literal $text $target
      if ($allowExisting -and $targetCount -gt 0) {
        $targetIncludesSource = $target.Contains($source)
        $looksAlreadyApplied = ($sourceCount -eq 0) -or ($targetIncludesSource -and $targetCount -eq $expected -and $sourceCount -eq $targetCount)
        if ($looksAlreadyApplied) {
          $planned += [pscustomobject]@{ type=$type; path=$path; status="already-applied"; sourceCount=$sourceCount; targetCount=$targetCount; beforeHash=$hashBeforeByPath[$path]; afterHash=$hashBeforeByPath[$path]; existedBefore=$true }
          Write-Host "[already-applied] replace $path targetCount=$targetCount"
          continue
        }
      }
      if ($sourceCount -ne $expected) { $failures += "replace expectedCount mismatch for $path. Expected $expected, found $sourceCount."; continue }
      $newText = $text.Replace($source, $target)
      $allowRemaining = ($op.PSObject.Properties.Name -contains "allowRemainingSource") -and [bool]$op.allowRemainingSource
      if (-not $allowRemaining -and (Count-Literal $newText $source) -gt 0) { $failures += "replace would leave source text in $path while allowRemainingSource=false."; continue }
      if ((Count-Literal $newText $target) -lt 1) { $failures += "replace target text not found after replacement in $path."; continue }
      $contentByPath[$path] = $newText
      $planned += [pscustomobject]@{ type=$type; path=$path; status="will-replace"; sourceCount=$sourceCount; targetCount=$targetCount; beforeHash=$hashBeforeByPath[$path]; afterHash=$null; existedBefore=$true }
      Write-Host "[will-replace] $path sourceCount=$sourceCount"
    }
    default { $failures += "Unsupported operation type: $type" }
  }
}

if ($failures.Count -gt 0) {
  Write-Host "Preflight failed:" -ForegroundColor Red
  foreach ($failure in $failures) { Write-Host "- $failure" -ForegroundColor Red }
  exit 1
}

if (-not $Apply) {
  Write-Host "Dry-run complete. No files changed. Use -Apply to write changes."
  exit 0
}

$timestamp = (Get-Date).ToString("yyyy-MM-ddTHH-mm-ss-fff")
$backupByPath = @{}
$entries = @()
$batchAppliedAt = (Get-Date).ToString("o")

try {
  foreach ($plan in $planned) {
    if ($plan.status -eq "already-applied") { continue }
    $path = [string]$plan.path
    if (-not $backupByPath.ContainsKey($path)) {
      $leaf = [IO.Path]::GetFileName($path)
      $backupPath = Join-Path $BackupRoot "$leaf.before-$patchId-$timestamp"
      if (Test-Path -LiteralPath $path) { Copy-Item -LiteralPath $path -Destination $backupPath -Force }
      $backupByPath[$path] = $backupPath
    }
  }

  foreach ($plan in $planned) {
    if ($plan.status -eq "already-applied") { continue }
    if ($plan.type -eq "copy") {
      $targetDir = Split-Path -Parent ([string]$plan.path)
      New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
      Copy-Item -LiteralPath ([string]$plan.sourcePath) -Destination ([string]$plan.path) -Force
    }
  }

  foreach ($path in $contentByPath.Keys) {
    $hasChange = $false
    foreach ($plan in $planned) {
      if ($plan.path -eq $path -and $plan.status -ne "already-applied") { $hasChange = $true; break }
    }
    if ($hasChange) { Write-Utf8NoBom $path ([string]$contentByPath[$path]) }
  }

  foreach ($plan in $planned) {
    $path = [string]$plan.path
    $entries += [pscustomobject]@{
      patchId = $patchId
      gameVersion = $gameVersion
      operationType = $plan.type
      targetPath = $path
      targetHashBefore = $plan.beforeHash
      targetHashAfter = Get-Sha256 $path
      backupPath = if ($backupByPath.ContainsKey($path)) { $backupByPath[$path] } else { $null }
      existedBefore = $plan.existedBefore
      status = if ($plan.status -eq "already-applied") { "already-applied" } else { "applied" }
      appliedAt = $batchAppliedAt
    }
  }

  $state = Load-State
  Save-State (@($state) + $entries)
  Write-Host "Apply complete. State written to $StatePath"
} catch {
  Write-Host "Apply failed after write attempt: $($_.Exception.Message)" -ForegroundColor Red
  foreach ($path in $backupByPath.Keys) {
    $backup = $backupByPath[$path]
    if ($backup -and (Test-Path -LiteralPath $backup)) { Copy-Item -LiteralPath $backup -Destination $path -Force }
  }
  throw
}
