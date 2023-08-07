cd apps
.\apps-downloads.ps1
cd ..
cd github
.\github-downloads.ps1
cd ..
cd playwright
.\playwright-downloads.ps1
cd ..
cd plugins
cd intellij
# .\intellij-plugin-downloads.ps1 -version 2022.2 -build 222.3345.118
# .\intellij-plugin-downloads.ps1 -version 2022.2.3 -build 222.3345.118
# .\intellij-plugin-downloads.ps1 -version 2022.3.1 -build 223.8214.52
# .\intellij-plugin-downloads.ps1 -version 2022.3.2 -build 223.8617.56
.\intellij-plugin-downloads.ps1 -version 2023.1 -build 231.8109.175
.\intellij-plugin-downloads.ps1 -version 2023.1.1 -build 231.8770.65
.\intellij-plugin-downloads.ps1 -version 2023.1.2 -build 231.9011.34
.\intellij-plugin-downloads.ps1 -version 2023.1.3 -build 231.9161.38
.\intellij-plugin-downloads.ps1 -version 2023.2 -build 232.8660.185
cd ..
cd vscode
.\vscode-plugin-downloads.ps1
.\vscode-models-downloads.ps1 -username joseph -version 1.2.30
cd ..
cd ..
cd winget
.\winget-downloads.ps1
cd ..