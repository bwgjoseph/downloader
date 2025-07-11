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
    $version = "2025.1.3"
}

if ([String]::IsNullOrWhiteSpace($build)) {
    $build = "251.26927.53"
}

$product_code="IU" # IntelliJ IDEA Ultimate
# 2022.2.3 - 222.4345.14
# 2022.3.2 - 223.8617.56
# 2023.1.3 - 231.9161.38
# 2023.2.5 - 232.10227.8
# 2023.3 - 233.11799.241
# 2023.3.3 - 233.14015.106
# 2023.3.4 - 233.14475.28
# 2023.3.6 - 233.15026.9
# 2024.1.1 - 241.15989.150
# 2024.1.2 - 241.17011.79
# 2024.1.3 - 241.17890.1
# 2024.2 - 242.20224.300
# 2024.2.1 - 242.21829.142
# 2024.2.3 - 242.23339.11
# 2024.3 - 243.21565.193
# 2024.3.1.1 - 243.22562.218
# 2024.3.2.1 - 243.23654.153
# 2024.3.4.1 - 243.25659.59
# 2025.1.1.1 - 251.25410.129
# 2025.1.2 - 251.26094.121
# 2025.1.3 - 251.26927.53
$build="251.26927.53"

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