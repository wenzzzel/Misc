Write-Host "Adding to path variable" -ForegroundColor Blue;
$ENV:PATH += ";C:\Program Files\Git\bin";
$ENV:PATH += ";C:\Program Files\nodejs\";
$ENV:PATH += ";C:\Users\ewentzel\AppData\Roaming\npm";
$ENV:PATH += ";C:\Program Files\Neovim\bin";
$ENV:PATH += ";C:\Program Files\azure-documentdb-datamigrationtool-1.8.3";

Write-Host "Stepping into C:\Users\ewentzel\source\repos\" -ForegroundColor Blue;
cd "C:\Users\ewentzel\source\repos";

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

Write-Host "Setting user defined variables" -ForegroundColor Blue;
Write-Host '    $thisRepoRootDir' -ForegroundColor Yellow;
$thisRepoRootDir = "C:\Users\ewentzel\OneDrive - Volvo Cars\Documents"
Write-Host '    $nvimConfigFile' -ForegroundColor Yellow;
$nvimConfigFile = "C:\Users\ewentzel\AppData\Local\nvim\init.vim"
