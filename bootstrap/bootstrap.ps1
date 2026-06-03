# ============================================================
# Workstation Bootstrap - Windows
# Cloud / AI Architect base setup
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "Starting Windows workstation bootstrap..." -ForegroundColor Cyan

# ------------------------------------------------------------
# Validate winget
# ------------------------------------------------------------
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget is not available. Install 'App Installer' from Microsoft Store first." -ForegroundColor Red
    exit 1
}

# ------------------------------------------------------------
# Install package only if missing
# ------------------------------------------------------------
function Install-WingetPackage {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    Write-Host ""
    Write-Host "Checking $Name..." -ForegroundColor Cyan

    $isInstalled = $false

    try {
        $result = winget list --id $Id --exact --accept-source-agreements 2>$null
        if ($LASTEXITCODE -eq 0 -and $result -match [regex]::Escape($Id)) {
            $isInstalled = $true
        }
    }
    catch {
        $isInstalled = $false
    }

    if ($isInstalled) {
        Write-Host "$Name is already installed. Skipping." -ForegroundColor Yellow
    }
    else {
        Write-Host "$Name is not installed. Installing..." -ForegroundColor Green

        winget install `
            --id $Id `
            --exact `
            --source winget `
            --accept-package-agreements `
            --accept-source-agreements

        if ($LASTEXITCODE -eq 0) {
            Write-Host "$Name installed successfully." -ForegroundColor Green
        }
        else {
            Write-Host "Installation failed for $Name. Please review manually." -ForegroundColor Red
        }
    }
}

# ------------------------------------------------------------
# Windows base tools
# ------------------------------------------------------------
$Packages = @(
    @{ Id = "Git.Git"; Name = "Git for Windows" },
    @{ Id = "Microsoft.VisualStudioCode"; Name = "Visual Studio Code" },
    @{ Id = "Microsoft.WindowsTerminal"; Name = "Windows Terminal" },
    @{ Id = "Microsoft.PowerShell"; Name = "PowerShell 7" },
    @{ Id = "Google.Chrome"; Name = "Google Chrome" },

    @{ Id = "Microsoft.AzureCLI"; Name = "Azure CLI" },
    @{ Id = "Microsoft.Azure.StorageExplorer"; Name = "Azure Storage Explorer" },

    @{ Id = "Docker.DockerDesktop"; Name = "Docker Desktop" },

    @{ Id = "AgileBits.1Password"; Name = "1Password" },
    @{ Id = "AgileBits.1Password.CLI"; Name = "1Password CLI" },

    @{ Id = "GitHub.cli"; Name = "GitHub CLI" },

    @{ Id = "JGraph.Draw"; Name = "Draw.io Desktop" },
    @{ Id = "Postman.Postman"; Name = "Postman" },
    @{ Id = "Microsoft.PowerToys"; Name = "Microsoft PowerToys" }
)

foreach ($Package in $Packages) {
    Install-WingetPackage -Id $Package.Id -Name $Package.Name
}

# ------------------------------------------------------------
# WSL check
# ------------------------------------------------------------
Write-Host ""
Write-Host "Checking WSL..." -ForegroundColor Cyan

if (Get-Command wsl -ErrorAction SilentlyContinue) {
    Write-Host "WSL command is available." -ForegroundColor Yellow

    try {
        $wslStatus = wsl --status 2>$null
        Write-Host $wslStatus
    }
    catch {
        Write-Host "WSL exists, but status could not be checked." -ForegroundColor Yellow
    }
}
else {
    Write-Host "WSL is not available. Installing WSL..." -ForegroundColor Green
    wsl --install
    Write-Host "WSL installation started. A reboot may be required." -ForegroundColor Yellow
}

# ------------------------------------------------------------
# Standard development folders
# ------------------------------------------------------------
Write-Host ""
Write-Host "Creating standard development folders..." -ForegroundColor Cyan

$DevFolders = @(
    "C:\Dev",
    "C:\Dev\Personal",
    "C:\Dev\Cliente",
    "C:\Dev\IA",
    "C:\Dev\Labs",
    "C:\Dev\OpenSource"
)

foreach ($Folder in $DevFolders) {
    if (-not (Test-Path $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
        Write-Host "Created: $Folder" -ForegroundColor Green
    }
    else {
        Write-Host "Exists: $Folder" -ForegroundColor Yellow
    }
}

# ------------------------------------------------------------
# Final notes
# ------------------------------------------------------------
Write-Host ""
Write-Host "Windows bootstrap completed." -ForegroundColor Green

Write-Host ""
Write-Host "Recommended next steps:" -ForegroundColor Cyan
Write-Host "1. Restart Windows if WSL or Docker Desktop was installed."
Write-Host "2. Open Ubuntu WSL."
Write-Host "3. Run bootstrap/bootstrap.sh inside WSL."
Write-Host "4. Enable VS Code Settings Sync."
Write-Host "5. Import VS Code extensions from vscode/extensions.txt."