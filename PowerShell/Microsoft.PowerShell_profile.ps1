Write-Host "Adding to path variable" -ForegroundColor Blue;
# Below hashtable is structured like this:
# "chocoPackageName" = "Path"
#
# Add "NotAvailableInChoco<number>" as chocoPackageName and place in bottom of the list if it's not available in chocolatey
$pathsToAdd = @{
    "choco" = "C:\ProgramData\chocolatey"
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
    "NotAvailableInChoco" = "C:\Program Files\Git\usr\bin" #This is where openssl.exe is located
    "NotAvailableInChoco2" = "C:\Program Files\azure-documentdb-datamigrationtool-1.8.3"
}
foreach($path in $pathsToAdd.GetEnumerator()){
    $ENV:PATH += ";$($path.Value)";
    $pathExists = Test-Path $path.Value;
    if($pathExists){
        Write-Host " ✔️ %PATH% entry added: $($path.Value)";
    }else {
        Write-Host " ❌ %PATH% entry added, but doesn't exist: $($path.Value)";
        if($path.Name -notlike "NotAvailableInChoco*"){
            Write-Host "    💡 Consider running `"choco install $($path.Name)`"";
        }
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
