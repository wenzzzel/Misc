Write-Host "Adding to path variable" -ForegroundColor Blue;
$ENV:PATH += ";C:\Program Files\Git\bin";
$ENV:PATH += ";C:\Program Files\Git\usr\bin"; #This is where openssl.exe is located
$ENV:PATH += ";C:\Program Files\nodejs\";
$ENV:PATH += ";$env:APPDATA\npm";
$ENV:PATH += ";C:\Program Files\Neovim\bin";
$ENV:PATH += ";C:\Program Files\azure-documentdb-datamigrationtool-1.8.3";
$ENV:PATH += ";C:\Program Files\dotnet"
$ENV:PATH += ";C:\Program Files\Microsoft\Azure Functions Core Tools\";
$ENV:PATH += ";C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin";
$ENV:PATH += ";C:\ProgramData\chocolatey\lib\mouse-jiggler\tools";
$ENV:PATH += ";C:\Program Files\Gource";

Write-Host "Loading PSSecrets" -ForegroundColor Blue;
$PSSecretsPath = "C:\psSecrets.json";
if(!(Test-Path $PSSecretsPath)){
    Write-Host "No psSecrets.json found. Creating it..." -ForegroundColor Blue;
    New-Item -ItemType File -Path $PSSecretsPath; 
}
$PSSecrets = Get-Content $PSSecretsPath | ConvertFrom-Json;

Write-Host "Making sure dependencies are installed" -ForegroundColor Blue;
$moduleDependencies = @(
    'NuGet'#,
    #'CosmosDB'
);
foreach($moduleDependency in $moduleDependencies){
    [bool]$IsInstalled = (Get-InstalledModule | Where-Object -Property Name -eq $moduleDependency | Measure-Object | Select-Object -ExpandProperty Count)
    if(!$IsInstalled){
        $errMess = "One or more dependencies is not installed!";
        Write-Host $errMess -ForegroundColor Red;
        Throw $errMess;
    } else {
        Write-Host " ✔️ $moduleDependency" -ForegroundColor Yellow;
    }
}

Write-Host "Setting user defined variables" -ForegroundColor Blue;
Write-Host ' 🔠 $thisRepoRootDir' -ForegroundColor Yellow;
$thisRepoRootDir = "$PROFILE/../"
Write-Host ' 🔠 $nvimConfigFile' -ForegroundColor Yellow;
$nvimConfigFile = "$env:LOCALAPPDATA\nvim\init.vim"
Write-Host ' 🔠 $nvimPluginsFolder' -ForegroundColor Yellow;
$nvimPluginsFolder = "$env:OneDriveCommercial\Documents\nvim_plugins"
Write-Host ' 🔠 $crap' -ForegroundColor Yellow;
$crap = "$env:OneDriveCommercial\Documents\Crap"
Write-Host ' 🔠 $repos' -ForegroundColor Yellow;
$repos = "$env:userprofile\source\repos"
Write-Host ' 🔠 $dotnetSecretStore' -ForegroundColor Yellow;
$dotnetSecretStore = "$env:APPDATA\Microsoft\UserSecrets\"
Write-Host ' 🔠 $ds' -ForegroundColor Yellow; #Makes sense to have var for this since almost all repos are prefixed with dataservices
$ds = "dataservices"

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
