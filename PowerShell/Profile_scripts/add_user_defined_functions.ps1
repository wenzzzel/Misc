Write-Host "Adding user defined functions" -ForegroundColor Blue;
$UserDefinedFunctions = (Get-ChildItem "$thisRepoRootDir/User_defined_functions") | Sort-Object;
$modulePaths = ($env:PSModulePath.Split(";"));
foreach($UserDefinedFunction in $UserDefinedFunctions){
    Write-Host " ⚙️ $($UserDefinedFunction.Name)" -ForegroundColor Yellow;

    foreach($modulePath in $modulePaths){
        Copy-Item $UserDefinedFunction -Destination $modulePath -Recurse -Force;
    }
    
    Import-Module $UserDefinedFunction.Name;
}