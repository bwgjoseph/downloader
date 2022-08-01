# Downloader

This repository contains scripts to download files for air-gapped environment. I wrote a [blogpost](https://bwgjoseph.com/how-i-automate-downloading-of-application-installers-using-powershell) on how I came to this solution.

## Winget Downloads

Powershell script to download application installers based off `winget-applications.txt` which is extracted (manually)

### Run

On PowerShell, run

```powershell
cd winget
.\winget-downloads.ps1
```

By default, the installers will be downloaded to `_winget_applications` directory

## Applications Downloads

Powershell script to download application installers based off `custom-applications.txt` which is extracted (manually). This is to support downloading of applications that is not supported by `winget`

### Run

On PowerShell, run

```powershell
cd apps
.\apps-downloads.ps1
```

By default, the installers will be downloaded to `_applications` directory

## VSCode Plugin Downloads

Powershell script to download plugins based off `vscode-plugins.txt` which is extracted (manually). It is possible to extract a list of plugins by running `code --list-extensions > vscode-plugins.txt`.

### Run

On PowerShell, run

```powershell
cd plugins/vscode
.\vscode-plugin-downloads.ps1
```

By default, the plugins will be downloaded to `_vscode_plugins` directory

## VSCode Model Downloads

Powershell script to download models based off `vscode-models.txt` which is extracted (manually).

### Run

On PowerShell, run

```powershell
.\\vscode-models-downloads.ps1 -username joseph -version 1.2.22
```

By default, the installers will be downloaded to `_vscode_models` directory

## IntelliJ Plugin Downloads

Powershell script to download plugins based off `intellij-plugins.txt` which is extracted (manually).

### Run

On PowerShell, run

```powershell
cd plugins/intellij
.\intellij-plugin-downloads.ps1 -version 2022.2
```

By default, the installers will be downloaded to `_intellij_plugins_2022.2` directory. If `version` is not specific, the default will be `2022.2`

## Todo

- [ ] Extract application list automatically from `winget list`
- [ ] Compare last downloaded version with current run to download only updated applications
- [ ] Compress downloaded files into archive
- [x] Support downloading files not from `winget`
- [x] Support downloading VSCode extension
- [x] Support downloading IntelliJ extension
- [x] Support downloading VSCode intellicode models