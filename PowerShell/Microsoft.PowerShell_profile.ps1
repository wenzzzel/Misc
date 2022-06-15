Write-Host "Adding to path variable" -ForegroundColor Blue;
$ENV:PATH += ";C:\Program Files\Git\bin";
$ENV:PATH += ";C:\Program Files\nodejs\";
$ENV:PATH += ";C:\Users\ewentzel\AppData\Roaming\npm";
$ENV:PATH += ";C:\Program Files\Neovim\bin";
$ENV:PATH += ";C:\Program Files\azure-documentdb-datamigrationtool-1.8.3";
$ENV:PATH += ";C:\Program Files\dotnet"
$ENV:PATH += ";C:\Program Files\Microsoft\Azure Functions Core Tools\";
$ENV:PATH += ";C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin";

Write-Host "Loading PSSecrets" -ForegroundColor Blue;
$PSSecrets = Get-Content "C:\psSecrets.json" | ConvertFrom-Json;

Write-Host "Making sure dependencies are installed" -ForegroundColor Blue;
[bool]$IsInstalled = $false;
#TODO: Below check is proly not working as intended. Need to fix that...
$IsInstalled = (Get-InstalledModule | Where-Object -Property Name -eq 'CosmosDB' | Measure-Object | Select-Object -ExpandProperty Count)
$IsInstalled = (Get-InstalledModule | Where-Object -Property Name -eq 'NuGet' | Measure-Object | Select-Object -ExpandProperty Count)
if(!$IsInstalled){
    $errMess = "One or more dependencies is not installed!";
    Write-Host $errMess -ForegroundColor Red;
    Throw $errMess;
}

