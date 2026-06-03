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

# ------------------------------------------------------------
# Validate WSL command
# ------------------------------------------------------------
if (-not (Get-Command wsl -ErrorAction SilentlyContinue)) {
    Write-Host "WSL command is not available." -ForegroundColor Red
    Write-Host "Run bootstrap/bootstrap.ps1 first and reboot if required." -ForegroundColor Yellow
    exit 1
}

# ------------------------------------------------------------
# Set WSL2 as default
# ------------------------------------------------------------
Write-Host ""
Write-Host "Setting WSL default version to 2..." -ForegroundColor Cyan
wsl --set-default-version 2

# ------------------------------------------------------------
# Check installed distributions
# ------------------------------------------------------------
Write-Host ""
Write-Host "Checking installed WSL distributions..." -ForegroundColor Cyan

$InstalledDistrosRaw = wsl --list --quiet 2>$null
$InstalledDistros = $InstalledDistrosRaw | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

if ($InstalledDistros -contains $DistroName) {
    Write-Host "$DistroName is already installed. Skipping installation." -ForegroundColor Yellow
}
else {
    Write-Host "$DistroName is not installed. Installing..." -ForegroundColor Green
    Write-Host ""
    Write-Host "You may be asked to create a Linux username and password." -ForegroundColor Yellow

    wsl --install -d $DistroName
}

# ------------------------------------------------------------
# Set default distribution
# ------------------------------------------------------------
Write-Host ""
Write-Host "Setting default WSL distribution to $DistroName..." -ForegroundColor Cyan
wsl --set-default $DistroName

# ------------------------------------------------------------
# Verify result
# ------------------------------------------------------------
Write-Host ""
Write-Host "Current WSL distributions:" -ForegroundColor Cyan
wsl -l -v

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Open Ubuntu-24.04 from the Start Menu or run: wsl"
Write-Host "2. Complete Linux user creation if prompted."
Write-Host "3. Inside Ubuntu, clone or access your workstation repository."
Write-Host "4. Run: chmod +x bootstrap/bootstrap.sh"
Write-Host "5. Run: ./bootstrap/bootstrap.sh"

Write-Host ""
Write-Host "WSL Ubuntu installation phase completed." -ForegroundColor Green
