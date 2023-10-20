# Below function has dependencies to both AZ cli and Grant-PimRole function in this same repo

function Grant-AzureSqlRole {
    param (
        [Parameter(Mandatory=$true)][ValidateSet('Reader','Contributor')][string]$SqlRole,
        [Parameter(Mandatory=$true)][string]$DbAccountName,
        [Parameter(Mandatory=$true)][string]$ResourceGroup
    )
    $roledefinitionId = "";
    $eWentzelPrincipalId = "5e27fe3e-e461-4375-9f72-55ed471e7b11"
    $gripSubscriptionId = "7ec3a5a7-fa2d-4371-b923-796b94aee75d"

    if ($SqlRole -eq "Reader"){
        $roledefinitionId = "00000000-0000-0000-0000-000000000001";
        
    } elseif ($SqlRole -eq "Contributor"){
        $roledefinitionId = "00000000-0000-0000-0000-000000000002";
    }

    Write-Host "az account set --subscription `"$gripSubscriptionId`";" -ForegroundColor Blue;
    az account set `
        --subscription "$gripSubscriptionId";
    Write-Host "az cosmosdb sql role assignment create --account-name $DbAccountName --principal-id `"$eWentzelPrincipalId`" --resource-group $ResourceGroup --scope `"/`" --role-definition-id $roledefinitionId" -ForegroundColor Blue;
    az cosmosdb sql role assignment create `
        --account-name $DbAccountName `
        --principal-id "$eWentzelPrincipalId" `
        --resource-group $ResourceGroup `
        --scope "/" `
        --role-definition-id $roledefinitionId
}