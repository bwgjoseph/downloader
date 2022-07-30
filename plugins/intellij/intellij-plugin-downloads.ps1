# see https://plugins.jetbrains.com/docs/marketplace/plugin-update-download.html#1-download-the-latest-plugin-update-compatible-with-a-certain-product
# format
# https://plugins.jetbrains.com/pluginManager?action=download&id=<pluginXmlId>&build=<productCode>-<buildNumber>
# sample
# https://plugins.jetbrains.com/pluginManager?action=download&id=google-java-format&build=IU-221.5921.22
# build and version can be extracted from https://www.jetbrains.com/idea/download/other.html

# to sort
# Get-Content .\intellij-plugins.txt | sort | get-unique | Set-Content intellij-plugins.txt

# take arg from command line
param ($version)

Write-Host "Starting..."

$product_code="IU" # IntelliJ IDEA Ultimate
$build_number="221.5921.22" # 2022.1.3

$default_download_dir="./_intellij_plugins_$version"

# # For each plugin
Get-Content .\intellij-plugins.txt | ForEach-Object {
    $plugin=$_

    Write-Host "Starting download for $plugin"

    $url="https://plugins.jetbrains.com/pluginManager?action=download&id=$plugin&build=$product_code-$build_number"

    # -L: follow redirect
    # -O -J: we want to retain the remote filename instead of constructing our own
    # see https://daniel.haxx.se/blog/2020/09/10/store-the-curl-output-over-there
    # --create-dirs: if not exist
    # --silent: do not show progress
    curl -L $url -O -J --output-dir $default_download_dir --create-dirs --silent

    Write-Host "Completed"
}
