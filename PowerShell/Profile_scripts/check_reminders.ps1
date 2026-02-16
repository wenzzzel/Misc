Write-Host "Checking reminders" -ForegroundColor Blue;

$statePath = "$thisRepoRootDir/state.json"

if(!(Test-Path $statePath)){
    Write-Host "No state.json found @ $statePath . Creating it..." -ForegroundColor Blue;
    New-Item -ItemType File -Path $statePath; 
}

$state = (Get-Content -Raw $statePath | ConvertFrom-Json);
$currentDate = (Get-Date);

Write-Host " 🕐 Checking if you are on time for standup";
if($state.LastOnTimeForStandupCheck -eq ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString() + "-" + $currentDate.Day.ToString())){ 
    Write-Host "    ✔️ Already did the check today, not going to check twice.";
} else {
    $standupTime = Get-Date -Hour 8 -Minute 45 -Second 0;

    if($currentDate -lt $standupTime){
        Write-Host "    🎉 You are on time for standup today!";
        $state.OnTimeForStandupCount = $state.OnTimeForStandupCount + 1;
        Add-Member -InputObject $state -Name LastOnTimeForStandupCheck -Value ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString() + "-" + $currentDate.Day.ToString()) -MemberType NoteProperty -Force;
        Add-Member -InputObject $state -Name OnTimeForStandupCount -Value ($state.OnTimeForStandupCount) -MemberType NoteProperty -Force;
        Set-Content -Value ($state | ConvertTo-Json) -Path $statePath -Force;
    } else {
        Write-Host "`a    😡 You were late for standup today!";
        $state.LateForStandupCount = $state.LateForStandupCount + 1;
        Add-Member -InputObject $state -Name LastOnTimeForStandupCheck -Value ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString() + "-" + $currentDate.Day.ToString()) -MemberType NoteProperty -Force;
        Add-Member -InputObject $state -Name LateForStandupCount -Value ($state.LateForStandupCount) -MemberType NoteProperty -Force;
        Set-Content -Value ($state | ConvertTo-Json) -Path $statePath -Force;
    }
}
$onTimePercentage = [Math]::Round(($state.OnTimeForStandupCount / ($state.OnTimeForStandupCount + $state.LateForStandupCount)) * 100);
if ($onTimePercentage -gt 94){
    Write-Host "    📉 $onTimePercentage%" -ForegroundColor Green
} elseif ($onTimePercentage -gt 89){
    Write-Host "    📉 $onTimePercentage%"
} else {
    Write-Host "    📉 $onTimePercentage%" -ForegroundColor Red
}

Write-Host " 🕐 TimeReport reminder";
$currentWeek = (Get-Date -UFormat %V);
if($state.TimeReport -eq ($currentDate.Year.ToString() + "-" + $currentWeek)){ 
    Write-Host "    ✔️ Time report already done this week. Good for you!";
} else {
    $timeReportDone = "";
    while($timeReportDone -notin "Y", "N"){
        $timeReportDone = Read-Host -Prompt "    ❔ Did you do the time report for this week yet? [Y/N]"
    }
    if($timeReportDone -eq "Y"){
        Write-Host "    ✔️ Very good! Will ask again next week";
        Add-Member -InputObject $state -Name TimeReport -Value ($currentDate.Year.ToString() + "-" + $currentWeek) -MemberType NoteProperty -Force;
        Set-Content -Value ($state | ConvertTo-Json) -Path $statePath -Force;
    }
    
    if($timeReportDone -eq "N"){
        Write-Host "`a    ❌ Please submit your time report. Will ask you again next time!";
    }
}