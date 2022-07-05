# Downloader

This repository contains scripts to download files for air-gapped environment. I wrote a [blogpost](https://bwgjoseph.com/how-i-automate-downloading-of-application-installers-using-powershell) on how I came to this solution.

## Winget Downloads

Powershell script to download application installers based off `winget-applications.txt` which is extracted (manually)

### Run

On PowerShell, run

```powershell
.\winget-downloads.ps1
```

By default, the installers will be downloaded to `_winget_applications` directory

## VSCode Plugin Downloads

Powershell script to download plugins based off `vscode-plugins.txt` which is extracted (manually). It is possible to extract a list of plugins by running `code --list-extensions > vscode-plugins.txt`.

### Run

On PowerShell, run

```powershell
.\vscode-plugin-downloads.ps1
```

By default, the plugins will be downloaded to `_vscode_plugins` directory

## IntelliJ Plugin Downloads

Powershell script to download plugins based off `intellij-plugins.txt` which is extracted (manually).

### Run

On PowerShell, run

```powershell
.\intellij-plugin-downloads.ps1 -version 2022.1.3
```

By default, the installers will be downloaded to `_intellij_plugins_2022.1.3` directory

## Todo

- [ ] Extract application list automatically from `winget list`
- [ ] Compare last downloaded version with current run to download only updated applications
- [ ] Compress downloaded files into archive
- [ ] Support downloading files not from `winget`
- [x] Support downloading VSCode extension
- [x] Support downloading IntelliJ extension
- [ ] Support downloading VSCode intellicode models