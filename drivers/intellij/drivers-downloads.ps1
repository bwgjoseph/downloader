# To sort
# Get-Content .\custom-applications.json | ConvertFrom-Json | Sort-Object id | ConvertTo-Json | Set-Content custom-applications.json

# Source = https://www.jetbrains.com/datagrip/jdbc-drivers/

Write-Host "Starting..."

$default_download_dir="./_intellij_jdbc_drivers"

# # For each application
Get-Content intellij-jdbc-drivers.json | ConvertFrom-Json | ForEach-Object {
    Write-Host "Starting download for" $_.driver $_.version

    $driver=$_.driver
    $version=$_.version

    # -L: follow redirect
    # -O -J: we want to retain the remote filename instead of constructing our own
    # see https://daniel.haxx.se/blog/2020/09/10/store-the-curl-output-over-there
    # --create-dirs: if not exist
    # --silent: do not show progress

    $download_url="https://download.jetbrains.com/idea/jdbc-drivers/web/$driver-$version.zip"

    Write-Host $download_url

    curl -L $download_url -O -J --output-dir $default_download_dir --create-dirs --silent
}

Write-Host "Completed"