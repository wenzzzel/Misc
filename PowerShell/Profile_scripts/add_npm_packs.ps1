Write-Host "Checking for npm packages" -ForegroundColor Blue;
$npmPackages = @(
    "@angular/cli",
    "newman",
    "@azure/static-web-apps-cli"
)
$npmPackages = $npmPackages.GetEnumerator() | Sort-Object;
foreach($package in $npmPackages.GetEnumerator()){
    $installedPackages = (npm list -g);
    $packageIsInstalled = $installedPackages -like "*$package*"
    if($packageIsInstalled){
        Write-Host " ✔️ $package was already installed";
    }else {
        Write-Host " ❌ $package was not installed. Consider running `"npm install -g $($package)`"";
    }
}