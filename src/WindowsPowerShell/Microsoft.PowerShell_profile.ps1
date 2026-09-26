function Invoke-GitLazy {
    # Menggabungkan semua argumen yang dikirim
    $inputArgs = $args -join " "

    # Jika tidak ada argumen, minta user untuk input manual
    if ([string]::IsNullOrWhiteSpace($inputArgs)) {
        $inputArgs = Read-Host "Enter commit message"
    }

    # Memisahkan kata pertama sebagai scope, dan sisanya sebagai message
    $parts = $inputArgs -split ' ', 2
    $scope = $parts[0]
    $message = if ($parts.Length -gt 1) { $parts[1] } else { "" }

    $formattedMsg = "[$scope]: $message"

    Write-Host "Proposed commit message:"
    Write-Host $formattedMsg
    Write-Host ""

    # Meminta konfirmasi (y/n)
    $confirm = Read-Host "Do you want to run git add, commit, and push? (y/n)"

    if ($confirm -eq 'y' -or $confirm -eq 'Y') {
        git add .
        git commit -m $formattedMsg
        git push
        Write-Host "Git add, commit, and push completed." -ForegroundColor Green
    } else {
        Write-Host "Process aborted." -ForegroundColor Yellow
    }
}

# Membuat alias agar command-nya lebih pendek dan mudah diketik
Set-Alias -Name cmt -Value Invoke-GitLazy


function rmdir-force {
    param([string]$Path)
    if ($Path) {
        Remove-Item -Path $Path -Recurse -Force
    } else {
        Write-Warning "Mohon masukkan path folder yang ingin dihapus."
    }
}

Set-Alias fdel rmdir-force

$newPaths = @(
    "$HOME\AppData\Local\pnpm\bin",
    "D:\llvm-mingw-20260922-ucrt-x86_64\llvm-mingw-20260922-ucrt-x86_64\bin",
    "$HOME\scoop\shims"
)

# 1. Ambil PATH lama dari User
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($null -eq $currentPath) { $currentPath = "" }

# 2. Gabungkan secara aman (tanpa regex -split)
$pathList = $currentPath.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)
$updatedPath = ($pathList + $newPaths) | Select-Object -Unique

# 3. Simpan ke Registry secara permanen
[Environment]::SetEnvironmentVariable("Path", ($updatedPath -join ';'), "User")

# 4. CRITICAL: Perbarui $env:Path milik sesi PowerShell aktif saat ini juga!
foreach ($path in $newPaths) {
    if ($env:Path -split ';' -notcontains $path) {
        $env:Path += ";$path"
    }
}

# Jalur folder utama tempat toolchain Anda berada
# (Sesuaikan dengan lokasi folder riil tempat file .bat Anda berada)
$MSVC_BASE_DIR = "D:\MSVC-14.51.36231\MSVC"

function Enable-Msvc {
    [CmdletBinding()]
    param()

    # 1. Cek apakah sudah aktif
    if ($env:MSVC_ENV_ACTIVE -eq "True") {
        Write-Host "Info: Lingkungan MSVC sudah aktif." -ForegroundColor Yellow
        return
    }

    Write-Host "Memuat lingkungan MSVC dan Windows SDK x64..." -ForegroundColor Cyan

    # 2. Backup variable asli terminal
    $script:Original_Path    = $env:PATH
    $script:Original_Include = $env:INCLUDE
    $script:Original_Lib     = $env:LIB

    # 3. Definisikan jalur internal compiler
    $env:VCToolsInstallDir = "$MSVC_BASE_DIR\VC\Tools\MSVC\14.51.36231\"
    $env:WindowsSdkBinPath = "$MSVC_BASE_DIR\Windows Kits\10\bin\"

    $msvcBin = "$MSVC_BASE_DIR\VC\Tools\MSVC\14.51.36231\bin\Hostx64\x64"
    $sdkBin  = "$MSVC_BASE_DIR\Windows Kits\10\bin\10.0.28000.0\x64"
    $ucrtBin = "$MSVC_BASE_DIR\Windows Kits\10\bin\10.0.28000.0\x64\ucrt"

    # 4. Terapkan Environment Baru
    $env:PATH = "$msvcBin;$sdkBin;$ucrtBin;$env:PATH"

    $env:INCLUDE = @(
        "$MSVC_BASE_DIR\VC\Tools\MSVC\14.51.36231\include",
        "$MSVC_BASE_DIR\Windows Kits\10\Include\10.0.28000.0\ucrt",
        "$MSVC_BASE_DIR\Windows Kits\10\Include\10.0.28000.0\shared",
        "$MSVC_BASE_DIR\Windows Kits\10\Include\10.0.28000.0\um",
        "$MSVC_BASE_DIR\Windows Kits\10\Include\10.0.28000.0\winrt",
        "$MSVC_BASE_DIR\Windows Kits\10\Include\10.0.28000.0\cppwinrt"
    ) -join ';'

    $env:LIB = @(
        "$MSVC_BASE_DIR\VC\Tools\MSVC\14.51.36231\lib\x64",
        "$MSVC_BASE_DIR\Windows Kits\10\Lib\10.0.28000.0\ucrt\x64",
        "$MSVC_BASE_DIR\Windows Kits\10\Lib\10.0.28000.0\um\x64"
    ) -join ';'

    $env:MSVC_ENV_ACTIVE = "True"
    Write-Host "Sukses: Lingkungan MSVC Aktif! cl.exe siap digunakan." -ForegroundColor Green
}
Enable-Msvc
