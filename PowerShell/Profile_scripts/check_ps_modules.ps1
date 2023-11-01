Write-Host "Making sure powershell module dependencies are installed" -ForegroundColor Blue;
$moduleDependencies = @(
    'NuGet',
    'Az',
    'CosmosDB'
);
$moduleDependencies = $moduleDependencies.GetEnumerator() | Sort-Object;
foreach($moduleDependency in $moduleDependencies){
    [bool]$IsInstalled = (Get-InstalledModule | Where-Object -Property Name -eq $moduleDependency | Measure-Object | Select-Object -ExpandProperty Count)
    if(!$IsInstalled){
        Write-Host " ❌ $moduleDependency. Trying to install it..."
        Install-Module -Name $moduleDependency -Force;
        Write-Host "Checking that $ModuleDependency was successfully installed"
        [bool]$IsInstalled = (Get-InstalledModule | Where-Object -Property Name -eq $moduleDependency | Measure-Object | Select-Object -ExpandProperty Count)
        if(!$IsInstalled){
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