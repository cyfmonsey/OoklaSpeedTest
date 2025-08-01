# === CONFIG ===
$tempDir = "$env:TEMP\speedtest-cli"
$zipUrl = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"
$zipFile = "$tempDir\speedtest.zip"
$exePath = "$tempDir\speedtest.exe"
$fakeName = "$tempDir\teamviewer.exe"  # Change this to whatever name you want

# === SETUP ===
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

# === DOWNLOAD ===
Write-Host "`n[INFO] Downloading Speedtest CLI..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -UseBasicParsing

# === EXTRACT === (PowerShell 5.1-compatible ZIP extraction)
Write-Host "[INFO] Extracting..." -ForegroundColor Yellow
$shell = New-Object -ComObject Shell.Application
$zip = $shell.NameSpace($zipFile)
$destination = $shell.NameSpace($tempDir)
$destination.CopyHere($zip.Items(), 0x10)  # 0x10 = No UI

# Wait for extract to finish
Start-Sleep -Seconds 2

# === RENAME EXE (Optional) ===
if (Test-Path $exePath) {
    Rename-Item -Path $exePath -NewName ([System.IO.Path]::GetFileName($fakeName)) -Force
    Write-Host "[INFO] Renamed speedtest.exe to $(Split-Path $fakeName -Leaf)" -ForegroundColor Green
} else {
    Write-Host "[ERROR] speedtest.exe not found after extraction." -ForegroundColor Red
    Read-Host "`nPress Enter to exit"
    exit 1
}

# === RUN SPEEDTEST with visible output ===
Write-Host "`n[INFO] Running Speedtest..." -ForegroundColor Cyan
Start-Process -FilePath "$fakeName" -NoNewWindow -Wait

# === CLEANUP (optional) ===
# Remove-Item -Recurse -Force $tempDir

# === PAUSE ===
Write-Host "`nPress Enter to exit..." -ForegroundColor DarkGray
Read-Host