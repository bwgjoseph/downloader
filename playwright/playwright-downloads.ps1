# to support https://github.com/bwgjoseph/downloader/issues/3

Write-Host "Starting..."

$default_download_dir="./_playwright"
$json_source_url="https://raw.githubusercontent.com/microsoft/playwright/main/packages/playwright-core/browsers.json"
$baseUrl="https://playwright.azureedge.net/builds"

# download the latest version for parsing
curl -L $json_source_url -O -J --create-dirs --silent

$browser_names=@('chromium','firefox','ffmpeg')
$platforms=@('win64','linux-arm64')

Get-Content browsers.json | ConvertFrom-Json | ForEach-Object {
    # example url: https://playwright.azureedge.net/builds/chromium/1045/chromium-win64.zip
    # example url: https://playwright.azureedge.net/builds/chromium/1066/chromium-linux-arm64.zip
    # source: https://github.com/microsoft/playwright/blob/dfd151832706e54b52e94e451fa122b755798cee/packages/playwright-core/src/server/registry/index.ts

    ForEach ($browser in $_.browsers) {

        # only download from the following browser_name
        if ($browser_names -contains $browser.name) {

            ForEach ($platform in $platforms) {
                # not handling this because the url is slightly different
                if ($browser.name -eq 'firefox' -and $platform -eq 'linux-arm64') {
                    continue;
                }

                # wrapping variable in $() to expand it
                $url = "$baseUrl/$($browser.name)/$($browser.revision)/$($browser.name)-$($platform).zip"

                Write-Host "Starting download for Playwright Binaries - $url"

                curl -L $url -O -J --output-dir $default_download_dir --create-dirs --silent
            }
        }
    }
}