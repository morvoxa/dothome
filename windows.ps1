$Configs = @(
    @{ Name = "VSCodium"; Source = "src/config/Code"; Destination = "$HOME\AppData\Roaming\Code"; IsFolder = $true }
    @{ Name = "neovim"; Source = "src/config/nvim"; Destination = "$HOME\AppData\Local\nvim"; IsFolder = $true }
    @{ Name = "Profile"; Source = "src/WindowsPowerShell"; Destination = "$HOME\Documents\WindowsPowerShell"; IsFolder = $true }
    @{ Name = "GitConfig"; Source = "src/config/gitconfig"; Destination = "$HOME\.gitconfig"; IsFolder = $false }
    @{ Name = "wezterm"; Source = "src/wezterm.lua"; Destination = "$HOME\.wezterm.lua"; IsFolder = $false }
)

$CurrentDir = Get-Location

foreach ($config in $Configs) {
    $SourcePath = Join-Path $CurrentDir $config.Source
    $DestinationPath = $config.Destination
    
    # Determine the object type for the log headers
    $TypeString = if ($config.IsFolder) { "Folder" } else { "File" }

    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "Processing ($TypeString): $($config.Name)" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan

    if (Test-Path $SourcePath) {
        # --- IF THE SOURCE IS A FOLDER ---
        if ($config.IsFolder) {
            # Create target root folder if it doesn't exist
            if (-not (Test-Path $DestinationPath)) {
                Write-Host "[NEW] Creating destination folder: $DestinationPath" -ForegroundColor Magenta
                New-Item -ItemType Directory -Force -Path $DestinationPath | Out-Null
            }

            $SourceFiles = Get-ChildItem -Path $SourcePath -Recurse -File
            foreach ($file in $SourceFiles) {
                $relativePath = $file.FullName.Substring($SourcePath.Length + 1)
                $destFile = Join-Path $DestinationPath $relativePath
                $destDir = Split-Path $destFile -Parent

                # Create subfolders if a nested directory structure exists
                if (-not (Test-Path $destDir)) {
                    Write-Host "[NEW] Creating subfolder: $destDir" -ForegroundColor Magenta
                    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
                }

                if (Test-Path $destFile) {
                    $diff = Compare-Object (Get-Content $destFile -ErrorAction SilentlyContinue) (Get-Content $file.FullName -ErrorAction SilentlyContinue)
                    if ($diff) {
                        Write-Host "`n[DIFF] Changes detected in: $relativePath" -ForegroundColor Yellow
                        foreach ($d in $diff) {
                            $symbol = if ($d.SideIndicator -eq "=>") { "+" } else { "-" }
                            $color = if ($d.SideIndicator -eq "=>") { "Green" } else { "Red" }
                            Write-Host "  $symbol $($d.InputObject)" -ForegroundColor $color
                        }
                    }
                } else {
                    Write-Host "[NEW] New file added: $relativePath" -ForegroundColor DarkGreen
                }
                Copy-Item -Path $file.FullName -Destination $destFile -Force
            }
        }
        # --- IF THE SOURCE IS A SINGLE FILE ---
        else {
            $destDir = Split-Path $DestinationPath -Parent
            
            # Create parent folder for the single file if it doesn't exist
            if (-not (Test-Path $destDir)) {
                Write-Host "[NEW] Creating target parent folder: $destDir" -ForegroundColor Magenta
                New-Item -ItemType Directory -Force -Path $destDir | Out-Null
            }

            if (Test-Path $DestinationPath) {
                $diff = Compare-Object (Get-Content $DestinationPath -ErrorAction SilentlyContinue) (Get-Content $SourcePath -ErrorAction SilentlyContinue)
                if ($diff) {
                    Write-Host "`n[DIFF] Changes detected in file: $($config.Name)" -ForegroundColor Yellow
                    foreach ($d in $diff) {
                        $symbol = if ($d.SideIndicator -eq "=>") { "+" } else { "-" }
                        $color = if ($d.SideIndicator -eq "=>") { "Green" } else { "Red" }
                        Write-Host "  $symbol $($d.InputObject)" -ForegroundColor $color
                    }
                }
            } else {
                Write-Host "[NEW] New file added: $($config.Name)" -ForegroundColor DarkGreen
            }
            Copy-Item -Path $SourcePath -Destination $DestinationPath -Force
        }
        Write-Host "`n[SUCCESS] Successfully copied & updated $($config.Name)!`n" -ForegroundColor Green
    } else {
        Write-Host "[FAILED] Source $TypeString not found at: $SourcePath`n" -ForegroundColor Red
    }
}
