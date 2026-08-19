$Configs = @(
    @{
        Name        = "VSCodium"
        Source      = "src/config/VSCodium"
        Destination = "$HOME\AppData\Roaming\VSCodium"
        IsFolder    = $true
    }
    @{
        Name        = "neovim"
        Source      = "src/config/nvim"
        Destination = "$HOME\AppData\Local\nvim"
        IsFolder    = $true
    }
     @{
         Name        = "GitConfig"
         Source      = "src/config/gitconfig"
         Destination = "$HOME\.gitconfig"
         IsFolder    = $false
     }
)

$CurrentDir = Get-Location

foreach ($config in $Configs) {
    $SourcePath = Join-Path $CurrentDir $config.Source
    $DestinationPath = $config.Destination

    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "Memproses: $($config.Name)" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan

    if (Test-Path $SourcePath) {

        # --- JIKA SUMBER ADALAH FOLDER ---
        if ($config.IsFolder) {
            if (-not (Test-Path $DestinationPath)) {
                New-Item -ItemType Directory -Force -Path $DestinationPath | Out-Null
            }

            $SourceFiles = Get-ChildItem -Path $SourcePath -Recurse -File

            foreach ($file in $SourceFiles) {
                $relativePath = $file.FullName.Substring($SourcePath.Length + 1)
                $destFile = Join-Path $DestinationPath $relativePath
                $destDir = Split-Path $destFile -Parent

                if (-not (Test-Path $destDir)) {
                    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
                }

                if (Test-Path $destFile) {
                    $diff = Compare-Object (Get-Content $destFile -ErrorAction SilentlyContinue) (Get-Content $file.FullName -ErrorAction SilentlyContinue)
                    
                    if ($diff) {
                        Write-Host "`n[DIFF] Perubahan terdeteksi pada: $relativePath" -ForegroundColor Yellow
                        foreach ($d in $diff) {
                            $symbol = if ($d.SideIndicator -eq "=>") { "+" } else { "-" }
                            $color = if ($d.SideIndicator -eq "=>") { "Green" } else { "Red" }
                            Write-Host "  $symbol $($d.InputObject)" -ForegroundColor $color
                        }
                    }
                } else {
                    Write-Host "[BARU] File baru ditambahkan: $relativePath" -ForegroundColor DarkGreen
                }

                Copy-Item -Path $file.FullName -Destination $destFile -Force
            }
        } 
        # --- JIKA SUMBER ADALAH FILE SATUAN ---
        else {
            $destDir = Split-Path $DestinationPath -Parent
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Force -Path $destDir | Out-Null
            }

            if (Test-Path $DestinationPath) {
                $diff = Compare-Object (Get-Content $DestinationPath -ErrorAction SilentlyContinue) (Get-Content $SourcePath -ErrorAction SilentlyContinue)
                
                if ($diff) {
                    Write-Host "`n[DIFF] Perubahan terdeteksi pada file: $($config.Name)" -ForegroundColor Yellow
                    foreach ($d in $diff) {
                        $symbol = if ($d.SideIndicator -eq "=>") { "+" } else { "-" }
                        $color = if ($d.SideIndicator -eq "=>") { "Green" } else { "Red" }
                        Write-Host "  $symbol $($d.InputObject)" -ForegroundColor $color
                    }
                }
            } else {
                Write-Host "[BARU] File baru ditambahkan: $($config.Name)" -ForegroundColor DarkGreen
            }

            Copy-Item -Path $SourcePath -Destination $DestinationPath -Force
        }

        Write-Host "`n[SUKSES] Selesai menyalin & memperbarui $($config.Name)!`n" -ForegroundColor Green
    } else {
        Write-Host "[GAGAL] Sumber tidak ditemukan di: $SourcePath`n" -ForegroundColor Red
    }
}