<#
.SYNOPSIS
    创建目录连接点（Junction），智能处理已存在的情况

.DESCRIPTION
    此函数用于创建 NTFS 目录连接点（Junction），智能处理各种边界情况：

    1. 路径不存在              → 直接创建 Junction
    2. 路径是空目录            → 删除后创建 Junction
    3. 路径是普通目录且有内容   → 移动内容到 Target，再创建 Junction
    4. 路径是 Junction/Symlink → 检查 Target：
       4a. Target 正确            → 跳过（已是预期状态）
       4b. Target 不存在（死链接）→ 删除旧链接，重建 Junction
       4c. Target 存在但路径错误  → 拒绝执行（保护用户数据），除非设置 -Force
       4d. 类型错误（Symlink 需变 Junction）→ 删除后重建

    与 SymbolicLink 的区别：
    - Junction 仅适用于目录，可跨 NTFS 卷；跨盘符创建需管理员权限
    - Junction 对 WSL、容器存储更兼容（WSL 拒绝 Symlink 但接受 Junction）

.PARAMETER JunctionPath
    要创建的 Junction 路径（应用/用户实际访问的位置）

.PARAMETER TargetPath
    Junction 指向的目标路径（真实数据存储位置）

.PARAMETER Force
    强制重建：当已存在的 Junction 指向错误 Target 时，不询问直接删除重建
