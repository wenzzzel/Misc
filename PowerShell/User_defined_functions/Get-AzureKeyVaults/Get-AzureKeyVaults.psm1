function Get-AzureKeyVaults {
    Write-Host "Fetching key vaults from Azure using Azure CLI" -ForegroundColor Blue;
    $vaults = (az keyvault list);
    Write-Host "Converting json string to object" -ForegroundColor Blue;
    $JsonFunctions = ($vaults | ConvertFrom-Json);
    Write-Host "Returning object" -ForegroundColor Blue;
    return $JsonFunctions;
}