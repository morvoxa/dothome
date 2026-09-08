Invoke-Expression (&starship init powershell)
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
