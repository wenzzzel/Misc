Write-Host "Setting user defined variables" -ForegroundColor Blue;
Write-Host ' 🔠 $thisRepoRootDir' -ForegroundColor Green;
Set-Variable -Name "thisRepoRootDir" -Value "$PROFILE/.." -Scope global
Write-Host ' 🔠 $nvimConfigFile' -ForegroundColor Green;
Set-Variable -Name "nvimConfigFile" -Value "$env:LOCALAPPDATA\nvim\init.vim" -Scope global
Write-Host ' 🔠 $nvimConfigFolder' -ForegroundColor Green;
Set-Variable -Name "nvimConfigFolder" -Value "$env:LOCALAPPDATA\nvim" -Scope global
Write-Host ' 🔠 $nvimPluginsFolder' -ForegroundColor Green;
Set-Variable -Name "nvimPluginsFolder" -Value "$env:OneDriveCommercial\Documents\nvim_plugins" -Scope global
Write-Host ' 🔠 $crap' -ForegroundColor Green;
Set-Variable -Name "crap" -Value "$env:OneDriveCommercial\Documents\Crap" -Scope global
Write-Host ' 🔠 $repos' -ForegroundColor Green;
Set-Variable -Name "repos" -Value "$env:userprofile\source\repos" -Scope global
Write-Host ' 🔠 $dotnetSecretStore' -ForegroundColor Green;
Set-Variable -Name "dotnetSecretStore" -Value "$env:APPDATA\Microsoft\UserSecrets\" -Scope global
Write-Host ' 🔠 $ds' -ForegroundColor Green; #Makes sense to have var for this since almost all repos are prefixed with dataservices
Set-Variable -Name "ds" -Value "dataservices" -Scope global
Write-Host ' 🔠 $nugetConfigFilePath' -ForegroundColor Green;
Set-Variable -Name "nugetConfigFilePath" -Value "$env:appdata\nuget\nuget.config" -Scope global