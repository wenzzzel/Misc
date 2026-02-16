function Invoke-CoPilotCliSuggest {
    param (
        [Parameter(Mandatory=$true)][string]$Question
    )
    Write-Host "gh copilot suggest `"$Question`"" -ForegroundColor Blue;
    gh copilot suggest "$Question";
}