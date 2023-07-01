# see https://plugins.jetbrains.com/docs/marketplace/plugin-update-download.html#1-download-the-latest-plugin-update-compatible-with-a-certain-product
# format
# https://plugins.jetbrains.com/pluginManager?action=download&id=<pluginXmlId>&build=<productCode>-<buildNumber>
# sample
# https://plugins.jetbrains.com/pluginManager?action=download&id=google-java-format&build=IU-221.5921.22
# build and version can be extracted from https://www.jetbrains.com/idea/download/other.html

# to sort
# Get-Content .\intellij-plugins.txt | sort | get-unique | Set-Content intellij-plugins.txt

# take arg from command line
param ($version, $build)

Write-Host "Starting..."

# Set to a default version if not provided
if ([String]::IsNullOrWhiteSpace($version)) {
    $version = "2023.1.2"
}

if ([String]::IsNullOrWhiteSpace($build)) {
    $build = "231.9011.34"
}

$product_code="IU" # IntelliJ IDEA Ultimate
# 2022.1.3 - 221.5921.22
# 2022.2 - 222.3345.118
# 2022.2.3 - 222.4345.14
# 2022.3.1 - 223.8214.52
# 2022.3.2 - 223.8617.56
# 2023.1 - 231.8109.175
# 2023.1.1 - 231.8770.65
# 2023.1.2 - 231.9011.34
$build="231.9011.34"

$default_download_dir="./_intellij_plugins_$version"

# Stores commands to install extension
$batchInstallArray=@()

Write-Host $default_download_dir

# For each plugin
Get-Content .\intellij-plugins.txt | ForEach-Object {
    $plugin=$_

    Write-Host "Starting download for $plugin"

    $url="https://plugins.jetbrains.com/pluginManager?action=download&id=$plugin&build=$product_code-$build"

    # -L: follow redirect
    # -O -J: we want to retain the remote filename instead of constructing our own
    # see https://daniel.haxx.se/blog/2020/09/10/store-the-curl-output-over-there
    # --create-dirs: if not exist
    # --silent: do not show progress
    curl -L $url -O -J --output-dir $default_download_dir --create-dirs --silent

    $batchInstallArray += "idea64.exe installPlugins $plugin"

    Write-Host "Completed"
}

Write-Host "Writing install script to $default_download_dir"

$batchInstallArray | Out-File -Append $default_download_dir/_install.bat

Write-Host "Write to file Completed"