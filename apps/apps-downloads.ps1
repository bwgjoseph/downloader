# To sort
# Get-Content .\custom-applications.json | ConvertFrom-Json | Sort-Object id | ConvertTo-Json | Set-Content custom-applications.json

param(
    [string]$DestDir,
    [string]$JsonFile = "custom-applications.json"
)

Write-Host "Starting..."
Write-Host "Configuration: $JsonFile"

$default_download_dir = if ($DestDir) { $DestDir } else { Join-Path $PSScriptRoot "_applications" }

# Ensure target directory exists
if (-not (Test-Path $default_download_dir)) {
    New-Item -ItemType Directory -Path $default_download_dir -Force | Out-Null
}

# # For each application
$configFile = Join-Path $PSScriptRoot $JsonFile
if (-not (Test-Path $configFile)) {
    Write-Error "Config file not found: $configFile"
    exit 1
}

Get-Content $configFile | ConvertFrom-Json | ForEach-Object {
    Write-Host "Starting download for" $_.application $_.version
    # -L: follow redirect
    # -O -J: we want to retain the remote filename instead of constructing our own
    # see https://daniel.haxx.se/blog/2020/09/10/store-the-curl-output-over-there
    # --create-dirs: if not exist
    # --silent: do not show progress
    if ($_.filename) {
        curl.exe -L $_.download_url -o $_.filename --output-dir $default_download_dir --create-dirs --silent
    } else {
        curl.exe -L $_.download_url -O -J --output-dir $default_download_dir --create-dirs --silent
    }
}

Write-Host "Completed"