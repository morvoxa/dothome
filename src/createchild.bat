@echo off
:: Cek apakah dijalankan sebagai Administrator, jika belum otomatis minta izin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Meminta izin Administrator...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"

:: ==========================================
:: KONFIGURASI PATH MASTER VHDX ANDA
:: ==========================================
set "MasterVHDX=C:\newmaster.vhdx"
set "TargetFolder=C:\"

cls
echo ==========================================
echo    SCRIPT PEMBUATAN TURUNAN VHDX (HYPER-V)
echo ==========================================
echo Master VHDX: %MasterVHDX%
echo.

set /p "NamaVM=Masukkan nama untuk turunan VHDX baru: "

if "%NamaVM%"=="" (
    echo Nama tidak boleh kosong!
    pause
    exit
)

set "ChildVHDX=%TargetFolder%%NamaVM%.vhdx"

if exist "%ChildVHDX%" (
    echo Error: File VHDX dengan nama '%NamaVM%' sudah ada di lokasi tersebut!
    pause
    exit
)

echo.
echo Sedang membuat Differencing Disk...
powershell -Command "New-VHD -Path '%ChildVHDX%' -ParentPath '%MasterVHDX%' -Differencing"

echo.
echo Berhasil! VHDX turunan telah dibuat di:
echo %ChildVHDX%
echo.
pause
