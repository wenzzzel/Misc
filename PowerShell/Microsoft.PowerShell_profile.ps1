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
$IsInstalled = (Get-InstalledModule | Where-Object -Property Name -eq 'CosmosDB' | Measure-Object | Select-Object -ExpandProperty Count)
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
        [Parameter(Mandatory=$false)][string]$TestName
    )
    
    if($PSBoundParameters.ContainsKey('TestName')){
        Write-Host "dotnet test --filter name=$TestName" -ForegroundColor Blue;
        dotnet test --filter "name=$TestName"
    }else{
        Write-Host "dotnet test" -ForegroundColor Blue;
        dotnet test
    }
}
New-Alias -Name test -Value Test-Unit;

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
