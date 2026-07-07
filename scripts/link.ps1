<#
.SYNOPSIS
    Create a symbolic link, handling cases where the target already exists.

.DESCRIPTION
    Creates a symbolic link. It checks whether the target path already exists
    and whether it is already a symlink, then acts accordingly:
    1. Already a symlink         -> do nothing
    2. Does not exist            -> create the symlink directly
    3. Exists as empty directory -> remove then create the symlink
    4. Exists with content       -> move content into the link target, then create symlink

.PARAMETER target_dir
    The path the symlink points to (real data location).

.PARAMETER link_dir
    The symlink path (where the app/user actually accesses).
#>
function New-SymlinkIfNotExists {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "The symlink path to create")]
        [string]$SymlinkPath,
        [Parameter(Mandatory = $true, HelpMessage = "The target path the symlink points to")]
        [string]$TargetPath
    )

    # Check whether the target path is already a symlink
    if (Test-Path -Path $SymlinkPath -ErrorAction SilentlyContinue) {
        $item = Get-Item -Path $SymlinkPath -Force -ErrorAction SilentlyContinue
        if ($item -and $item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Verbose "$SymlinkPath is already a symlink, skipping"
            return
        }
    }

    try {
        # Ensure the target directory exists
        if (-not (Test-Path -Path $TargetPath)) {
            if ($PSCmdlet.ShouldProcess($TargetPath, "Create target directory")) {
                New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
                Write-Verbose "Created target directory: $TargetPath"
            }
        }

        # Handle an already existing source path
        if (Test-Path -Path $SymlinkPath) {
            # Check whether the directory has content
            $hasContent = (Get-ChildItem -Path $SymlinkPath -Force -ErrorAction SilentlyContinue |
                Measure-Object).Count -gt 0
            if ($hasContent) {
                if ($PSCmdlet.ShouldProcess($SymlinkPath, "Move content to target $TargetPath")) {
                    # Move directory contents rather than the directory itself
                    Move-Item -Path "$SymlinkPath\*" -Destination $TargetPath -Force -ErrorAction Stop
                    Write-Verbose "Moved $SymlinkPath content to $TargetPath"
                }
            }

            # Remove the original path (whether empty or not)
            if ($PSCmdlet.ShouldProcess($SymlinkPath, "Remove original path")) {
                Remove-Item -Path $SymlinkPath -Recurse -Force -ErrorAction Stop
                Write-Verbose "Removed original path: $SymlinkPath"
            }
        }

        # Create the symlink
        if ($PSCmdlet.ShouldProcess($SymlinkPath, "Create symlink to $TargetPath")) {
            New-Item -ItemType SymbolicLink -Path $SymlinkPath -Target $TargetPath -Force -ErrorAction Stop | Out-Null
            Write-Verbose "Created symlink: $SymlinkPath -> $TargetPath"
        }
    } catch {
        Write-Error "Operation failed: $_"
        throw  # re-throw so the caller can handle
    }
}

New-SymlinkIfNotExists $args[0] $args[1]
