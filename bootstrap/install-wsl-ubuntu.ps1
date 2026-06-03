# ============================================================
# Install WSL Ubuntu 24.04
# Workstation Bootstrap - Phase 2
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DistroName = "Ubuntu-24.04"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "WSL Ubuntu 24.04 Installation" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

if (-not (Get-Command wsl -ErrorAction SilentlyContinue)) {
    Write-Host "WSL command is not available." -ForegroundColor Red
    Write-Host "Run bootstrap/bootstrap.ps1 first and reboot if required." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Updating WSL..." -ForegroundColor Cyan
wsl --update

Write-Host ""
Write-Host "Setting WSL default version to 2..." -ForegroundColor Cyan
wsl --set-default-version 2

Write-Host ""
Write-Host "Checking installed WSL distributions..." -ForegroundColor Cyan
$InstalledDistrosRaw = wsl --list --quiet 2>$null
$InstalledDistros = $InstalledDistrosRaw | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

if ($InstalledDistros -contains $DistroName) {
    Write-Host "$DistroName is already installed. Skipping installation." -ForegroundColor Yellow
}
else {
    Write-Host "$DistroName is not installed. Installing without launching..." -ForegroundColor Green

    wsl --install -d $DistroName --no-launch --web-download

    Write-Host ""
    Write-Host "$DistroName has been installed but not launched." -ForegroundColor Green
}

Write-Host ""
Write-Host "Setting default WSL distribution to $DistroName..." -ForegroundColor Cyan
wsl --set-default $DistroName

Write-Host ""
Write-Host "Current WSL distributions:" -ForegroundColor Cyan
wsl -l -v

Write-Host ""
Write-Host "Manual next step:" -ForegroundColor Yellow
Write-Host "Open Ubuntu-24.04 from the Start Menu or run:"
Write-Host ""
Write-Host "    wsl -d Ubuntu-24.04"
Write-Host ""
Write-Host "Then create the Linux user manually when prompted."
Write-Host "Recommended username: santiago"
Write-Host ""
Write-Host "After user creation, verify:"
Write-Host ""
Write-Host "    whoami"
Write-Host "    pwd"
Write-Host "    cat /etc/os-release"
Write-Host ""
Write-Host "WSL Ubuntu installation phase completed." -ForegroundColor Green
