# To sort
# Get-Content .\github-applications.json | ConvertFrom-Json | Sort-Object repo | ConvertTo-Json | Set-Content github-applications.json

# See https://github.com/wagoodman/dive/ on how to grep the version
# DIVE_VERSION=$(curl -sL "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
# curl -OL https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.deb
# sudo apt install ./dive_${DIVE_VERSION}_linux_amd64.deb

Write-Host "Starting..."

$default_download_dir="./_github_applications"

# # For each application
Get-Content github-applications.json | ConvertFrom-Json | ForEach-Object {
    $latest_release=gh release view --repo $_.repo --json tagName --jq '.tagName'

    Write-Host "Starting download for" $_.repo $latest_release

    # --skip-existing: Skip downloading when files of the same name exist
    # --dir: The directory to download files into
    gh release download --repo $_.repo -p $_.pattern --skip-existing --dir $default_download_dir
}

Write-Host "Completed"