<#
.SYNOPSIS
    Create a directory junction, handling existing paths intelligently.

.DESCRIPTION
    Creates an NTFS directory junction and handles various edge cases:

    1. Path does not exist           -> create the junction directly
    2. Path is an empty directory     -> delete then create the junction
    3. Path is a normal directory with content -> move content to Target, then create junction
    4. Path is a junction/symlink     -> check the target:
       4a. Target is correct          -> skip (already desired state)
       4b. Target missing (dead link) -> delete and recreate the junction
       4c. Target exists but wrong     -> refuse (protect user data) unless -Force
       4d. Wrong type (symlink vs junction) -> delete and recreate

    Difference from SymbolicLink:
    - Junction works for directories only, can span NTFS volumes; cross-drive
      creation needs administrator privileges.
    - Junction is more compatible with WSL and container storage (WSL rejects
      symlinks but accepts junctions).

.PARAMETER JunctionPath
    The junction path to create (where the app/user accesses).

.PARAMETER TargetPath
    The real data location the junction points to.

.PARAMETER Force
    Force recreation when an existing junction points to the wrong target.
#>
function New-JunctionIfNotExists {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "The junction path to create")]
        [string]$JunctionPath,
        [Parameter(Mandatory = $true, HelpMessage = "The target path the junction points to")]
        [string]$TargetPath,
        [Parameter(Mandatory = $false, HelpMessage = "Force recreation")]
        [switch]$Force
    )

    # Normalize path (strip trailing separators for comparison).
    # In a single-quoted PowerShell string \\ is not an escape, so use [char]92
    # which is the ASCII code for the backslash.
    function Get-NormalizedPath {
        param([string]$Path)
        $backslash = [char]92  # 92 = '\'
        try {
            return ([System.IO.Path]::GetFullPath($Path)).TrimEnd($backslash, '/').ToLowerInvariant()
        } catch {
            return $Path.TrimEnd($backslash, '/').ToLowerInvariant()
        }
    }

    # Resolve the real target of an existing reparse point (junction/symlink)
    function Get-ReparsePointTarget {
        param([string]$Path)
        # Prefer fsutil; its output has "Sub Directory: ..." or "Print Name: ..."
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

        # ===== cases 1/2/3/4: inspect the existing path =====
        if (Test-Path -Path $JunctionPath -ErrorAction SilentlyContinue) {
            $item = Get-Item -Path $JunctionPath -Force -ErrorAction SilentlyContinue
            $isReparsePoint = $item -and $item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)

            if ($isReparsePoint) {
                # 4. Already a junction/symlink, check the target
                $existingTarget = Get-ReparsePointTarget $JunctionPath
                $normalizedExisting = if ($existingTarget) { Get-NormalizedPath $existingTarget } else { '' }

                if ($normalizedExisting -eq $normalizedTarget) {
                    # 4a. Target is correct
                    Write-Verbose "$JunctionPath already points to correct target $TargetPath, skipping"
                    return
                }

                if ([string]::IsNullOrEmpty($existingTarget) -or -not (Test-Path $existingTarget)) {
                    # 4b. Dead link (junction exists but target missing) -> delete and recreate
                    Write-Verbose "$JunctionPath is a dead link (points to missing $existingTarget), will delete and recreate"
                    Remove-Item -Path $JunctionPath -Force -ErrorAction Stop
                } else {
                    # 4c/4d. Target exists but wrong (maybe symlink not junction, or points elsewhere)
                    $itemType = if ($item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) -and $existingTarget) {
                        # Distinguish further: Junction is "Sub Directory", Symlink is "Print Name"
                        try {
                            $output = & fsutil.exe reparsepoint query "$JunctionPath" 2>&1
                            if ($output -match 'Sub Directory') { 'Junction' } else { 'SymbolicLink' }
                        } catch { 'ReparsePoint' }
                    } else { 'Unknown' }

                    if ($Force) {
                        Write-Verbose "$JunctionPath ($itemType) points to $existingTarget, expected $TargetPath; -Force set, will delete and recreate"
                        Remove-Item -Path $JunctionPath -Force -ErrorAction Stop
                    } else {
                        throw "Path already exists and is not the expected junction:`n  Path: $JunctionPath`n  Type: $itemType`n  Current target: $existingTarget`n  Expected target: $TargetPath`nHandle it manually (delete/migrate then retry), or use -Force to recreate."
                    }
                }
            } else {
                # 2/3. Normal directory: move content then delete
                $hasContent = (Get-ChildItem -Path $JunctionPath -Force -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0
                if ($hasContent) {
                    if ($PSCmdlet.ShouldProcess($JunctionPath, "Move content to target $TargetPath")) {
                        Move-Item -Path "$JunctionPath\*" -Destination $TargetPath -Force -ErrorAction Stop
                        Write-Verbose "Moved $JunctionPath content to $TargetPath"
                    }
                }
                if ($PSCmdlet.ShouldProcess($JunctionPath, "Delete original directory")) {
                    Remove-Item -Path $JunctionPath -Recurse -Force -ErrorAction Stop
                    Write-Verbose "Deleted original directory: $JunctionPath"
                }
            }
        }

        # ===== preparation before creation =====
        if (-not (Test-Path -Path $TargetPath)) {
            if ($PSCmdlet.ShouldProcess($TargetPath, "Create target directory")) {
                New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
                Write-Verbose "Created target directory: $TargetPath"
            }
        }

        $junctionParent = Split-Path -Parent $JunctionPath
        if (-not (Test-Path -Path $junctionParent)) {
            if ($PSCmdlet.ShouldProcess($junctionParent, "Create parent directory")) {
                New-Item -ItemType Directory -Path $junctionParent -Force | Out-Null
                Write-Verbose "Created parent directory: $junctionParent"
            }
        }

        # ===== create the junction =====
        if ($PSCmdlet.ShouldProcess($JunctionPath, "Create junction to $TargetPath")) {
            $proc = Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "mklink", "/J", "`"$JunctionPath`"", "`"$TargetPath`"" -Wait -PassThru -NoNewWindow -ErrorAction Stop
            if ($proc.ExitCode -ne 0) {
                throw "mklink /J failed, exit code: $($proc.ExitCode). Cross-drive junction creation needs administrator privileges; retry as admin."
            }
            Write-Verbose "Created junction: $JunctionPath -> $TargetPath"
        }
    } catch {
        Write-Error "Operation failed: $_"
        throw
    }
}

# Entry point: pass -Force through (simple $args binding is not intuitive, so parameterize)
if ($args.Count -ge 2) {
    $force = $args | Select-String -Pattern '^-Force$' -Quiet
    if ($force) {
        # Strip the -Force argument
        $filtered = $args | Where-Object { $_ -ne '-Force' }
        New-JunctionIfNotExists -JunctionPath $filtered[0] -TargetPath $filtered[1] -Force
    } else {
        New-JunctionIfNotExists -JunctionPath $args[0] -TargetPath $args[1]
    }
} else {
    Write-Error "Usage: junction.ps1 <JunctionPath> <TargetPath> [-Force]"
    exit 1
}
