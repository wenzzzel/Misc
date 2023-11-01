Write-Host "Checking reminders" -ForegroundColor Blue;
$reminderState = (Get-Content -Raw "$thisRepoRootDir/reminder_state.json" | ConvertFrom-Json);

Write-Host " 🕐 TimeReport reminder";
$currentDate = (Get-Date);
if($currentDate.Day -gt 20){
    if($reminderState.TimeReport -ne ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString())){
        $timeReportDone = "No input given yet...";
        while($timeReportDone -notin "Y", "N"){
            $timeReportDone = Read-Host -Prompt "Did you do the time report yet? [Y/N]"
        }
        if($timeReportDone -eq "Y"){
            Write-Host "     ✔️ Very good! Will ask again next month";
            $reminderState.TimeReport = ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString());
            Set-Content -Value ($reminderState | ConvertTo-Json) -Path "$thisRepoRootDir/reminder_state.json";
        }
        
        if($timeReportDone -eq "N"){
            Write-Host "`a     ❌ Please submit your time report. Will ask you again next time!";
        }
    } else{
        Write-Host "     ✔️ Time report already done this month. Good for you!"
    }
}