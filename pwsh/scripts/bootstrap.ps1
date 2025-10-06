[CmdletBinding()]
param(
    [switch]$InstallOhMyPosh = $true,
    [switch]$InstallFnm      = $true,
    [switch]$InstallZLocation = $true
)

$ErrorActionPreference = 'Continue'

function Ensure-Command { param([string]$Name) [bool](Get-Command $Name -ErrorAction SilentlyContinue) }
function Try-Run      { param([string]$Cmd) Write-Host "→ $Cmd"; try { iex $Cmd } catch { Write-Warning $_ } }

# oh-my-posh
if ($InstallOhMyPosh -and -not (Ensure-Command 'oh-my-posh')) {
    if ($IsWindows) {
        if (Ensure-Command 'winget') { Try-Run 'winget install --id JanDeDobbeleer.OhMyPosh -e --source winget' }
        elseif (Ensure-Command 'choco') { Try-Run 'choco install oh-my-posh -y' }
        else { Write-Warning 'Install oh-my-posh manually (winget/choco not found).'}
    } elseif ($IsMacOS) {
        if (Ensure-Command 'brew') { Try-Run 'brew install jandedobbeleer/oh-my-posh/oh-my-posh' }
        elseif (Ensure-Command 'port') { Try-Run 'sudo port install oh-my-posh' }
        else { Write-Warning 'Install oh-my-posh manually (brew/macports not found).'}
    } elseif ($IsLinux) {
        if (Ensure-Command 'brew') { Try-Run 'brew install oh-my-posh' }
        elseif (Test-Path '/etc/debian_version') { Try-Run 'sudo apt-get update && sudo apt-get install -y oh-my-posh' }
        elseif (Test-Path '/etc/redhat-release') { Try-Run 'sudo dnf install -y oh-my-posh' }
        elseif (Test-Path '/etc/arch-release') { Try-Run 'sudo pacman -S --noconfirm oh-my-posh' }
        else { Write-Warning 'Install oh-my-posh manually for your distro.' }
    }
}

# fnm
if ($InstallFnm -and -not (Ensure-Command 'fnm')) {
    if ($IsWindows) {
        if (Ensure-Command 'winget') { Try-Run 'winget install --id Schniz.fnm -e --source winget' }
        elseif (Ensure-Command 'choco') { Try-Run 'choco install fnm -y' }
        else { Write-Warning 'Install fnm manually (winget/choco not found).'}
    } elseif ($IsMacOS) {
        if (Ensure-Command 'brew') { Try-Run 'brew install fnm' }
        elseif (Ensure-Command 'port') { Try-Run 'sudo port install fnm' }
        else { Write-Warning 'Install fnm manually (brew/macports not found).'}
    } elseif ($IsLinux) {
        if (Ensure-Command 'brew') { Try-Run 'brew install fnm' }
        elseif (Test-Path '/etc/debian_version') { Try-Run 'curl -fsSL https://fnm.vercel.app/install | bash' }
        else { Write-Warning 'Install fnm manually for your distro.' }
    }
}

# ZLocation（PowerShell 模块）
if ($InstallZLocation) {
    if (-not (Get-Module -ListAvailable -Name 'ZLocation')) {
        Try-Run 'PowerShellGet\Install-Module ZLocation -Scope CurrentUser -Force'
    }
}

Write-Host "`nInstalled versions:"
Get-Command oh-my-posh -ErrorAction SilentlyContinue | ForEach-Object { "oh-my-posh $(& oh-my-posh --version 2>$null)" }
Get-Command fnm       -ErrorAction SilentlyContinue | ForEach-Object { "fnm $(& fnm --version 2>$null)" }
