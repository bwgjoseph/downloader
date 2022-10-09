# see https://github.com/MicrosoftDocs/intellicode/issues/4#issuecomment-450935237 and https://github.com/MicrosoftDocs/intellicode/issues/4

param ($username, $version)

Write-Host "Starting..."

$default_download_dir="./_vscode_models"

# initialize empty array
$toJsonArray= @()

# # For each application
Get-Content .\vscode-models.txt | ForEach-Object {
    $language, $url = $_ -split ' '

    $result=curl -s -XGET $url

     # parse the result
    $id=$result | jq -r '.output.id'
    $modelId=$result | jq -r '.output.modelId'
    $updated=$result | jq -r '.output.updated'
    $download_url=$result | jq -r '.output.blob.azureBlobStorage.readSasToken'

    $filename="$($modelId)_$($id)"

    # append to the array
    $toJsonArray += [PSCustomObject]@{
        'analyzerName' = "intellisense-members"
        'languageName' = "$language"
        'identity' = [PSCustomObject]@{
            'modelId' = "$modelId"
            'outputId' = "$id"
            'modifiedTimeUtc' = "$updated"
        }
        'filePath' = "c:\Users\$username\.vscode\extensions\visualstudioexptteam.vscodeintellicode-$version\cache\$filename"
        'lastAccessTimeUtc' = "2022-06-29T16:49:32.785Z"
    }

    Write-Host "Starting download for $language"
    # -L: follow redirect
    # --create-dirs: if not exist
    # --silent: do not show progress
    curl -L $download_url -o "$default_download_dir/$filename" --create-dirs --silent
}

# convert the final result to json file
$toJsonArray | ConvertTo-Json -Compress | Set-Content models.json
Move-Item -Path ./models.json -Destination $default_download_dir

Write-Host "Completed"
