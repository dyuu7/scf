[CmdletBinding()]
param([string]$ProfilePath = $PROFILE)

if (Test-Path $ProfilePath) {
    $item = Get-Item $ProfilePath
    if ($item.LinkType) {
        Remove-Item $ProfilePath -Force
        Write-Host "Removed symlink $ProfilePath"
    } else {
        Write-Warning "Profile at $ProfilePath is a regular file; not removing."
    }
}