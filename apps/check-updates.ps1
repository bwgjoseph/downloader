# Check updates for custom-applications.json
Write-Host "Checking for updates..." -ForegroundColor Cyan

$json_path = "./custom-applications.json"
$apps = Get-Content $json_path | ConvertFrom-Json
$updated = $false

foreach ($app in $apps) {
    if (-not $app.check_config) { continue }

    Write-Host "`nApp: $($app.id)" -ForegroundColor Yellow
    $latest_version = $null

    if ($app.check_config.type -eq "github_release") {
        $repo = $app.check_config.repo
        # Try gh first
        try {
            $latest_version = gh release view --repo $repo --json tagName --jq '.tagName' -t '{{.tagName}}' 2>$null
            if ($LASTEXITCODE -ne 0) { throw "gh failed" }
        } catch {
            Write-Host "  gh failed, trying GitHub API releases..." -ForegroundColor Gray
            $release_url = "https://api.github.com/repos/$repo/releases/latest"
            $release = curl.exe -s $release_url | ConvertFrom-Json
            if ($release.tag_name) {
                $latest_version = $release.tag_name
            } else {
                Write-Host "  No releases found, falling back to tags..." -ForegroundColor Gray
                # Use git/refs/tags which is often alphabetically sorted, helping us find 100.x before r4.x
                $tags_url = "https://api.github.com/repos/$repo/git/refs/tags?per_page=100"
                $all_refs = curl.exe -s $tags_url | ConvertFrom-Json
                
                # Filter and sort tags
                $valid_tags = $all_refs | ForEach-Object {
                    $name = $_.ref -replace '^refs/tags/', ''
                    # Normalize for sorting: remove prefixes
                    $v = $name -replace '^(v|maven-|kafka-|r)', ''
                    # Get base version (before any -rc, etc.)
                    $base_v = $v -split '-' | Select-Object -First 1
                    if ($base_v -match '^\d+(\.\d+)+$') {
                        [PSCustomObject]@{
                            Tag = $name
                            Normalized = $v
                            Version = [version]$base_v
                            IsPreRelease = $name -match '(rc|beta|alpha|draft)'
                        }
                    }
                }
                
                $latest_version = ($valid_tags | Where-Object { -not $_.IsPreRelease } | Sort-Object Version -Descending | Select-Object -First 1).Tag
                if (-not $latest_version) {
                    # If no stable tags found, take the newest pre-release
                    $latest_version = ($valid_tags | Sort-Object Version -Descending | Select-Object -First 1).Tag
                }
            }
        }
        # Final normalization for the JSON
        $latest_version = $latest_version -replace '^(v|maven-|kafka-|r)', ''
    } elseif ($app.check_config.type -eq "jetbrains") {
        $product_code = $app.check_config.code
        $json = curl.exe -s "https://data.services.jetbrains.com/products/releases?code=$product_code&latest=true" | ConvertFrom-Json
        $latest_version = ($json.$product_code | Select-Object -First 1).version
    } elseif ($app.check_config.type -eq "winget") {
        $winget_id = $app.check_config.id
        $manifest = winget show $winget_id
        $latest_version = $manifest | Select-String -Pattern "(?<=Version:).*" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value | ForEach-Object Trim
    } elseif ($app.check_config.type -eq "json") {
        $url = $app.check_config.url
        $jq_path = $app.check_config.jq
        $latest_version = curl.exe -s $url | jq -r $jq_path
    } elseif ($app.check_config.type -eq "manual") {
        Write-Host "  (Manual tracking required - ID: $($app.id))" -ForegroundColor DarkGray
        continue
    } else {
        Write-Host "  (Unknown tracking type - ID: $($app.id))" -ForegroundColor Red
        continue
    }
    
    if ($latest_version) {
        Write-Host "  Current: $($app.version)"
        Write-Host "  Latest:  $latest_version"
        
        if ($latest_version -ne $app.version) {
            Write-Host "  Update available!" -ForegroundColor Green
            $app.version = $latest_version
            if ($app.url_template) {
                $new_url = $app.url_template -replace '\{version\}', $latest_version
                $app.download_url = $new_url
                Write-Host "  New URL: $new_url"
            }
            $updated = $true
        } else {
            Write-Host "  Up to date."
        }
    } else {
        Write-Warning "Could not fetch latest version for $($app.id)"
    }
}

if ($updated) {
    Write-Host "`nSaving updates to $json_path..." -ForegroundColor Cyan
    $json = $apps | ConvertTo-Json -Depth 10
    if (Get-Command jq -ErrorAction SilentlyContinue) {
        $json | jq . | Set-Content $json_path
    } else {
        # Fallback if jq is not available, though it might have different formatting
        $json | Set-Content $json_path
    }
} else {
    Write-Host "`nNo updates to save." -ForegroundColor Gray
}
