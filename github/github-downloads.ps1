# To sort
# Get-Content .\github-applications.json | ConvertFrom-Json | Sort-Object id | ConvertTo-Json | Set-Content github-applications.json

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