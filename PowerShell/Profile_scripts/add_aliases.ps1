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
Write-Host " 👥 sql-server-management-studio = ssms"
New-Alias sql-server-management-studio ssms -Scope Global
Write-Host " 👥 linqpad = linqpad8"
New-Alias linqpad linqpad8 -Scope Global
Write-Host " 👥 godot = Godot_v4.3-stable_mono_win64.exe"
New-Alias godot "Godot_v4.3-stable_mono_win64.exe" -Scope Global