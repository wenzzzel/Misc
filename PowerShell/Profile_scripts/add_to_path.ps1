Write-Host "Adding general stuff to path variable" -ForegroundColor Blue;
$pathsToAdd = @{
    "choco" = "C:\ProgramData\chocolatey"
    "openssl" = "C:\Program Files\Git\usr\bin" #This is where openssl.exe is located
    "servicebus-cli" = "C:\Program Files\servicebus-cli"
}
$whiteSpaceCount = 40;
$pathsToAdd = $pathsToAdd.GetEnumerator() | Sort-Object -Property Key
foreach($path in $pathsToAdd.GetEnumerator()){
    $calculatedWhiteSpaceCount = $whiteSpaceCount - $path.Key.Length
    $whiteSpaces = "";
    for ($i = 0; $i -lt $calculatedWhiteSpaceCount; $i++) {
        $whiteSpaces = $whiteSpaces + " ";
    }

    $ENV:PATH += ";$($path.Value)";
    $pathExists = Test-Path $path.Value;
    if($pathExists){
        Write-Host " ✔️ $($path.Key) $($whiteSpaces) $($path.Value)";
    }else {
        Write-Host " ❌ $($path.Key) $($whiteSpaces) Doesn't exist. $($path.Value)";
    }
}