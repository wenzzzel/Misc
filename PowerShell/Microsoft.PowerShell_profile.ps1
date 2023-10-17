$asciiArt = "
          ____________________________________________         
_________|                                       _    |________
\        |   __      _____ _ __  _______________| |   |       /
 \       |   \ \ /\ / / _ \ '_ \|_  /_  /_  / _ \ |   |      / 
  \      |    \ V  V /  __/ | | |/ / / / / /  __/ |   |     /  
  /      |     \_/\_/ \___|_| |_/___/___/___\___|_|   |     \  
 /       |____________________________________________|      \ 
/_____________)                                 (_____________\
                                                                
";

Write-Host $asciiArt -ForegroundColor Green;

Write-Host "Adding general stuff to path variable" -ForegroundColor Blue;
$pathsToAdd = @{
    "choco" = "C:\ProgramData\chocolatey"
    "openssl" = "C:\Program Files\Git\usr\bin" #This is where openssl.exe is located
    "servicebus-cli" = "C:\Program Files\servicebus-cli"
}
$whiteSpaceCount = 40;
foreach($path in $pathsToAdd.GetEnumerator()){
    $calculatedWhiteSpaceCount = $whiteSpaceCount - $path.Key.Length
    $whiteSpaces = "";
    for ($i = 0; $i -lt $calculatedWhiteSpaceCount; $i++) {
        $whiteSpaces = $whiteSpaces + " ";
    }

    $ENV:PATH += ";$($path.Value)";
    $pathExists = Test-Path $path.Value;
    if($pathExists){
        Write-Host " ✔️ $($path.Key) $($whiteSpaces) $($path.Value)";
    }else {
        Write-Host " ❌ $($path.Key) $($whiteSpaces) Doesn't exist. $($path.Value)";
    }
}

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
}
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

