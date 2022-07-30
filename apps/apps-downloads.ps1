Write-Host "Starting..."

$default_download_dir="./_applications"

# initialize empty array
$toJsonArray= @()

# # For each application
Get-Content .\winget-applications.txt | ForEach-Object {
    $application=$_

    # use winget to show the application manifest
    $manifest=winget show $application

    # manifest to extract
    $extract_version="Version: "
    $extract_url="Download Url: "

    # using the manifest object
    # filter it to just version row
    # convert from object into string for manipulation
    # trim the string
    # extract just the value for version / url
    $version=$manifest | Select-String $extract_version -NoEmphasis | Out-String | ForEach-Object { $_.Trim() } | ForEach-Object { $_.SubString($extract_version.Length) }
    $url=$manifest | Select-String $extract_url -NoEmphasis | Out-String | ForEach-Object { $_.Trim() } | ForEach-Object { $_.SubString($extract_url.Length) }

# here-string don't like white-spaces so we can't indent here
$json= @"
{
    "id": "$application",
    "application": "$application",
    "version": "$version",
    "download_url": "$url"
}
"@
# what we can do with the json is to use it for the next run where
# we don't download version that was not updated to save bandwidth and unnecessary downloads

# append to the array
$toJsonArray += ConvertFrom-Json $json

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