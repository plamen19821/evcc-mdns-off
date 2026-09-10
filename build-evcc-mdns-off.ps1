param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$ErrorActionPreference = "Stop"

$Repo = "C:\Users\Pako\Desktop\evcc\evcc-mdns-off-github"

Set-Location $Repo

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " EVCC mDNS OFF - Release Builder" -ForegroundColor Cyan
Write-Host " EVCC Version: $Version" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# EVCC_VERSION ohne BOM schreiben
[System.IO.File]::WriteAllText(
    "$Repo\EVCC_VERSION",
    $Version,
    $Utf8NoBom
)

# HA config.yaml aktualisieren
$ConfigFile = "$Repo\evcc-mdns-off\config.yaml"

$Config = [System.IO.File]::ReadAllText($ConfigFile)

# Version
$Config = $Config -replace 'version:\s*"[^"]+"', "version: `"$Version`""

# Aktuelle HA-Syntax
$Config = $Config -replace 'type:\s*addon_config', 'type: app_config'

# WebUI-Port
$Config = $Config -replace 'webui:\s*"http://\[HOST\]:7070"', 'webui: "http://[HOST]:[PORT:7070]"'

[System.IO.File]::WriteAllText(
    $ConfigFile,
    $Config,
    $Utf8NoBom
)

Write-Host "Version und HA-Konfiguration aktualisiert." -ForegroundColor Green
Write-Host ""

# Git
git add EVCC_VERSION .\evcc-mdns-off\config.yaml

if (git diff --cached --quiet) {
    Write-Host "Keine Änderungen vorhanden." -ForegroundColor Yellow
}
else {
    git commit -m "Build EVCC $Version"
    git push
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " FERTIG - GitHub Build ausgelöst" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "EVCC Version: $Version"
Write-Host "GitHub Actions:"
Write-Host "https://github.com/plamen19821/evcc-mdns-off/actions"
Write-Host ""