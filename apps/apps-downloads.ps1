Write-Host "Starting..."

$default_download_dir="./_applications"

# # For each application
Get-Content custom-applications.json | ConvertFrom-Json | ForEach-Object {
    Write-Host "Starting download for" $_.application $_.version
    # -L: follow redirect
    # -O -J: we want to retain the remote filename instead of constructing our own
    # see https://daniel.haxx.se/blog/2020/09/10/store-the-curl-output-over-there
    # --create-dirs: if not exist
    # --silent: do not show progress
    curl -L $_.download_url -O -J --output-dir $default_download_dir --create-dirs --silent
}

Write-Host "Completed"