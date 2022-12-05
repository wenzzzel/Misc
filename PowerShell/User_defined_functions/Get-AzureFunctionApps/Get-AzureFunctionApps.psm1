function Get-AzureFunctionApps {
    Write-Host "Fetching function apps from Azure using Azure CLI" -ForegroundColor Blue;
    $functions = (az functionapp list);
    Write-Host "Converting json string to object" -ForegroundColor Blue;
    $JsonFunctions = ($functions | ConvertFrom-Json);
    Write-Host "Returning object" -ForegroundColor Blue;
    return $JsonFunctions;
}