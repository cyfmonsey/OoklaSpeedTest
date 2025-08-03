#Requires -Version 5.1
[CmdletBinding()]
param()

# === CONFIG ===
$tempDir = Join-Path $env:TEMP "speedtest-cli"
$zipUrl  = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"
$zipFile = Join-Path $tempDir "speedtest.zip"
$exePath = Join-Path $tempDir "speedtest.exe"
$fakeName = 'teamviewer.exe'
$fakeExePath = Join-Path $tempDir $fakeName

# --- SCRIPT BODY ---
try {
    # === SETUP ===
    if (-not (Test-Path $tempDir)) {
        New-Item -ItemType Directory -Path $tempDir | Out-Null
    }

    # === DOWNLOAD, EXTRACT, & RENAME ===
    if (-not (Test-Path $fakeExePath)) {
        Write-Host "[INFO] Downloading Speedtest CLI..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -ErrorAction Stop

        Write-Host "[INFO] Extracting..." -ForegroundColor Yellow
        Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force -ErrorAction Stop
        
        Write-Host "[INFO] Renaming speedtest.exe to $fakeName" -ForegroundColor Green
        Rename-Item -Path $exePath -NewName $fakeName -Force -ErrorAction Stop
    }
    else {
        Write-Host "[INFO] Using existing executable: $fakeName" -ForegroundColor Cyan
    }

    # === RUN SPEEDTEST ===
    Write-Host "`n[INFO] Running Speedtest..." -ForegroundColor Cyan
    # Execute the renamed file and automatically accept the license to prevent SSL errors
    & $fakeExePath --accept-license

}
catch {
    # This block runs if any command with "-ErrorAction Stop" fails.
    Write-Host "[ERROR] A problem occurred:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
finally {
    # === AUTOMATIC CLEANUP ===
    if (Test-Path $tempDir) {
        Write-Host "`n[INFO] Cleaning up temporary files..." -ForegroundColor DarkGray
        Remove-Item -Recurse -Force $tempDir
    }
    
    # === PAUSE ===
    Write-Host "`nPress Enter to exit..." -ForegroundColor DarkGray
    Read-Host | Out-Null
}