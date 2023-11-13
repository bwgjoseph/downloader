# To sort
# Get-Content .\custom-applications.json | ConvertFrom-Json | Sort-Object id | ConvertTo-Json | Set-Content custom-applications.json

Write-Host "Starting..."

$default_download_dir="./_helmcharts"

# # For each application
Get-Content helmcharts.json | ConvertFrom-Json | ForEach-Object {
    Write-Host "Adding repo for" $_.helm

    helm repo add $_.helm $_.repo
    helm repo update

    # had to re-assign, otherwise, $_.helm will resolved to something weird
    # $helm = $_.helm

    New-Item -ItemType Directory -Force -Path $default_download_dir

    foreach ($chart in $_.charts) {
        Write-Host "Starting download for " $chart
        helm pull $chart -d $default_download_dir
    }
}

Write-Host "Completed"