Write-Host "Creating user defined functions" -ForegroundColor Blue;
Write-Host "    Open-NvimNotes" -ForegroundColor Yellow;
function Open-NvimNotes {
    Write-Host "Opening notes with nvim" -ForegroundColor Blue;
    nvim "C:\Users\ewentzel\Crap\Notes\note1.txt" +$;
}
Write-Host "    Get-AzureFunctionApps" -ForegroundColor Yellow;
function Get-AzureFunctionApps {
    Write-Host "Fetching function apps from Azure using Azure CLI" -ForegroundColor Blue;
    $functions = (az functionapp list);
    Write-Host "Converting json string to object" -ForegroundColor Blue;
    $JsonFunctions = ($functions | ConvertFrom-Json);
    Write-Host "Returning object" -ForegroundColor Blue;
    return $JsonFunctions;
}
Write-Host "    Get-AzureKeyVaults" -ForegroundColor Yellow;
function Get-AzureKeyVaults {
    Write-Host "Fetching key vaults from Azure using Azure CLI" -ForegroundColor Blue;
    $vaults = (az keyvault list);
    Write-Host "Converting json string to object" -ForegroundColor Blue;
    $JsonFunctions = ($vaults | ConvertFrom-Json);
    Write-Host "Returning object" -ForegroundColor Blue;
    return $JsonFunctions;
}
Write-Host "    Test-Unit" -ForegroundColor Yellow;
function Test-Unit {
    param (
        [Parameter(Mandatory=$false)][string]$TestName,
        [Parameter(Mandatory=$false)][switch]$IncludeIntegrationTests
    )
    
    if($PSBoundParameters.ContainsKey('TestName')){
        Write-Host "dotnet test --filter name=$TestName" -ForegroundColor Blue;
        dotnet test --filter "FullyQualifiedName~$TestName"
        return;
    }

    if($IncludeIntegrationTests.IsPresent){
        Write-Host "dotnet test" -ForegroundColor Blue;
        dotnet test
        return
    }
    
    Write-Host "dotnet test --filter TestCategory!=Integration" -ForegroundColor Blue;
    dotnet test --filter TestCategory!=Integration
    return;
}
New-Alias -Name test -Value Test-Unit;
Write-Host "    Find-NuGet" -ForegroundColor Yellow;
function Find-NuGet {
    param (
        [Parameter(Mandatory=$true)][string]$NugetName
    )
    Write-Host "Find-Package -Source nuget.org -Name *$NugetName*" -ForegroundColor Blue;
    $Packages = Find-Package -Source nuget.org -Name *$NugetName*

    $FormattedList = $Packages | Select-Object Name, @{ Name = 'LatestVersion'; Expression = { $_.Version }}, Summary;
    return $FormattedList
}
New-Alias -Name fng -Value Find-NuGet;
Write-Host "    Find-NuGetVersions" -ForegroundColor Yellow;
function Find-NuGetVersions {
    param (
        [Parameter(Mandatory=$true)][string]$NugetName
    )
    Write-Host "Find-Package -Source nuget.org -Name $NugetName -AllVersions" -ForegroundColor Blue;
    $Packages = Find-Package -Source nuget.org -Name $NugetName -AllVersions

    Write-Host "Package name: $($Packages[0].Name)" 
    Write-Host "Package summary: $($Packages[0].Summary)"
    return $Packages | Select-Object Version;
}
New-Alias -Name fngv -Value Find-NuGetVersions;
Write-Host "    New-DotnetLaunchettings" -ForegroundColor Yellow;
function New-DotnetLaunchettings {
    #TODO: Clean up alot
    #TODO: Figure out Profile name instead of setting placeholder <projectRootFolderName>
    #TODO: Maybe add an alias to this function?
    param (
        [Parameter(Mandatory=$false)][string]$Csproj
    )

    $projectDir = "";
    if($PSBoundParameters.ContainsKey('Csproj')){
        Write-Host "Csproj was provided. Working in it's folder."
        $projectDir = Get-Item $Csproj | select -ExpandProperty Directory | select -ExpandProperty FullName
    }else{
        Write-Host "No csproj provided. Trying to find it manually."
        $projectDir = ls -Recurse | ? -Property Extension -eq '.csproj' | ? -Property Name -NotLike '*test*' | select -ExpandProperty Directory | select -ExpandProperty FullName;
        
        if(!(Test-Path $projectDir) || $projectDir.count -ne 1){
            throw "Something happened when getting the projectDir";
        }
    }

    $propertiesDir = "$projectDir/Properties";
    if(Test-Path $propertiesDir){
        Write-Host "Properties folder already exists. Skipping folder creation."
    }else{
        Write-Host "Creating properties folder"
        ni -ItemType Directory -Path $propertiesDir;
    }

    $launchsettingsFile = "$propertiesDir/launchsettings.json";
    if(Test-Path $launchsettingsFile){
        Write-Host "Launchsettings already exists. Why have you run this command? Do you think I'm a joke you little shit!?"
    }else{
        $launchsettingsFileContent = '
{
    "profiles": {
        "<projectRootFolderName>": {
            "commandName": "Project",
            "launchBrowser": true,
            "environmentVariables": {
                "ASPNETCORE_ENVIRONMENT": "Development"
            },
            "applicationUrl": "https://localhost:50001;http://localhost:5000"
        }
    }
}
        '
        Write-Host "Creating launchsettings.json";
        ni -ItemType File -Path $launchsettingsFile -Value $launchsettingsFileContent;
    }

    return
}

#TODO: Create function for finding correct secret.json and opening it here

#TODO: Create function for generating the functions setting (json list of functions to run) for azure functions project

#TODO: Create function creating local.settings.json (for azure function app projects)

Write-Host "Setting user defined variables" -ForegroundColor Blue;
Write-Host '    $thisRepoRootDir' -ForegroundColor Yellow;
$thisRepoRootDir = "C:\Users\ewentzel\OneDrive - Volvo Cars\Documents"
Write-Host '    $nvimConfigFile' -ForegroundColor Yellow;
$nvimConfigFile = "C:\Users\ewentzel\AppData\Local\nvim\init.vim"
Write-Host '    $nvimPluginsFolder' -ForegroundColor Yellow;
$nvimPluginsFolder = "C:\Users\ewentzel\OneDrive - Volvo Cars\Documents\nvim_plugins"
Write-Host '    $crap' -ForegroundColor Yellow;
$crap = "C:\Users\ewentzel\Crap"
Write-Host '    $repos' -ForegroundColor Yellow;
$repos = "C:\Users\ewentzel\source\repos"
Write-Host '    $dotnetSecretStore' -ForegroundColor Yellow;
$dotnetSecretStore = "$env:APPDATA\Microsoft\UserSecrets\"
Write-Host '    $ds' -ForegroundColor Yellow; #Makes sense to have var for this since almost all repos are prefixed with dataservices
$ds = "dataservices"