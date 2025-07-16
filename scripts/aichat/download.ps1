$download_dir = $args[0]
$integration = Join-Path $download_dir 'integration.ps1'
$completions = Join-Path $download_dir 'aichat.ps1'

$integration_url = 'https://github.com/sigoden/aichat/raw/main/scripts/shell-integration/integration.ps1'
$completions_url = 'https://github.com/sigoden/aichat/raw/main/scripts/completions/aichat.ps1'

function downloadCmd {
    param (
        [string]$path,
        [string]$url
    )
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path (Split-Path $path) -Force
        Invoke-WebRequest -Uri $url -OutFile $path
    }
}

downloadCmd $integration $integration_url
downloadCmd $completions $completions_url