Write-Host "Checking for npm packages" -ForegroundColor Blue;
$npmPackages = @(
    "@angular/cli",
    "newman"
)
foreach($package in $npmPackages.GetEnumerator()){
    $installedPackages = (npm list -g);
    $packageIsInstalled = $installedPackages -like "*$package*"
    if($packageIsInstalled){
        Write-Host " ✔️ $package was already installed";
    }else {
        Write-Host " ❌ $package was not installed. Consider running `"npminstall -g $($package)`"";
    }
}

Write-Host "Loading PSSecrets" -ForegroundColor Blue;
$PSSecretsPath = "C:\psSecrets.json";
if(!(Test-Path $PSSecretsPath)){
    Write-Host "No psSecrets.json found. Creating it..." -ForegroundColor Blue;
    New-Item -ItemType File -Path $PSSecretsPath; 
}
$PSSecrets = Get-Content $PSSecretsPath | ConvertFrom-Json;

Write-Host "Making sure dependencies are installed" -ForegroundColor Blue;
$moduleDependencies = @(
    'NuGet',
    'Az',
    'CosmosDB'
);
foreach($moduleDependency in $moduleDependencies){
    [bool]$IsInstalled = (Get-InstalledModule | Where-Object -Property Name -eq $moduleDependency | Measure-Object | Select-Object -ExpandProperty Count)
    if(!$IsInstalled){
        Write-Host " ❌ $moduleDependency. Trying to install it..."
        Install-Module -Name $moduleDependency -Force;
        Write-Host "Checking that $ModuleDependency was successfully installed"
        [bool]$IsInstalled = (Get-InstalledModule | Where-Object -Property Name -eq $moduleDependency | Measure-Object | Select-Object -ExpandProperty Count)
        if(!$IsInstalled){
            $errMess = "The dependency $moduleDependency could not be found! Please resolve before running this powershell profile!";
            Write-Host $errMess -ForegroundColor Red;
            Throw $errMess;
        } else {
        Write-Host " ✔️ $moduleDependency";
    }
    } else {
        Write-Host " ✔️ $moduleDependency";
    }
}

Write-Host "Setting user defined variables" -ForegroundColor Blue;
Write-Host ' 🔠 $thisRepoRootDir' -ForegroundColor Green;
$thisRepoRootDir = "$PROFILE/../"
Write-Host ' 🔠 $nvimConfigFile' -ForegroundColor Green;
$nvimConfigFile = "$env:LOCALAPPDATA\nvim\init.vim"
Write-Host ' 🔠 $nvimConfigFolder' -ForegroundColor Green;
$nvimConfigFolder = "$env:LOCALAPPDATA\nvim"
Write-Host ' 🔠 $nvimPluginsFolder' -ForegroundColor Green;
$nvimPluginsFolder = "$env:OneDriveCommercial\Documents\nvim_plugins"
Write-Host ' 🔠 $crap' -ForegroundColor Green;
$crap = "$env:OneDriveCommercial\Documents\Crap"
Write-Host ' 🔠 $repos' -ForegroundColor Green;
$repos = "$env:userprofile\source\repos"
Write-Host ' 🔠 $dotnetSecretStore' -ForegroundColor Green;
$dotnetSecretStore = "$env:APPDATA\Microsoft\UserSecrets\"
Write-Host ' 🔠 $ds' -ForegroundColor Green; #Makes sense to have var for this since almost all repos are prefixed with dataservices
$ds = "dataservices"
Write-Host ' 🔠 $nugetConfigFilePath' -ForegroundColor Green;
$nugetConfigFilePath = "$env:appdata\nuget\nuget.config"

Write-Host "Creating user defined functions" -ForegroundColor Blue;
$UserDefinedFunctions = (Get-ChildItem "$thisRepoRootDir/User_defined_functions");
$modulePaths = ($env:PSModulePath.Split(";"));
foreach($UserDefinedFunction in $UserDefinedFunctions){
    Write-Host " ⚙️ $($UserDefinedFunction.Name)" -ForegroundColor Yellow;

    foreach($modulePath in $modulePaths){
        Copy-Item $UserDefinedFunction -Destination $modulePath -Recurse -Force;
    }
    
    Import-Module $UserDefinedFunction.Name;
}

Write-Host "Adding Aliases" -ForegroundColor Blue;
Write-Host " 👥 BeyondCompare = BComp"
New-Alias BeyondCompare BComp
Write-Host " 👥 powerbi = pbidesktop"
New-Alias powerbi pbidesktop
Write-Host " 👥 chrome = googlechrome"
New-Alias googlechrome chrome
Write-Host " 👥 azure-documentdb-data-migration-tool = dtui"
New-Alias azure-documentdb-data-migration-tool dtui.exe

#TODO: Create function for generating the functions setting (json list of functions to run) for azure functions project

#TODO: Create function creating local.settings.json (for azure function app projects

#TODO: Create function for setting up local environment for azure functions. Sort of a reminder list thingy
#      This needs to be included
#       - local.settings.json (Must have value for AzureWebJobsStorage: "AzureWebJobsStorage": "UseDevelopmentStorage=true")
#           - This is how mine looks right now for example
#{
#  "IsEncrypted": false,
#  "Values": {
#    "FUNCTIONS_WORKER_RUNTIME": "dotnet",
#    "AzureWebJobsStorage": "UseDevelopmentStorage=true"
#  }
#}
#       - Add Azurite files to gitignore
#       - Ctrl + Shift + P: Azurite: Start
#       - Ctrl + Shift + P: Azure Functions: Initialize Project for Use with VS Code...



# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Write-Host "Checking reminders" -ForegroundColor Blue;
$reminderState = (Get-Content -Raw "$thisRepoRootDir/reminder_state.json" | ConvertFrom-Json);

Write-Host " 🕐 TimeReport reminder";
$currentDate = (Get-Date);
if($currentDate.Day -gt 20){
    if($reminderState.TimeReport -ne ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString())){
        $timeReportDone = "No input given yet...";
        while($timeReportDone -notin "Y", "N"){
            $timeReportDone = Read-Host -Prompt "Did you do the time report yet? [Y/N]"
        }
        if($timeReportDone -eq "Y"){
            Write-Host "     ✔️ Very good! Will ask again next month";
            $reminderState.TimeReport = ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString());
            Set-Content -Value ($reminderState | ConvertTo-Json) -Path "$thisRepoRootDir/reminder_state.json";
        }
        
        if($timeReportDone -eq "N"){
            Write-Host "`a     ❌ Please submit your time report. Will ask you again next time!";
        }
    } else{
        Write-Host "     ✔️ Time report already done this month. Good for you!"
    }
}

# Activate Intellisense for powershell
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

#Activate posh-git and oh-my-posh
Write-Host "Trying to start posh-git and oh-my-posh" -ForegroundColor Blue;
if((Test-Path "C:\tools\poshgit\dahlbyk-posh-git-9bda399\") -And (Test-Path "C:\Program Files (x86)\oh-my-posh\bin\")){
    Write-Host " ✔️ posh-git and oh-my-posh was found, starting..."
    Install-Module posh-git
    Import-Module posh-git -Force
    
    Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'
    # oh-my-posh font install agave
    oh-my-posh init pwsh | Invoke-Expression
} else {
    Write-Host " ❌ Couldn't start posh-git and oh-my-posh because at least one of them was not found." -ForegroundColor Blue;
}

#Setup nvim Plug
#TODO: Check if this already exists beofore downloading it. 
#TODO: Don't have this at the end of the file
# iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
#     ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
