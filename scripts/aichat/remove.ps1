$script_dir = $args[0]
function rmConfig {
    param (
        [string]$command
    )
    (Get-Content $PROFILE -ErrorAction SilentlyContinue) | Where-Object { $_ -ne $command } | Set-Content $PROFILE
}

rmConfig '. ' + (Join-Path $script_dir 'integration.ps1')
rmConfig '. ' + (Join-Path $script_dir 'aichat.ps1')
