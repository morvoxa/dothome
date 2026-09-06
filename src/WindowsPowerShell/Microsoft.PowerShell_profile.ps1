Invoke-Expression (&starship init powershell)
function Invoke-CmdEnvironment {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [string]$Arguments = ""
    )

    if (-not (Test-Path $Path)) {
        Write-Host "[ERROR] Batch file not found at: $Path" -ForegroundColor Red
        return
    }

    Write-Host "[INFO] Extracting environment variables from: $(Split-Path $Path -Leaf)..." -ForegroundColor Cyan

    $cmdOutput = cmd.exe /c " `"$Path`" $Arguments && set "

    foreach ($line in $cmdOutput) {
        if ($line -match "^([^=]+)=(.*)$") {
            $varName = $Matches[1].Trim()
            $varValue = $Matches[2].Trim()
            
            if ($varName -notin @('Prompt', 'CommandPromptType', 'PathExt')) {
                [Environment]::SetEnvironmentVariable($varName, $varValue, [System.EnvironmentVariableTarget]::Process)
            }
        }
    }

    Write-Host "[SUCCESS] Environment loaded! You are still inside PowerShell." -ForegroundColor Green
}

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

Set-Alias -Name runenv -Value Invoke-CmdEnvironment
runenv "$HOME/Desktop/src/MSVC-14.51.36231/MSVC/setup_x64.bat"

function rmdir-force {
    param([string]$Path)
    if ($Path) {
        Remove-Item -Path $Path -Recurse -Force
    } else {
        Write-Warning "Mohon masukkan path folder yang ingin dihapus."
    }
}
Set-Alias fdel rmdir-force
