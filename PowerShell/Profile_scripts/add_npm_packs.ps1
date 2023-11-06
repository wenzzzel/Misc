Write-Host "Checking for npm packages" -ForegroundColor Blue;

$statePath = "$thisRepoRootDir/state.json"

if(!(Test-Path $statePath)){
    Write-Host "No state.json found @ $statePath . Creating it..." -ForegroundColor Blue;
    New-Item -ItemType File -Path $statePath -Value "{}"; 
}

$state = (Get-Content -Raw $statePath | ConvertFrom-Json);

$currentDate = (Get-Date);

$npmPackages = @(
    "@angular/cli",
    "newman",
    "@azure/static-web-apps-cli"
)
$npmPackages = $npmPackages.GetEnumerator() | Sort-Object;

if($state.LastNpmPackCheck -eq ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString() + "-" + $currentDate.Day.ToString())){ 
    Write-Host " ⏩ Npm package dependencies were already checked today, skipping this step until tomorrow...";
    foreach($package in $npmPackages.GetEnumerator()){
        Write-Host " ➖ $package" -ForegroundColor DarkGray;
    }
    return;
}

$allPackagesInstalled = $true;
$installedPackages = (npm list -g);
foreach($package in $npmPackages.GetEnumerator()){
    $packageIsInstalled = $installedPackages -like "*$package*"
    if($packageIsInstalled){
        Write-Host " ✔️ $package was already installed";
    }else {
        Write-Host " ❌ $package was not installed. Consider running `"npm install -g $($package)`"";
        $allPackagesInstalled = $false;
    }
}

if($allPackagesInstalled){
    Add-Member -InputObject $state -Name LastNpmPackCheck -Value ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString() + "-" + $currentDate.Day.ToString()) -MemberType NoteProperty;
    Set-Content -Value ($state | ConvertTo-Json) -Path $statePath;
}