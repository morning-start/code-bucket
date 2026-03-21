<#
.SYNOPSIS
    删除符号链接

.DESCRIPTION
    此函数用于删除指定的符号链接。
    它会检查路径是否为符号链接，如果是则删除，否则跳过操作。

.PARAMETER SymlinkPath
    要删除的符号链接路径
#>
function Remove-Symlink {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "要删除的符号链接路径")]
        [string]$SymlinkPath
    )

    # 检查路径是否为符号链接
    $item = Get-Item -Path $SymlinkPath -Force -ErrorAction SilentlyContinue
    if (-not $item -or -not $item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
        Write-Verbose "$SymlinkPath 不是符号链接，跳过操作"
        return
    }

    try {
        # 仅删除符号链接
        if ($PSCmdlet.ShouldProcess($SymlinkPath, "删除符号链接")) {
            Remove-Item -Path $SymlinkPath -Force -ErrorAction Stop
            Write-Verbose "已删除符号链接: $SymlinkPath"
        }
    } catch {
        Write-Error "删除符号链接失败: $_"
        throw
    }
}

Remove-Symlink $args[0]
