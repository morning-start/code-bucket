param(
    [Parameter(Mandatory = $true)]
    [string]$ExePath
)

if (-not (Test-Path $ExePath)) {
    Write-Error "文件不存在: $ExePath"
    exit 1
}

try {
    # 从文件名直接解析版本号
    $fileName = Split-Path -Leaf $ExePath

    # 匹配格式: app#version#hash.exe (Scoop cache 格式)
    if ($fileName -match '#([\d.]+)#') {
        $version = $matches[1]
    }
    # 匹配格式: app-version.exe 或 app_vversion.exe
    elseif ($fileName -match '[\-_v]([\d.]+)\.exe$') {
        $version = $matches[1]
    }
    # 匹配任意数字版本号
    elseif ($fileName -match '([\d.]+)') {
        $version = $matches[1]
    }
    else {
        $version = "未知版本"
    }

    # Write-Host "版本: $version" -ForegroundColor Green
    # Write-Host ""

    # 构建目标目录：D:\scoop\apps\trae-cn\<version>
    $destDir = "D:\scoop\apps\trae-cn\$version"

    # 确保目标目录存在
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    Write-Host "开始解压到: $destDir" -ForegroundColor Magenta

    # 运行 innounp 命令
    innounp -x -b -y -h -q -d"$destDir" "$ExePath" -c"{code_GetDestDir}" >nul 2>&1

    if ($LASTEXITCODE -eq 0) {
        Write-Host "解压完成！" -ForegroundColor Green
    } else {
        Write-Warning "innounp 返回退出码: $LASTEXITCODE"
    }
}
catch {
    Write-Error "处理失败: $_"
    exit 1
}
