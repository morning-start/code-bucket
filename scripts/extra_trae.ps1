param(
    [Parameter(Mandatory = $true)]
    [string]$ExePath
)

if (-not (Test-Path $ExePath)) {
    Write-Error "File not found: $ExePath"
    exit 1
}

try {
    # Parse the version number directly from the file name
    $fileName = Split-Path -Leaf $ExePath

    # Match format: app#version#hash.exe (Scoop cache format)
    if ($fileName -match '#([\d.]+)#') {
        $version = $matches[1]
    }
    # Match format: app-version.exe or app_vversion.exe
    elseif ($fileName -match '[\-_v]([\d.]+)\.exe$') {
        $version = $matches[1]
    }
    # Match any numeric version
    elseif ($fileName -match '([\d.]+)') {
        $version = $matches[1]
    }
    else {
        $version = "unknown"
    }

    # Build the destination directory: D:\scoop\apps\trae-cn\<version>
    $destDir = "E:\scoop\apps\trae-cn\$version"

    # Ensure the destination directory exists
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    Write-Host "Extracting to: $destDir" -ForegroundColor Magenta

    # Run innounp
    innounp -x -b -y -h -q -d"$destDir" "$ExePath" -c"{code_GetDestDir}" >nul 2>&1

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Extraction complete!" -ForegroundColor Green
    } else {
        Write-Warning "innounp returned exit code: $LASTEXITCODE"
    }
}
catch {
    Write-Error "Processing failed: $_"
    exit 1
}
