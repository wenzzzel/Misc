function Find-NuGet {
    param (
        [Parameter(Mandatory=$true)][string]$NugetName
    )
    Write-Host "Find-Package -Source nuget.org -Name *$NugetName*" -ForegroundColor Blue;
    $Packages = Find-Package -Source nuget.org -Name *$NugetName*

    $FormattedList = $Packages | Select-Object Name, @{ Name = 'LatestVersion'; Expression = { $_.Version }}, Summary;
    return $FormattedList
}
New-Alias -Name fng -Value Find-NuGet;