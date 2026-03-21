function Remove-SymlinkAndRestore {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "要删除的符号链接路径")]
        [string]$SymlinkPath,

        [Parameter(Mandatory = $true, HelpMessage = "符号链接指向的目标路径")]
        [string]$TargetPath
    )

    # 检查路径是否为符号链接
    $item = Get-Item -Path $SymlinkPath -Force -ErrorAction SilentlyContinue
    if (-not $item -or -not $item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
        Write-Verbose "$SymlinkPath 不是符号链接，跳过操作"
        return
    }

    try {
        # 删除符号链接
        if ($PSCmdlet.ShouldProcess($SymlinkPath, "删除符号链接")) {
            Remove-Item -Path $SymlinkPath -Force -ErrorAction Stop
            Write-Verbose "已删除符号链接: $SymlinkPath"
        }

        # 如果目标目录存在且有内容，恢复数据
        if (Test-Path -Path $TargetPath) {
            $hasContent = (Get-ChildItem -Path $TargetPath -Force -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0

            if ($hasContent) {
                # 创建源目录
                if ($PSCmdlet.ShouldProcess($SymlinkPath, "创建源目录")) {
                    New-Item -ItemType Directory -Path $SymlinkPath -Force | Out-Null
                    Write-Verbose "已创建源目录: $SymlinkPath"
                }

                if ($PSCmdlet.ShouldProcess($TargetPath, "将内容移回源目录 $SymlinkPath")) {
                    # 移动目标目录内容到源目录
                    Move-Item -Path "$TargetPath\*" -Destination $SymlinkPath -Force -ErrorAction Stop
                    Write-Verbose "已将 $TargetPath 内容移回 $SymlinkPath"
                }
            }

            # 删除目标目录
            if ($PSCmdlet.ShouldProcess($TargetPath, "删除目标目录")) {
                Remove-Item -Path $TargetPath -Recurse -Force -ErrorAction SilentlyContinue
                Write-Verbose "已删除目标目录: $TargetPath"
            }
        }
    } catch {
        Write-Error "操作失败: $_"
        throw  # 重新抛出异常以便上层处理
    }
}

# 安全调用
if ($args.Count -lt 2) {
    Write-Error "用法: unlink.ps1 <SymlinkPath> <TargetPath>"
    exit 1
}

Remove-SymlinkAndRestore $args[0] $args[1]
