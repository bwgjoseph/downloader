# take arg from command line
param ($version, $build)

Write-Host "Starting..."

# Set to a default version if not provided
if ([String]::IsNullOrWhiteSpace($version)) {
    $version = "1.4.3"
}

$default_download_dir="./_duckdb_extensions_$version"

Write-Host $default_download_dir

# For each plugin
Get-Content .\duckdb-extensions-core.txt | ForEach-Object {
    $plugin=$_

    Write-Host "Starting download for $plugin"

    $url="https://extensions.duckdb.org/v$version/windows_amd64/$plugin.duckdb_extension.gz"

    # -L: follow redirect
    # -O -J: we want to retain the remote filename instead of constructing our own
    # see https://daniel.haxx.se/blog/2020/09/10/store-the-curl-output-over-there
    # --create-dirs: if not exist
    # --silent: do not show progress
    curl -L $url -O -J --output-dir $default_download_dir --create-dirs --silent

    Write-Host "Completed"
}

# For each plugin
Get-Content .\duckdb-extensions-community.txt | ForEach-Object {
    $plugin=$_

    Write-Host "Starting download for $plugin"

    $url="https://community-extensions.duckdb.org/v$version/windows_amd64/$plugin.duckdb_extension.gz"

    # -L: follow redirect
    # -O -J: we want to retain the remote filename instead of constructing our own
    # see https://daniel.haxx.se/blog/2020/09/10/store-the-curl-output-over-there
    # --create-dirs: if not exist
    # --silent: do not show progress
    curl -L $url -O -J --output-dir $default_download_dir --create-dirs --silent

    Write-Host "Completed"
}

Write-Host "Write to file Completed"