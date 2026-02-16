function Grant-PimRole {
    param (
        [Parameter(Mandatory=$true)][string]$Justification
    )
    Write-Host "Adding PIM role!" -ForegroundColor Blue;

    $managementgroupID = "81fa766e-a349-4867-8bf4-ab35e250a08f" # Tenant Root Group
    $userObjectID = "5e27fe3e-e461-4375-9f72-55ed471e7b11" #ewentzel in volvocars AD

    ##################################
    #Add for Production subscription #
    ##################################
    $RoleDefinitionID = "df2acbbe-5c63-4762-9d97-7130ba4b2941" # GRIP_Contributor
    $scope = "/subscriptions/7ec3a5a7-fa2d-4371-b923-796b94aee75d" # Prod subscription
    $guid = (New-Guid)
    $startTime = Get-Date -Format o

    try {
        New-AzRoleAssignmentScheduleRequest `
        -Name $guid `
        -Scope $scope `
        -ExpirationDuration PT2H `
        -ExpirationType AfterDuration `
        -PrincipalId $userObjectID `
        -RequestType SelfActivate `
        -RoleDefinitionId /providersproviders/Microsoft.Management/managementGroups/$managementgroupID/providers/Microsoft.Authorization/roleDefinitions/$roledefinitionId `
        -ScheduleInfoStartDateTime $startTime `
        -Justification $Justification `
        -ErrorAction stop
    }
    catch {
        Write-Host "Unsuccessful granting PIM role. A common issues is that the account is not properly connected to Azure. The Azure Powershell module is used for this. Try running Clear-AzContext followed by Connect-AzAccount to reset connection. Full error thrown below:";
        throw;
    }
}