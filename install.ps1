# Ensure running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

# Function to check if package is installed
function IsPackageInstalled {
    param(
        [string]$packageId
    )

    $installedPackages = winget list --id $packageId -e
    return $installedPackages -notmatch "No installed package found"
}

# Installation toggles
$installWindhawk = $true
$installYasb = $true
$installWindowsTerminal = $true
$installAutoHotKey = $true
$installOhMyPosh = $true

# Install Windhawk
if ($installWindhawk -and -not (IsPackageInstalled -packageId "RamenSoftware.Windhawk")) {
    Write-Host "Installing Windhawk..." -ForegroundColor Cyan
    winget install --id RamenSoftware.Windhawk -e
    Write-Host "Windhawk installation complete." -ForegroundColor Green
} elseif ($installWindhawk) {
    Write-Host "Windhawk is already installed." -ForegroundColor Green
}

# Install yasb and apply settings
if ($installYasb -and -not (IsPackageInstalled -packageId "AmN.yasb")) {
    Write-Host "Installing yasb..." -ForegroundColor Cyan
    $komorebiConfig = "./yasb/komorebi.json"
    $komorebiConfigDestination = "$env:USERPROFILE\komorebi.json"
    winget install --id AmN.yasb -e
    Copy-Item -Path $komorebiConfig -Destination $komorebiConfigDestination -Force
    Write-Host "yasb installation and configuration applied." -ForegroundColor Green
} elseif ($installYasb) {
    Write-Host "yasb is already installed." -ForegroundColor Green
}

# Install AutoHotKey
if ($installAutoHotKey -and -not (IsPackageInstalled -packageId "AutoHotkey.AutoHotkey")) {
    Write-Host "Installing AutoHotKey..." -ForegroundColor Cyan
    winget install --id AutoHotkey.AutoHotkey -e
    $autoHotKeyScripts = Get-ChildItem -Path "./AutoHotKey/*.ahk"
    foreach ($script in $autoHotKeyScripts) {
        Copy-Item -Path $script.FullName -Destination "$env:USERPROFILE\AutoHotKeyScripts" -Force
    }
    Write-Host "AutoHotKey installation and script setup complete." -ForegroundColor Green
} elseif ($installAutoHotKey) {
    Write-Host "AutoHotKey is already installed." -ForegroundColor Green
}

# Apply Windows Terminal Settings
if ($installWindowsTerminal) {
    Write-Host "Checking if Windows Terminal is installed..." -ForegroundColor Cyan
    if (-not (IsPackageInstalled -packageId "Microsoft.WindowsTerminal")) {
        Write-Host "Windows Terminal is not installed. Installing..." -ForegroundColor Yellow
        winget install --id Microsoft.WindowsTerminal -e
        Write-Host "Windows Terminal installation complete." -ForegroundColor Green
    } else {
        Write-Host "Windows Terminal is already installed." -ForegroundColor Green
    }
    Write-Host "Applying Windows Terminal settings..." -ForegroundColor Cyan
    $twSettingJson = "./wt/settings.json"
    $wtSettingsDestination = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    Copy-Item -Path $twSettingJson -Destination $wtSettingsDestination -Force
    Write-Host "Windows Terminal settings applied." -ForegroundColor Green
}

# Install Oh-My-Posh, fonts, and apply config
if ($installOhMyPosh -and -not (IsPackageInstalled -packageId "JanDeDobbeleer.OhMyPosh")) {
    Write-Host "Installing Oh-My-Posh and setting up fonts..." -ForegroundColor Cyan
    $ohMyPoshProfile = "./oh-my-posh/Microsoft.PowerShell_profile.ps1"
    $ohMyPoshFonts = Get-ChildItem -Path "./oh-my-posh/0xProtoNerdFont*.ttf"

    $fontDestination = "$env:WINDIR\Fonts"
    foreach ($font in $ohMyPoshFonts) {
        Copy-Item -Path $font.FullName -Destination $fontDestination -Force
    }

    winget install --id JanDeDobbeleer.OhMyPosh -e
    Copy-Item -Path $ohMyPoshProfile -Destination $PROFILE
    Write-Host "Oh-My-Posh installation and configuration applied." -ForegroundColor Green
} elseif ($installOhMyPosh) {
    Write-Host "Oh-My-Posh is already installed." -ForegroundColor Green
}

Write-Host "Configuration completed successfully!" -ForegroundColor Green
