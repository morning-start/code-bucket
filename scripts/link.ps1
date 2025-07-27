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
