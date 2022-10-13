# to sort
# Get-Content .\winget-applications.txt | sort | get-unique | Set-Content winget-applications.txt

Write-Host "Starting..."

$default_download_dir="./_winget_applications"

# initialize empty array
$toJsonArray= @()

# # For each application
Get-Content .\winget-applications.txt | ForEach-Object {
    $application=$_

    # use winget to show the application manifest
    $manifest=winget show $application

    # manifest to extract
    $extract_version="(?<=Version:).*"
    $extract_url='(?<=Download Url:|Installer Url:).*'

    # using the manifest object
    # find the version row and match what comes after it
    # get the matched string value from the regex
    # trim it to remove whitespace and get just the version / url
    $version=$manifest | Select-String -Pattern $extract_version | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value | ForEach-Object Trim
    $url=$manifest | Select-String -Pattern $extract_url | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value | ForEach-Object Trim

    # what we can do with the json is to use it for the next run where
    # we don't download version that was not updated to save bandwidth and unnecessary downloads

    # append to the array
    $toJsonArray += [PSCustomObject]@{
        'id'           = "$application"
        'application'  = "$application"
        'version'      = "$version"
        'download_url' = "$url"
    }

    Write-Host "Starting download for $application"
    # -L: follow redirect
    # -O -J: we want to retain the remote filename instead of constructing our own
    # see https://daniel.haxx.se/blog/2020/09/10/store-the-curl-output-over-there
    # --create-dirs: if not exist
    # --silent: do not show progress
    curl -L $url -O -J --output-dir $default_download_dir --create-dirs --silent
}

# convert the final result to json file
$toJsonArray | ConvertTo-Json | Set-Content winget-last_processed.json

Write-Host "Completed"
