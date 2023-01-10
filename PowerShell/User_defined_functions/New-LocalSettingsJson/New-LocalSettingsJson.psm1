#################################################
# Used for setting up Azure Functions local env #
#################################################

function New-LocalSettingsJson {
    #TODO: Clean up alot
    #TODO: Maybe add an alias to this function?
    param (
        [Parameter(Mandatory=$false)][string]$Csproj
    )

    $projectDir = "";
    if($PSBoundParameters.ContainsKey('Csproj')){
        Write-Host "Csproj was provided. Working in it's folder."
        $projectDir = Get-Item $Csproj | select -ExpandProperty Directory | select -ExpandProperty FullName
    }else{
        Write-Host "No csproj provided. Trying to find it manually."
        $projectDir = ls -Recurse | ? -Property Extension -eq '.csproj' | ? -Property Name -NotLike '*test*' | select -ExpandProperty Directory | select -ExpandProperty FullName;
        
        if(!(Test-Path $projectDir) || $projectDir.count -ne 1){
            throw "Something happened when getting the projectDir";
        }
    }

    #TODO: A check for azure function project, so we cant add this in, for example, a web-api

    $localsettingsFile = "$projectDir/local.settings.json";
    if(Test-Path $localsettingsFile){
        Write-Host "local.settings.json already exists. Why have you run this command? Do you think I'm a joke you little shit!?"
    }else{
        $localsettingsFileContent = '
{
    "IsEncrypted": false,
    "Values": {
        "FUNCTIONS_WORKER_RUNTIME": "dotnet",
        "AzureWebJobsStorage": "UseDevelopmentStorage=true"
    }
}'
        
        Write-Host "Creating launchsettings.json";
        New-Item -ItemType File -Path $localsettingsFile -Value $localsettingsFileContent;
    }

    return
}