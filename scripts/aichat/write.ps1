$script_dir = $args[0]

if (-not (Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force }

function writeConfig {
    param (
        [string]$command
    )
    if (-not (Get-Content $PROFILE -ErrorAction SilentlyContinue | Select-String ([regex]::Escape($command)))) {
        Add-Content -Path $PROFILE -Value $command
    }
}
writeConfig '. ' + (Join-Path $script_dir 'aichat.ps1')
writeConfig '. ' + (Join-Path $script_dir 'integration.ps1')
