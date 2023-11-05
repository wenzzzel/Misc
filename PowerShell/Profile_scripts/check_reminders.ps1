Write-Host "Checking reminders" -ForegroundColor Blue;

$statePath = "$thisRepoRootDir/state.json"

if(!(Test-Path $statePath)){
    Write-Host "No state.json found. Creating it..." -ForegroundColor Blue;
    New-Item -ItemType File -Path $statePath; 
}

$state = (Get-Content -Raw $statePath | ConvertFrom-Json);

Write-Host " 🕐 TimeReport reminder";
$currentDate = (Get-Date);

if($currentDate.Day -lt 20){ return; }

if($state.TimeReport -eq ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString())){ 
    Write-Host "     ✔️ Time report already done this month. Good for you!";
    return;
}

$timeReportDone = "";
while($timeReportDone -notin "Y", "N"){
    $timeReportDone = Read-Host -Prompt "Did you do the time report yet? [Y/N]"
}
if($timeReportDone -eq "Y"){
    Write-Host "     ✔️ Very good! Will ask again next month";
    $state.TimeReport = ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString());
    Set-Content -Value ($state | ConvertTo-Json) -Path $statePath;
}

if($timeReportDone -eq "N"){
    Write-Host "`a     ❌ Please submit your time report. Will ask you again next time!";
}