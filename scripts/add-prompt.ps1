Param(
  [Parameter(Mandatory = $true)][string]$PromptTitle,
  [Parameter(Mandatory = $true)][string]$AuthorHandle,
  [Parameter(Mandatory = $true)][string]$AuthorUrl,
  [Parameter(Mandatory = $true)][string]$Status,
  [Parameter(Mandatory = $true)][string]$LinkPath
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path (Resolve-Path "$PSScriptRoot\\..") -Parent
$contributorsPath = Resolve-Path "$PSScriptRoot\\..\\CONTRIBUTORS.md"

if (-not (Test-Path $contributorsPath)) {
  Write-Error "CONTRIBUTORS.md not found at $contributorsPath"
}

$content = Get-Content -Raw $contributorsPath

$template = "# Prompt: [Name of Prompt]`n**Author:** [@ContributorName](link-to-github-profile)`n**Status:** Verified by TechGuards ✅"

if ($content -notmatch [regex]::Escape($template)) {
  Write-Error "Template block not found or modified. Aborting to preserve template integrity."
}

$fullLink = Join-Path (Split-Path $contributorsPath -Parent) $LinkPath
if (-not (Test-Path $fullLink)) {
  Write-Error "Link path does not exist: $LinkPath"
}

if ([string]::IsNullOrWhiteSpace($PromptTitle) -or [string]::IsNullOrWhiteSpace($AuthorHandle) -or [string]::IsNullOrWhiteSpace($AuthorUrl) -or [string]::IsNullOrWhiteSpace($Status)) {
  Write-Error "All parameters must be non-empty."
}

if ($AuthorHandle -notmatch '^\@[\w\-]+$') {
  Write-Error "AuthorHandle must be like @Username"
}

if ($AuthorUrl -notmatch '^https?://') {
  Write-Error "AuthorUrl must be an http(s) URL"
}

$duplicatePattern = "(?m)^# Prompt: " + [regex]::Escape($PromptTitle) + "$"
if ($content -match $duplicatePattern) {
  Write-Error "An entry for '$PromptTitle' already exists."
}

$entry = @"
# Prompt: $PromptTitle
**Author:** [$AuthorHandle]($AuthorUrl)
**Status:** $Status
**Link to Prompt:** [View]($LinkPath)
"@

$insertionPattern = "(?ms)" + [regex]::Escape($template)
$newContent = $content -replace $insertionPattern, ($template + "`n`n" + $entry.Trim() )

Set-Content -NoNewline -Path $contributorsPath -Value $newContent

$recheck = Get-Content -Raw $contributorsPath
if ($recheck -notmatch [regex]::Escape($template)) {
  Write-Error "Template corruption detected after insertion."
}
if ($recheck -notmatch $duplicatePattern) {
  Write-Error "Entry insertion failed."
}

Write-Host "Entry added successfully after template without modifying it."
