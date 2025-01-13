Write-Host "Checking reminders" -ForegroundColor Blue;

$statePath = "$thisRepoRootDir/state.json"

if(!(Test-Path $statePath)){
    Write-Host "No state.json found @ $statePath . Creating it..." -ForegroundColor Blue;
    New-Item -ItemType File -Path $statePath; 
}

$state = (Get-Content -Raw $statePath | ConvertFrom-Json);

Write-Host " 🕐 TimeReport reminder";
$currentDate = (Get-Date);
$currentWeek = (Get-Date -UFormat %V);

if($state.TimeReport -eq ($currentDate.Year.ToString() + "-" + $currentWeek)){ 
    Write-Host " ✔️ Time report already done this month. Good for you!";
    return;
}

$timeReportDone = "";
while($timeReportDone -notin "Y", "N"){
    $timeReportDone = Read-Host -Prompt "Did you do the time report yet? [Y/N]"
}
if($timeReportDone -eq "Y"){
    Write-Host " ✔️ Very good! Will ask again next week";
    Add-Member -InputObject $state -Name TimeReport -Value ($currentDate.Year.ToString() + "-" + $currentWeek) -MemberType NoteProperty -Force;
    Set-Content -Value ($state | ConvertTo-Json) -Path $statePath -Force;
}

if($timeReportDone -eq "N"){
    Write-Host "`a     ❌ Please submit your time report. Will ask you again next time!";
}