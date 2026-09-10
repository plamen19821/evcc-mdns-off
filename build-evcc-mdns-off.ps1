$ErrorActionPreference = "Stop"

$RepoPath = "C:\Users\Pako\Desktop\evcc\evcc-mdns-off-github"

Set-Location $RepoPath

Write-Host ""
Write-Host "=== EVCC mDNS OFF - GitHub Build anstoßen ===" -ForegroundColor Cyan
Write-Host ""

git status --short

$changes = git status --porcelain

if (-not $changes) {
    Write-Host ""
    Write-Host "Keine Änderungen vorhanden. Kein Push erforderlich." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Enter zum Beenden"
    exit
}

Write-Host ""
Write-Host "Änderungen werden committed..." -ForegroundColor Cyan

git add .

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "Update EVCC mDNS OFF - $timestamp"

Write-Host ""
Write-Host "Push zu GitHub..." -ForegroundColor Cyan

git push origin main

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Push erfolgreich." -ForegroundColor Green
Write-Host "GitHub Actions startet jetzt den Build." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Read-Host "Enter zum Beenden"