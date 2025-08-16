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
function New-SymlinkIfNotExists($target_dir, $link_dir) {
    # 检查目标是否已经是符号链接
    if (Test-Path $target_dir) {
        $item = Get-Item $target_dir -Force
        if ($item.Attributes -match 'ReparsePoint') {
            # 如果已经是符号链接，则跳过
            return
        }
    }

    # 确保$link_dir目录存在
    if (-not (Test-Path $link_dir)) {
        New-Item -ItemType Directory -Path $link_dir -Force | Out-Null
    }

    if (Test-Path $target_dir) {
        if (-not (Get-ChildItem -Path $target_dir -Force)) {
            # 目标目录存在但为空，直接删除并创建符号链接
            Remove-Item $target_dir -Force
            New-Item -ItemType SymbolicLink -Path $target_dir -Target $link_dir | Out-Null
        } else {
            # 目标目录存在且包含内容，需要移动
            $items = Get-ChildItem -Path $target_dir -Force
            if ($items) {
                foreach ($item in $items) {
                    $dest = Join-Path $link_dir $item.Name
                    if (-not (Test-Path $dest)) {
                        Move-Item -Path $item.FullName -Destination $link_dir -Force
                    }
                }
            }
            Remove-Item $target_dir -Force
            New-Item -ItemType SymbolicLink -Path $target_dir -Target $link_dir | Out-Null
        }
    } else {
        New-Item -ItemType SymbolicLink -Path $target_dir -Target $link_dir | Out-Null
    }
}
New-SymlinkIfNotExists $args[0] $args[1]
