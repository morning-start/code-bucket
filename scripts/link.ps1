<#
.SYNOPSIS
    创建符号链接，如果目标已存在且不是符号链接则进行相应处理

.DESCRIPTION
    此函数用于创建符号链接，它会检查目标目录是否已经存在以及是否已经是符号链接，
    并根据不同的情况采取相应的处理措施：
    1. 如果目标已经是符号链接，则不进行任何操作
    2. 如果目标不存在，则直接创建符号链接
    3. 如果目标存在但为空目录，则删除后创建符号链接
    4. 如果目标存在且包含内容，则将内容移动到链接目录后再创建符号链接

.PARAMETER target_dir
    符号链接的目标路径

.PARAMETER link_dir
    符号链接指向的目录路径
#>
function New-SymlinkIfNotExists {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "要创建的符号链接路径")]
        [string]$SymlinkPath,
        
        [Parameter(Mandatory = $true, HelpMessage = "符号链接指向的目标路径")]
        [string]$TargetPath
    )

    # 检查目标路径是否已为符号链接
    if (Test-Path -Path $SymlinkPath -ErrorAction SilentlyContinue) {
        $item = Get-Item -Path $SymlinkPath -Force -ErrorAction SilentlyContinue
        if ($item -and $item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Verbose "$SymlinkPath 已是符号链接，跳过操作"
            return
        }
    }

    try {
        # 确保目标目录存在
        if (-not (Test-Path -Path $TargetPath)) {
            if ($PSCmdlet.ShouldProcess($TargetPath, "创建目标目录")) {
                New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
                Write-Verbose "已创建目标目录: $TargetPath"
            }
        }

        # 处理已存在的源路径
        if (Test-Path -Path $SymlinkPath) {
            # 检查目录是否为空
            $hasContent = (Get-ChildItem -Path $SymlinkPath -Force -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0
            
            if ($hasContent) {
                if ($PSCmdlet.ShouldProcess($SymlinkPath, "移动内容到目标目录 $TargetPath")) {
                    # 移动目录内容而非目录本身
                    Move-Item -Path "$SymlinkPath\*" -Destination $TargetPath -Force -ErrorAction Stop
                    Write-Verbose "已将 $SymlinkPath 内容移动到 $TargetPath"
                }
            }

            # 删除原路径（无论是否为空）
            if ($PSCmdlet.ShouldProcess($SymlinkPath, "删除原路径")) {
                Remove-Item -Path $SymlinkPath -Recurse -Force -ErrorAction Stop
                Write-Verbose "已删除原路径: $SymlinkPath"
            }
        }

        # 创建符号链接
        if ($PSCmdlet.ShouldProcess($SymlinkPath, "创建指向 $TargetPath 的符号链接")) {
            New-Item -ItemType SymbolicLink -Path $SymlinkPath -Target $TargetPath -Force -ErrorAction Stop | Out-Null
            Write-Verbose "已成功创建符号链接: $SymlinkPath -> $TargetPath"
        }
    }
    catch {
        Write-Error "操作失败: $_"
        throw  # 重新抛出异常以便上层处理
    }
}

New-SymlinkIfNotExists $args[0] $args[1]
