# This script uses the specific URL you provided.
[CmdletBinding()]
param()

# === CONFIGURATION ===
$zipUrl      = "https://github.com/librespeed/speedtest-cli/releases/download/v1.0.12/librespeed-cli_1.0.12_windows_amd64.zip"
$tempDir     = Join-Path $env:TEMP "librespeed-cli"
$exePath     = Join-Path $tempDir "librespeed-cli.exe"
$fakeName    = 'teamviewer.exe'
$fakeExePath = Join-Path $tempDir $fakeName

# === SCRIPT BODY ===
try {
    # --- Step 1: Check if the file exists and download if needed ---
    if (-not (Test-Path $exePath)) {
        Write-Host "[INFO] File not found. Downloading from your link..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $tempDir -ErrorAction SilentlyContinue | Out-Null
        
        $zipFile = Join-Path $tempDir "download.zip"
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -ErrorAction Stop
        
        Write-Host "[INFO] Extracting..." -ForegroundColor Yellow
        Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force -ErrorAction Stop
        Remove-Item $zipFile -Force
    }

    # --- Step 2: Verify file, then rename it ---
    if (-not (Test-Path $exePath)) {
        throw "Extraction failed. Could not find 'librespeed-cli.exe' in '$tempDir'."
    }
    
    Write-Host "[INFO] Renaming librespeed-cli.exe to $fakeName" -ForegroundColor Green
    Rename-Item -Path $exePath -NewName $fakeName -Force
    
    # --- Step 3: Run the test ---
    Write-Host "`n[INFO] Running LibreSpeed Test..." -ForegroundColor Cyan
    & $fakeExePath --telemetry-level disabled

}
catch {
    Write-Host "[ERROR] A problem occurred:" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
finally {
    # --- Step 4: Clean up ---
    if (Test-Path $tempDir) {
        Write-Host "`n[INFO] Cleaning up temporary files..." -ForegroundColor DarkGray
        Remove-Item -Recurse -Force $tempDir
    }
    
    # --- Step 5: Pause ---
    Write-Host "`nPress Enter to exit..." -ForegroundColor DarkGray
    Read-Host | Out-Null
}