#>
function New-JunctionIfNotExists {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "要创建的 Junction 路径")]
        [string]$JunctionPath,
        [Parameter(Mandatory = $true, HelpMessage = "Junction 指向的目标路径")]
        [string]$TargetPath,
        [Parameter(Mandatory = $false, HelpMessage = "强制重建")]
        [switch]$Force
    )

    # 规范化路径（去除末尾分隔符以便比较）
    # PowerShell 单引号字符串里 \\ 不会被转义为 \，所以用 [char]92 直接用反斜杠的 ASCII 码
    function Get-NormalizedPath {
        param([string]$Path)
        $backslash = [char]92  # 92 = '\'
        try {
            return ([System.IO.Path]::GetFullPath($Path)).TrimEnd($backslash, '/').ToLowerInvariant()
        } catch {
            return $Path.TrimEnd($backslash, '/').ToLowerInvariant()
        }
    }

    # 解析现有重解析点（Junction/Symlink）的真实目标
    function Get-ReparsePointTarget {
        param([string]$Path)
        # 优先使用 fsutil，输出第二行的 "Sub Directory: ..." 或 "Print Name: ..."
        try {
            $output = & fsutil.exe reparsepoint query "$Path" 2>&1
            if ($LASTEXITCODE -eq 0) {
                foreach ($line in $output) {
                    if ($line -match '^\s*(Sub Directory|Print Name)\s*:\s*(.+)$') {
                        return $Matches[2].Trim()
                    }
                }
            }
        } catch {}
        return $null
    }

    try {
        $normalizedTarget = Get-NormalizedPath $TargetPath

        # ===== 情况 1/2/3/4：检查现有路径 =====
        if (Test-Path -Path $JunctionPath -ErrorAction SilentlyContinue) {
            $item = Get-Item -Path $JunctionPath -Force -ErrorAction SilentlyContinue
            $isReparsePoint = $item -and $item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)

            if ($isReparsePoint) {
                # 4. 已是 Junction/Symlink，检查目标
                $existingTarget = Get-ReparsePointTarget $JunctionPath
                $normalizedExisting = if ($existingTarget) { Get-NormalizedPath $existingTarget } else { '' }

                if ($normalizedExisting -eq $normalizedTarget) {
                    # 4a. 目标正确
                    Write-Verbose "$JunctionPath 已指向正确目标 $TargetPath，跳过"
                    return
                }

                if ([string]::IsNullOrEmpty($existingTarget) -or -not (Test-Path $existingTarget)) {
                    # 4b. 死链接（Junction 存在但 Target 不存在）→ 静默删除重建
                    Write-Verbose "$JunctionPath 是死链接（指向不存在的 $existingTarget），将删除并重建"
                    Remove-Item -Path $JunctionPath -Force -ErrorAction Stop
                } else {
                    # 4c/4d. 目标存在但路径错误（可能是 Symlink 而非 Junction，或指向别处）
                    $itemType = if ($item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) -and $existingTarget) {
                        # 进一步区分：Junction 是 "Sub Directory"，Symlink 是 "Print Name"
                        try {
                            $output = & fsutil.exe reparsepoint query "$JunctionPath" 2>&1
                            if ($output -match 'Sub Directory') { 'Junction' } else { 'SymbolicLink' }
                        } catch { 'ReparsePoint' }
                    } else { 'Unknown' }

                    if ($Force) {
                        Write-Verbose "$JunctionPath ($itemType) 指向 $existingTarget，与期望的 $TargetPath 不匹配；-Force 已指定，将删除并重建"
                        Remove-Item -Path $JunctionPath -Force -ErrorAction Stop
                    } else {
                        throw "路径已存在且不是预期的 Junction：`n  路径: $JunctionPath`n  类型: $itemType`n  当前指向: $existingTarget`n  期望指向: $TargetPath`n请手动处理（删除/迁移后重试），或使用 -Force 参数强制重建。"
                    }
                }
            } else {
                # 2/3. 普通目录：处理内容后删除
                $hasContent = (Get-ChildItem -Path $JunctionPath -Force -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0
                if ($hasContent) {
                    if ($PSCmdlet.ShouldProcess($JunctionPath, "移动内容到目标目录 $TargetPath")) {
                        Move-Item -Path "$JunctionPath\*" -Destination $TargetPath -Force -ErrorAction Stop
                        Write-Verbose "已将 $JunctionPath 内容移动到 $TargetPath"
                    }
                }
                if ($PSCmdlet.ShouldProcess($JunctionPath, "删除原目录")) {
                    Remove-Item -Path $JunctionPath -Recurse -Force -ErrorAction Stop
                    Write-Verbose "已删除原目录: $JunctionPath"
                }
            }
        }

        # ===== 创建前的准备工作 =====
        if (-not (Test-Path -Path $TargetPath)) {
            if ($PSCmdlet.ShouldProcess($TargetPath, "创建目标目录")) {
                New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
                Write-Verbose "已创建目标目录: $TargetPath"
            }
        }

        $junctionParent = Split-Path -Parent $JunctionPath
        if (-not (Test-Path -Path $junctionParent)) {
            if ($PSCmdlet.ShouldProcess($junctionParent, "创建父目录")) {
                New-Item -ItemType Directory -Path $junctionParent -Force | Out-Null
                Write-Verbose "已创建父目录: $junctionParent"
            }
        }

        # ===== 创建 Junction =====
        if ($PSCmdlet.ShouldProcess($JunctionPath, "创建指向 $TargetPath 的 Junction")) {
            $proc = Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "mklink", "/J", "`"$JunctionPath`"", "`"$TargetPath`"" -Wait -PassThru -NoNewWindow -ErrorAction Stop
            if ($proc.ExitCode -ne 0) {
                throw "mklink /J 失败，退出码: $($proc.ExitCode)。跨盘符创建 Junction 需要管理员权限，请以管理员身份重试。"
            }
            Write-Verbose "已成功创建 Junction: $JunctionPath -> $TargetPath"
        }
    } catch {
        Write-Error "操作失败: $_"
        throw
    }
}

# 入口：支持 -Force 透传（通过 $args 简单实现不直观，这里使用参数化绑定）
if ($args.Count -ge 2) {
    $force = $args | Select-String -Pattern '^-Force$' -Quiet
    if ($force) {
        # 移除 -Force 参数
        $filtered = $args | Where-Object { $_ -ne '-Force' }
        New-JunctionIfNotExists -JunctionPath $filtered[0] -TargetPath $filtered[1] -Force
    } else {
        New-JunctionIfNotExists -JunctionPath $args[0] -TargetPath $args[1]
    }
} else {
    Write-Error "用法: junction.ps1 <JunctionPath> <TargetPath> [-Force]"
    exit 1
}
