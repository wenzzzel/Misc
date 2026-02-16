# Below function has dependencies to AZ cli
function Grant-AzureSqlRole {
    param (
        [Parameter(Mandatory=$true)][ValidateSet('Reader','Contributor')][string]$SqlRole,
        [Parameter(Mandatory=$true)][ValidateSet('GRIP','ed-grip-test-qa')][string]$Subscription,
        [Parameter(Mandatory=$true)][string]$DbAccountName,
        [Parameter(Mandatory=$true)][string]$ResourceGroup
    )
    $roledefinitionId = "";
    $subscription = "";
    $eWentzelPrincipalId = "5e27fe3e-e461-4375-9f72-55ed471e7b11"

    if ($Subscription -eq "GRIP"){
        $subscription = "7ec3a5a7-fa2d-4371-b923-796b94aee75d";
    } elseif ($Subscription -eq "ed-grip-test-qa"){
        $subscription = "43d4530a-736d-4515-b5c5-e43adbe8c02c";
    }

    if ($SqlRole -eq "Reader"){
        $roledefinitionId = "00000000-0000-0000-0000-000000000001";
        
    } elseif ($SqlRole -eq "Contributor"){
        $roledefinitionId = "00000000-0000-0000-0000-000000000002";
    }

    Write-Host "az account set --subscription `"$subscription`";" -ForegroundColor Blue;
    az account set `
        --subscription "$subscription";


    Write-Host "az cosmosdb sql role assignment create --account-name $DbAccountName --principal-id `"$eWentzelPrincipalId`" --resource-group $ResourceGroup --scope `"/`" --role-definition-id $roledefinitionId" -ForegroundColor Blue;
    az cosmosdb sql role assignment create `
        --account-name $DbAccountName `
        --principal-id "$eWentzelPrincipalId" `
        --resource-group $ResourceGroup `
        --scope "/" `
        --role-definition-id $roledefinitionId
}