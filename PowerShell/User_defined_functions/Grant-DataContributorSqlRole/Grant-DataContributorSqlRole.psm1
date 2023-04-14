# Below function has dependencies to both AZ cli and Grant-PimRole function in this same repo

function Grant-DataContributorSqlRole {
    param (
        [Parameter(Mandatory=$true)][string]$DbAccountName,
        [Parameter(Mandatory=$true)][string]$ResourceGroup
    )

    Write-Host "Will try to grant PIM role just in case. Please ignore any error stating that Role Assignment already exists."
    Grant-PimRole -Justification "Need to add Sql Role Assignment for $DbAccountName in resource group $ResourceGroup.";

    Write-Host "az account set --subscription `"7ec3a5a7-fa2d-4371-b923-796b94aee75d`";" -ForegroundColor Blue;
    az account set --subscription "7ec3a5a7-fa2d-4371-b923-796b94aee75d"; #GRIP Subscription
    Write-Host "az cosmosdb sql role assignment create --account-name $DbAccountName --principal-id `"5e27fe3e-e461-4375-9f72-55ed471e7b11`" --resource-group $ResourceGroup --scope `"/`" --role-definition-id 00000000-0000-0000-0000-000000000002" -ForegroundColor Blue;
    az cosmosdb sql role assignment create --account-name $DbAccountName --principal-id "5e27fe3e-e461-4375-9f72-55ed471e7b11" --resource-group $ResourceGroup --scope "/" --role-definition-id 00000000-0000-0000-0000-000000000002

    # #Below is for adding the role on the ed-grip-test-qa Subscription subscription. However, it's not needed for now. Might uncomment later...
    # Write-Host "az account set --subscription `"43d4530a-736d-4515-b5c5-e43adbe8c02c`";" -ForegroundColor Blue;
    # az account set --subscription "43d4530a-736d-4515-b5c5-e43adbe8c02c"; #ed-grip-test-qa Subscription    
    # Write-Host "az cosmosdb sql role assignment create --account-name $DbAccountName --principal-id `"5e27fe3e-e461-4375-9f72-55ed471e7b11`" --resource-group $ResourceGroup --scope `"/`" --role-definition-id 00000000-0000-0000-0000-000000000002" -ForegroundColor Blue;
    # az cosmosdb sql role assignment create --account-name $DbAccountName --principal-id "5e27fe3e-e461-4375-9f72-55ed471e7b11" --resource-group $ResourceGroup --scope "/" --role-definition-id 00000000-0000-0000-0000-000000000002
}