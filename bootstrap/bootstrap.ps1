# ============================================================
# Workstation Bootstrap - Windows
# Cloud / AI Architect base setup
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "Starting Windows workstation bootstrap..." -ForegroundColor Cyan

# ------------------------------------------------------------
# Resolve winget
# ------------------------------------------------------------
$WingetPath = $null

if (Get-Command winget -ErrorAction SilentlyContinue) {
    $WingetPath = "winget"
}
elseif (Test-Path "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe") {
    $WingetPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"
    $env:Path += ";$env:LOCALAPPDATA\Microsoft\WindowsApps"
}
else {
    Write-Host "winget is not available." -ForegroundColor Red
    Write-Host "Install or update 'App Installer' from Microsoft Store first." -ForegroundColor Yellow
    Write-Host "Microsoft Store package: App Installer" -ForegroundColor Yellow
    exit 1
}

Write-Host "winget found: $WingetPath" -ForegroundColor Green

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
        $result = & $WingetPath list --id $Id --exact --accept-source-agreements 2>$null

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

        & $WingetPath install `
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
# Install VSCode extension only if missing
# ------------------------------------------------------------
function Install-VSCodeExtension {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ExtensionId
    )

    Write-Host ""
    Write-Host "Checking VSCode extension: $ExtensionId" -ForegroundColor Cyan

    if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
        Write-Host "VSCode CLI 'code' is not available. Open VSCode once or check PATH." -ForegroundColor Red
        return
    }

    try {
        $installedExtensions = code --list-extensions

        if ($installedExtensions -contains $ExtensionId) {
            Write-Host "$ExtensionId already installed. Skipping." -ForegroundColor Yellow
        }
        else {
            Write-Host "Installing $ExtensionId..." -ForegroundColor Green

            code --install-extension $ExtensionId

            if ($LASTEXITCODE -eq 0) {
                Write-Host "$ExtensionId installed successfully." -ForegroundColor Green
            }
            else {
                Write-Host "Installation failed for VSCode extension $ExtensionId. Please review manually." -ForegroundColor Red
            }
        }
    }
    catch {
        Write-Host "Unable to install extension $ExtensionId" -ForegroundColor Red
    }
}

# ------------------------------------------------------------
# Windows base tools
# ------------------------------------------------------------
$Packages = @(
    # Core
    @{ Id = "Git.Git"; Name = "Git for Windows" },
    @{ Id = "Microsoft.VisualStudioCode"; Name = "Visual Studio Code" },
    @{ Id = "Microsoft.WindowsTerminal"; Name = "Windows Terminal" },
    @{ Id = "Microsoft.PowerShell"; Name = "PowerShell 7" },
    @{ Id = "Google.Chrome"; Name = "Google Chrome" },

    # Azure / Cloud
    @{ Id = "Microsoft.AzureCLI"; Name = "Azure CLI" },
    @{ Id = "Microsoft.Azure.StorageExplorer"; Name = "Azure Storage Explorer" },

    # Containers
    @{ Id = "Docker.DockerDesktop"; Name = "Docker Desktop" },

    # Security / Secrets
    @{ Id = "AgileBits.1Password"; Name = "1Password" },
    @{ Id = "AgileBits.1Password.CLI"; Name = "1Password CLI" },

    # GitHub
    @{ Id = "GitHub.cli"; Name = "GitHub CLI" },

    # Architecture / API / Productivity
    @{ Id = "JGraph.Draw"; Name = "Draw.io Desktop" },
    @{ Id = "Postman.Postman"; Name = "Postman" },
    @{ Id = "Microsoft.PowerToys"; Name = "Microsoft PowerToys" },

    # Daily Windows utilities
    @{ Id = "Notepad++.Notepad++"; Name = "Notepad++" },
    @{ Id = "Greenshot.Greenshot"; Name = "Greenshot" },
    @{ Id = "Adobe.Acrobat.Reader.64-bit"; Name = "Adobe Acrobat Reader" },
    @{ Id = "WinSCP.WinSCP"; Name = "WinSCP" },

    # Network / Legacy troubleshooting
    @{ Id = "PuTTY.PuTTY"; Name = "PuTTY" },
    @{ Id = "WiresharkFoundation.Wireshark"; Name = "Wireshark" }
)

foreach ($Package in $Packages) {
    Install-WingetPackage -Id $Package.Id -Name $Package.Name
}

# ------------------------------------------------------------
# VSCode extensions - Windows side
# ------------------------------------------------------------
Write-Host ""
Write-Host "Installing VSCode Windows extensions..." -ForegroundColor Cyan

$VSCodeWindowsExtensions = @(
    "ms-vscode-remote.remote-wsl",
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-containers",
    "ms-vscode.remote-explorer"
)

foreach ($Extension in $VSCodeWindowsExtensions) {
    Install-VSCodeExtension -ExtensionId $Extension
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
Write-Host "2. Execute bootstrap/install-wsl-ubuntu.ps1 if Ubuntu-24.04 is not installed yet."
Write-Host "3. Open VSCode."
Write-Host "4. Connect to Ubuntu using:"
Write-Host "   Ctrl + Shift + P"
Write-Host "   WSL: Connect to WSL using Distro..."
Write-Host "   Ubuntu-24.04"
Write-Host "5. From WSL, open ~/dev/personal/workstation."
Write-Host "6. Run bootstrap/bootstrap.sh inside WSL."
Write-Host "7. Run bootstrap/install-vscode-wsl.sh inside WSL."
