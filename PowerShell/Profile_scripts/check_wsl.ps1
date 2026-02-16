Write-Host "Checking if Ubuntu in WSL (Windows Subsystem for Linux) is installed" -ForegroundColor Blue;

$ubuntuLine = wsl -l | ? {$_.Replace("`0","") -match 'Ubuntu'} | Select-Object -ExpandProperty Length;

if($ubuntuLine -gt 0) { 
    [bool]$UbuntuInstalled = $true;
} else {
    [bool]$UbuntuInstalled = $false;
}

if($UbuntuInstalled){
    Write-Host " ✔️ Ubuntu in WSL (Windows Subsystem for Linux) is installed.";
} else {
    Write-Host " ❌ Ubuntu in WSL (Windows Subsystem for Linux) is not installed. Docker will not work as expected. To install run: wsl --install -d Ubuntu . More info: https://learn.microsoft.com/en-us/windows/wsl/install";
}