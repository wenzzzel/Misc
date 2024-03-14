Write-Host "Adding chocolatey packages + path variable" -ForegroundColor Blue;
# Below hashtable is structured like this:
# "chocoPackageName" = "Path"
$chocoPackages = @{
    "postman" = "$env:LocalAppData\Postman"
    "git" = "C:\Program Files\Git\bin"
    "BeyondCompare" = "C:\Program Files\Beyond Compare 4\"
    "nodejs" = "C:\Program Files\nodejs\"
    "npm" = "$env:APPDATA\npm"
    "dotnet" = "C:\Program Files\dotnet"
    "azure-functions-core-tools" = "C:\ProgramData\chocolatey\lib\azure-functions-core-tools\tools"
    "azure-cli" = "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin"
    "mouse-jiggler" = "C:\ProgramData\chocolatey\lib\mouse-jiggler\tools"
    "gource" = "C:\Program Files\Gource"
    "ServiceBusExplorer" = "C:\ProgramData\chocolatey\lib\ServiceBusExplorer"
    "Azurite" = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\Extensions\Microsoft\Azure Storage Emulator"
    "neovim" = "C:\tools\neovim\nvim-win64\bin"
    "powerbi" = "C:\Program Files\Microsoft Power BI Desktop\bin\"
    "spotify" = "$env:APPDATA\Spotify"
    "googlechrome" = "$env:LOCALAPPDATA\Google\Chrome\Application"
    "powertoys" = "C:\Program Files\PowerToys\"
    "slack" = "C:\Program Files\Slack\"
    "daxstudio" = "C:\Program Files\Dax Studio\"
    "poshgit" = "C:\tools\poshgit\dahlbyk-posh-git-9bda399\"
    "oh-my-posh" = "C:\Program Files (x86)\oh-my-posh\bin\"
    "azure-documentdb-data-migration-tool --version=1.8.3.20210809" = "C:\ProgramData\chocolatey\lib\azure-documentdb-data-migration-tool\tools\azure-documentdb-datamigrationtool-1.8.3"
    "winrar" = "C:\Program Files\WinRAR\"
    "gh" = "C:\Program Files\GitHub CLI\"
    "lazygit" = "C:\ProgramData\chocolatey\lib\lazygit\tools"
}
$chocoPackages = $chocoPackages.GetEnumerator() | Sort-Object -Property Key;
$whiteSpaceCount = 40;
foreach($package in $chocoPackages.GetEnumerator()){
    $calculatedWhiteSpaceCount = $whiteSpaceCount - $package.Key.Length
    $whiteSpaces = "";
    for ($i = 0; $i -lt $calculatedWhiteSpaceCount; $i++) {
        $whiteSpaces = $whiteSpaces + " ";
    }

    $ENV:PATH += ";$($package.Value)";
    $pathExists = Test-Path $package.Value;
    if($pathExists){
        Write-Host " ✔️ $($package.Key) $($whiteSpaces) $($package.Value)";
    }else {
        Write-Host " ❌ $($package.Key) $($whiteSpaces) Doesn't exist. Run `"choco install $($package.Name)`". $($package.Value)";
    }
}