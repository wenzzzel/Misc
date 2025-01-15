function Find-CodeRepo {
    param (
        [Parameter(Mandatory=$true)][string]$Filter,
        [PSDefaultValue(Value=$false)][bool]$ForceRefresh = $false
    )

    $githubreposFilePath = "$thisRepoRootDir/githubrepos.json"
    if(!(Test-Path $githubreposFilePath)){
        Write-Host "No githubrepos.json found @ $githubreposFilePath . Creating it..." -ForegroundColor Blue;
        New-Item -ItemType File -Path $githubreposFilePath; 
    }

    #TODO: Below few lines which is checking and creating state file is duplciated in check_reminders.ps1 as well. Could be a separate function instead
    $statePath = "$thisRepoRootDir/state.json" 
    if(!(Test-Path $statePath)){
        Write-Host "No state.json found @ $statePath . Creating it..." -ForegroundColor Blue;
        New-Item -ItemType File -Path $statePath; 
    }

    $state = (Get-Content -Raw $statePath | ConvertFrom-Json);

    $currentDate = (Get-Date);
    $currentWeek = (Get-Date -UFormat %V);

    if(($ForceRefresh -eq $false) -and ($state.LastGithubReposSyncWeek -eq ($currentDate.Year.ToString() + "-" + $currentWeek))){ 
        return Get-Content -Raw $githubreposFilePath | 
            ConvertFrom-Json | 
            Where-Object -Property name -like "*$Filter*" | 
            Select-Object -ExpandProperty name;
    }

    Write-Host " ⏳ Github repos hasn't been updated this week. Need to update. This will take a while. Please be patient!";

    $github_repos = gh repo list volvo-cars --limit 99999 --json name --jq '.[] | select(.name | startswith("grip"))' | ForEach-Object { "$_," };
    $github_repos[-1] = $github_repos[-1].Substring(0, $github_repos[-1].Length - 1);
    $github_repos = @("[") + $github_repos + @("]");
    Set-Content -Value $github_repos -Path $githubreposFilePath -Force;

    Write-Host " ✔️ Github repos updated successfully! Caching until next week.";
    Add-Member -InputObject $state -Name LastGithubReposSyncWeek -Value ($currentDate.Year.ToString() + "-" + $currentWeek) -MemberType NoteProperty -Force;
    Set-Content -Value ($state | ConvertTo-Json) -Path $statePath -Force;

    return $github_repos | 
        ConvertFrom-Json | 
        Where-Object -Property name -like "*$Filter*" | 
        Select-Object -ExpandProperty name;
}
New-Alias -Name fcr -Value Find-CodeRepo;