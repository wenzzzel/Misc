function Find-NuGetVersions {
    param (
        [Parameter(Mandatory=$true)][string]$NugetName
    )
    Write-Host "Find-Package -Source nuget.org -Name $NugetName -AllVersions" -ForegroundColor Blue;
    $Packages = Find-Package -Source nuget.org -Name $NugetName -AllVersions

    Write-Host "Package name: $($Packages[0].Name)" 
    Write-Host "Package summary: $($Packages[0].Summary)"
    return $Packages | Select-Object Version;
}
New-Alias -Name fngv -Value Find-NuGetVersions;