Write-Host "Loading PSSecrets" -ForegroundColor Blue;
$PSSecretsPath = "C:\psSecrets.json";
if(!(Test-Path $PSSecretsPath)){
    Write-Host "No psSecrets.json found. Creating it..." -ForegroundColor Blue;
    New-Item -ItemType File -Path $PSSecretsPath; 
}
$PSSecrets = Get-Content $PSSecretsPath | ConvertFrom-Json;