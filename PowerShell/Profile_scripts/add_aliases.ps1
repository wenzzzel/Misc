Write-Host "Adding Aliases" -ForegroundColor Blue;
Write-Host " 👥 BeyondCompare = BComp"
New-Alias BeyondCompare BComp -Scope Global
Write-Host " 👥 powerbi = pbidesktop"
New-Alias powerbi pbidesktop -Scope Global
Write-Host " 👥 chrome = googlechrome"
New-Alias googlechrome chrome -Scope Global
Write-Host " 👥 azure-documentdb-data-migration-tool = dtui"
New-Alias azure-documentdb-data-migration-tool dtui.exe -Scope Global
Write-Host " 👥 ask = Invoke-CoPilot"
New-Alias ask "Invoke-CoPilotCliSuggest" -Scope Global
Write-Host " 👥 microsoftazurestorageexplorer = StorageExplorer"
New-Alias microsoftazurestorageexplorer StorageExplorer -Scope Global