# credits to https://github.com/deskoh/download-scripts/blob/main/vscode-visx.sh for the marketplace API

# to sort
# Get-Content .\vscode-plugins.txt | sort | get-unique | Set-Content vscode-plugins.txt

Write-Host "Starting..."

$default_download_dir="./_vscode_plugins"

$header_accept="Accept: application/json;api-version=7.1-preview.1"
$header_content_type="Content-Type: application/json"
$url="https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery"

# # For each plugin
Get-Content .\vscode-plugins.txt | ForEach-Object {
    $plugin=$_

# For some unknown reason, quote must be escape before passing to curl
$data_binary=@"
{
    \"assetTypes\": [\"Microsoft.VisualStudio.Services.VSIXPackage\"],
    \"filters\": [
        {
            \"criteria\": [
                {
                    \"filterType\": 7,
                    \"value\": \"$plugin\"
                }
            ]
        }
    ],
    \"flags\": 3
}
"@

    Write-Host "Starting download for $plugin"

    # make post request to vscode marketplace
    $result=curl -s -XPOST $url --header $header_accept --header $header_content_type --data-raw $data_binary

    # parse the result
    # $extension_name=$result | jq -r '.results[0].extensions[0].extensionName'
    $extension_url=$result | jq -r '.results[0].extensions[0].versions[0].files[0].source'
    $extension_version=$result | jq -r '.results[0].extensions[0].versions[0].version'

    # -L: follow redirect
    # --create-dirs: if not exist
    # --silent: do not show progress
    curl -L $extension_url -o "$default_download_dir/$plugin-$extension_version.vsix" --create-dirs --silent

    Write-Host "Completed"
}
