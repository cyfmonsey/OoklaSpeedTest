# === CONFIG ===
$tempDir = "$env:TEMP\speedtest-cli"
$zipUrl = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"
$zipFile = "$tempDir\speedtest.zip"
$exePath = "$tempDir\speedtest.exe"

# === SETUP ===
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

# === DOWNLOAD ===
Write-Host "`n[INFO] Downloading Speedtest CLI..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile

# === EXTRACT ===
Write-Host "[INFO] Extracting..." -ForegroundColor Yellow
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile, $tempDir)

# === RUN SPEEDTEST with live output ===
Write-Host "`n[INFO] Running Speedtest..." -ForegroundColor Cyan
Start-Process -FilePath "$exePath" -NoNewWindow -Wait

# === CLEANUP (optional) ===
# Remove-Item -Recurse -Force $tempDir

# === PAUSE ===
Write-Host "`nPress Enter to exit..." -ForegroundColor DarkGray
Read-Host