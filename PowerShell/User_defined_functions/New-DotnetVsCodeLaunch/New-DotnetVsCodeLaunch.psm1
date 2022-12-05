#################################################
# Used for setting up Azure Functions local env #
#################################################

function New-DotnetVsCodeLaunch {
    #TODO: Clean up alot
    #TODO: Figure out Profile name instead of setting placeholder <projectRootFolderName>
    #TODO: Maybe add an alias to this function?
    param (
        [Parameter(Mandatory=$false)][string]$Csproj
    )

    $vscodeDir = "./.vscode";
    if(Test-Path $vscodeDir){
        Write-Host ".vscode folder already exists. Skipping folder creation."
    }else{
        Write-Host "Creating .vscode folder"
        ni -ItemType Directory -Path $vscodeDir;
    }

    $vsCodeLaunch = "$vscodeDir/launch.json";
    if(Test-Path $vsCodeLaunch){
        Write-Host "Launch already exists. Why have you run this command? Do you think I'm a joke you little shit!?"
    }else{
        $vsCodeLaunchFileContent = '
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Attach to .NET Functions",
            "type": "coreclr",
            "request": "attach",
            "processId": "${command:azureFunctions.pickProcess}"
        },
        {
            "name": "Launch .NET Functions",
            "type": "coreclr",
            "request": "launch",
            "program": "func",
            "args": ["host", "start"],
            "cwd": "${workspaceFolder}/<ProjectRootFolderName>/bin/Debug/netcoreapp6.0"
        }
    ]
}
        '
        Write-Host "Creating launch.json";
        ni -ItemType File -Path $vsCodeLaunch -Value $vsCodeLaunchFileContent;
    }

    return
}