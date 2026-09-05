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

Set-Alias -Name runenv -Value Invoke-CmdEnvironment
runenv "$HOME/Desktop/TMP/MSVC-14.51.36231/MSVC/setup_x64.bat"

function rmdir-force {
    param([string]$Path)
    if ($Path) {
        Remove-Item -Path $Path -Recurse -Force
    } else {
        Write-Warning "Mohon masukkan path folder yang ingin dihapus."
    }
}
Set-Alias fdel rmdir-force
