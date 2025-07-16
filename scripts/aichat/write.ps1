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

function GenerateConfig {
    param (
        [string]$script_dir,
        [string]$cmd_path
    )
    # 返回多行字符串
    return "if (Test-Path (Join-Path $script_dir $cmd_path)){. (Join-Path $script_dir $cmd_path)}"
}

writeConfig (GenerateConfig $script_dir 'aichat.ps1')
writeConfig (GenerateConfig $script_dir 'integration.ps1')
