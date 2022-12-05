function Edit-DotnetUserSecrets {
    Write-Host "Looking for csproj in sub directories"
    $csprojs = ls -Recurse | ? -Property Extension -eq '.csproj';
    Write-Host "Found $($csprojs | Measure-Object | Select-Object -ExpandProperty Count) csproj(s)"

    foreach ($csproj in $csprojs) {
        $xmlNode = select-xml `
            -Path $csProj.FullName `
            -XPath "/Project/PropertyGroup/UserSecretsId" `

        if($null -eq $xmlNode){
            Write-Host "No user secrets store initiated on this project";
            continue;
        }

        $userSecret = $xmlNode.Node.InnerText
        $secretStoreDirectory = (ls $env:APPDATA\Microsoft\UserSecrets\ | ? -Property Name -Like $userSecret)
        $secretsFile = (ls $secretStoreDirectory | ? -Property Name -eq 'secrets.json');
        if($null -eq $secretsFile){
            Write-Host "User secrets are initiated, but no secrets have been set yet. Creating file for it"
            $secretsFile = (ni -ItemType File -Path "$secretStoreDirectory/secrets.json")
        }
        Write-Host "Opening secrets file"
        code $secretsFile
    }
}