# Downloader

This repository contains scripts to download files for air-gapped environment. I wrote a [blogpost](https://bwgjoseph.com/how-i-automate-downloading-of-application-installers-using-powershell) on how I came to this solution.

## Winget Downloads

Powershell script to download application installers based off `winget-applications.txt` which is extracted (manually)

## Run

On PowerShell, run

```powershell
.\winget-download.ps1
```

By default, the installers will be downloaded to `_winget_applications` directory

## Todo

- [ ] Extract application list automatically from `winget list`
- [ ] Compare last downloaded version with current run to download only updated applications
- [ ] Compress downloaded files into archive
- [ ] Support downloading files not from `winget`
- [ ] Support downloading IDE (vscode, intellij) extension
- [ ] Support downloading VSCode intellicode models