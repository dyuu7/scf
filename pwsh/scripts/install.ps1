[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Copy,
    [string]$ProfilePath = $PROFILE
)

$ErrorActionPreference = 'Stop'

$repoRoot   = Split-Path -Parent $PSScriptRoot
$profileSrc = Join-Path $repoRoot 'Microsoft.PowerShell_profile.ps1'

if (-not (Test-Path -LiteralPath $profileSrc)) {
    throw "Profile source not found: $profileSrc"
}

$profileDir = Split-Path -Parent $ProfilePath
if (-not (Test-Path -LiteralPath $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$item = Get-Item -LiteralPath $ProfilePath -Force -ErrorAction SilentlyContinue
if ($null -ne $item -and -not $item.PSIsContainer -and -not $item.LinkType) {
    $backup = "$ProfilePath.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item -LiteralPath $ProfilePath -Destination $backup -Force
    Write-Host "Backed up existing profile to $backup"
}

function New-Symlink {
    param([string]$Link, [string]$Target)
    if ($PSCmdlet.ShouldProcess("$Link -> $Target","Create symbolic link")) {
        if (Test-Path -LiteralPath $Link) { Remove-Item -LiteralPath $Link -Force }
        New-Item -ItemType SymbolicLink -Path $Link -Target $Target -Force | Out-Null
    }
}

$didLink = $false
if (-not $Copy) {
    try {
        New-Symlink -Link $ProfilePath -Target $profileSrc
        $didLink = $true
        Write-Host "Linked $ProfilePath -> $profileSrc"
    } catch {
        Write-Warning "Symbolic link failed: $($_.Exception.Message). Falling back to copy."
    }
}

if (-not $didLink) {
    Copy-Item -LiteralPath $profileSrc -Destination $ProfilePath -Force
    Write-Host "Copied $profileSrc -> $ProfilePath"
}

Write-Host "Done."
