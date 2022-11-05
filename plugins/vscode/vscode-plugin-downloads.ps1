# credits to https://github.com/deskoh/download-scripts/blob/main/vscode-visx.sh for the marketplace API

# to sort
# Get-Content .\vscode-plugins.txt | sort | get-unique | Set-Content vscode-plugins.txt

Write-Host "Starting..."

$default_download_dir="./_vscode_plugins"

$header_accept="Accept: application/json;api-version=7.1-preview.1"
$header_content_type="Content-Type: application/json"
$url="https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery"

# Stores commands to install extension
$batchInstallArray=@()

# # For each plugin
Get-Content .\vscode-plugins.txt | ForEach-Object {
    $plugin=$_

    $data_binary = ConvertTo-Json -Depth 10 -Compress -InputObject @{
        "assetTypes" = @("Microsoft.VisualStudio.Services.VSIXPackage")
        "filters" = @(
            @{
                "criteria" = @(
                    @{
                        "filterType" = 7
                        "value" = "$plugin"
                    }
                )
            }
        )
        "flags" = 3
    }

    Write-Host "Starting download for $plugin"

    # make post request to vscode marketplace
    $result="$data_binary" | curl -s -XPOST $url --header $header_accept --header $header_content_type --data '@-'

    # parse the result
    # $extension_name=$result | jq -r '.results[0].extensions[0].extensionName'
    $extension_url=$result | jq -r '.results[0].extensions[0].versions[0].files[0].source'
    $extension_version=$result | jq -r '.results[0].extensions[0].versions[0].version'

    # -L: follow redirect
    # --create-dirs: if not exist
    # --silent: do not show progress
    curl -L $extension_url -o "$default_download_dir/$plugin-$extension_version.vsix" --create-dirs --silent

    $batchInstallArray += "call code --install-extension $plugin-$extension_version.vsix"

    Write-Host "Downloads Completed"
}

Write-Host "Writing install script to $default_download_dir"

$batchInstallArray | Out-File -Append $default_download_dir/_install.bat

Write-Host "Write to file Completed"