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