$ompConfigLocal = Join-Path $PSScriptRoot 'theme.omp.json'
$ompConfig = if (Test-Path $ompConfigLocal) { $ompConfigLocal }
             elseif ($env:POSH_THEMES_PATH) { Join-Path $env:POSH_THEMES_PATH 'huvix.omp.json' }
             else { $null }

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    if ($ompConfig) {
        oh-my-posh init pwsh --config $ompConfig | Invoke-Expression
    } else {
        oh-my-posh init pwsh | Invoke-Expression
    }
} else {
    Write-Verbose "oh-my-posh not found; prompt will be default."
}

if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd | Out-String | Invoke-Expression
}

$modules = @('ZLocation')
foreach ($m in $modules) {
    if (Get-Module -ListAvailable -Name $m) {
        Import-Module $m -ErrorAction SilentlyContinue
    }
}

if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
}

Set-Alias -Name ll -Value Get-ChildItem -ErrorAction SilentlyContinue
function la { Get-ChildItem -Force }

$local = Join-Path $PSScriptRoot 'local.profile.ps1'
if (Test-Path $local) { . $local }
