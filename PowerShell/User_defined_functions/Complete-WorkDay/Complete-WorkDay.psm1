function Complete-WorkDay {
    Write-Host "Completing work day!";
    
    $statePath = "$thisRepoRootDir/state.json"

    if(!(Test-Path $statePath)){
        Write-Host "No state.json found @ $statePath . Creating it..." -ForegroundColor Blue;
        New-Item -ItemType File -Path $statePath; 
    }

    # TODO: Fetch state from yesterday and display summary of what was being worked on
    $state = (Get-Content -Raw $statePath | ConvertFrom-Json);

    $currentDate = (Get-Date);
    $worklogPathYesterday = ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString() + "-" + ($currentDate.Day-1).ToString());

    Write-Host "Summary of yesterdays work"
    foreach($worklog in $state.WorkLog.$worklogPathYesterday){
        Write-Host " ➖ $worklog";
    }
}