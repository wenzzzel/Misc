function Grant-PimRole {
    param (
        [Parameter(Mandatory=$true)][string]$Justification,
        [Parameter(Mandatory=$true)][bool]$ProductionEnvironment
    )
    Write-Host "Adding PIM role!" -ForegroundColor Blue;

    if($ProductionEnvironment){
        $RoleDefinitionID = "df2acbbe-5c63-4762-9d97-7130ba4b2941" # Contributor
        $scope = "/subscriptions/7ec3a5a7-fa2d-4371-b923-796b94aee75d" # Prod subscription
    }else {
        $RoleDefinitionID = "b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor
        $scope = "/subscriptions/43d4530a-736d-4515-b5c5-e43adbe8c02c" # Non-prod subscription
    }

    $managementgroupID = "81fa766e-a349-4867-8bf4-ab35e250a08f" # Tenant Root Group
    $guid = (New-Guid)
    $startTime = Get-Date -Format o
    $userObjectID = "5e27fe3e-e461-4375-9f72-55ed471e7b11" #ewentzel in volvocars AD

    New-AzRoleAssignmentScheduleRequest `
        -Name $guid `
        -Scope $scope `
        -ExpirationDuration PT2H `
        -ExpirationType AfterDuration `
        -PrincipalId $userObjectID `
        -RequestType SelfActivate `
        -RoleDefinitionId /providersproviders/Microsoft.Management/managementGroups/$managementgroupID/providers/Microsoft.Authorization/roleDefinitions/$roledefinitionId `
        -ScheduleInfoStartDateTime $startTime `
        -Justification $Justification
}