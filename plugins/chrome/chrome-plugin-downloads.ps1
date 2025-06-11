Write-Host "Starting..."

$default_download_dir="./_chrome"

$chromeVersion = "137.0.7151.69"

# # For each application
Get-Content .\chrome-plugins.txt | ForEach-Object {
    $extName, $extId = $_ -split ' '

    # source for url > https://stackoverflow.com/questions/72854391/how-can-i-download-a-chrome-extension-crx-file-with-the-manifest-in-version-3-gi
    $download_url = "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=$chromeVersion&acceptformat=crx2,crx3&x=id%3D$extId%26uc"

    Write-Host "Starting download for $extName"
    # -L: follow redirect
    # --create-dirs: if not exist
    # --silent: do not show progress
    curl -L $download_url -o "$default_download_dir/$extName.crx" --create-dirs --silent
}

Write-Host "Completed"
