Write-Host "Making sure powershell module dependencies are installed" -ForegroundColor Blue;

$statePath = "$thisRepoRootDir/state.json"

if(!(Test-Path $statePath)){
    Write-Host "No state.json found @ $statePath . Creating it..." -ForegroundColor Blue;
    New-Item -ItemType File -Path $statePath -Value "{}"; 
}

$state = (Get-Content -Raw $statePath | ConvertFrom-Json);

$currentDate = (Get-Date);

$moduleDependencies = @(
    'NuGet',
    'Az',
    'CosmosDB',
    'posh-git'
);
$moduleDependencies = $moduleDependencies.GetEnumerator() | Sort-Object;

if($state.LastPsModuleCheck -eq ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString() + "-" + $currentDate.Day.ToString())){ 
    Write-Host " ⏩ Powershell module dependencies were already checked today, skipping this step until tomorrow...";
    foreach($moduleDependency in $moduleDependencies){
        Write-Host " ➖ $moduleDependency";
    }

    return;
}

$installedModules = Get-InstalledModule | Where-Object -Property Name -In $moduleDependencies;

$allPackagesInstalled = $true;
foreach($moduleDependency in $moduleDependencies){
    [bool]$IsInstalled = ($installedModules | Where-Object -Property Name -eq $moduleDependency | Measure-Object | Select-Object -ExpandProperty Count)
    if(!$IsInstalled){
        Write-Host " ❌ $moduleDependency. Trying to install it..."
        Install-Module -Name $moduleDependency -Force;
        Import-Module -Name $moduleDependency -Force;
        Write-Host "Checking that $ModuleDependency was successfully installed"
        [bool]$IsInstalled = (Get-InstalledModule | Where-Object -Property Name -eq $moduleDependency | Measure-Object | Select-Object -ExpandProperty Count)
        if(!$IsInstalled){
            $allPackagesInstalled = $false;
            $errMess = "The dependency $moduleDependency could not be found! Please resolve before running this powershell profile!";
            Write-Host $errMess -ForegroundColor Red;
            Throw $errMess;
        } else {
        Write-Host " ✔️ $moduleDependency";
    }
    } else {
        Write-Host " ✔️ $moduleDependency";
    }
}

if($allPackagesInstalled){
    Add-Member -InputObject $state -Name LastPsModuleCheck -Value ($currentDate.Year.ToString() + "-" + $currentDate.Month.ToString() + "-" + $currentDate.Day.ToString()) -MemberType NoteProperty;
    Set-Content -Value ($state | ConvertTo-Json) -Path $statePath;
}