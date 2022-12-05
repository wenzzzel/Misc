function New-DotnetLaunchettings {
    #TODO: Clean up alot
    #TODO: Figure out Profile name instead of setting placeholder <projectRootFolderName>
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

    $propertiesDir = "$projectDir/Properties";
    if(Test-Path $propertiesDir){
        Write-Host "Properties folder already exists. Skipping folder creation."
    }else{
        Write-Host "Creating properties folder"
        ni -ItemType Directory -Path $propertiesDir;
    }

    $launchsettingsFile = "$propertiesDir/launchsettings.json";
    if(Test-Path $launchsettingsFile){
        Write-Host "Launchsettings already exists. Why have you run this command? Do you think I'm a joke you little shit!?"
    }else{
        $launchsettingsFileContent = '
{
    "profiles": {
        "<projectRootFolderName>": {
            "commandName": "Project",
            "launchBrowser": true,
            "environmentVariables": {
                "ASPNETCORE_ENVIRONMENT": "Development"
            },
            "applicationUrl": "https://localhost:50001;http://localhost:5000"
        }
    }
}
        '
        Write-Host "Creating launchsettings.json";
        ni -ItemType File -Path $launchsettingsFile -Value $launchsettingsFileContent;
    }

    return
}