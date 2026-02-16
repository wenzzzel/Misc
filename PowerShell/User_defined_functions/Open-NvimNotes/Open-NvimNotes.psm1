function Open-NvimNotes {
    Write-Host "Opening notes with nvim" -ForegroundColor Blue;

    if (Test-Path "$env:OneDriveCommercial\Documents\note1.txt"){
        nvim "$env:OneDriveCommercial\Documents\note1.txt" +$;
    } else {
        Write-Host "Couldn't find notes file. Trying to create it.";

        if (Test-Path "$env:OneDriveCommercial\Documents\"){
            New-Item -ItemType File -Path "$env:OneDriveCommercial\Documents\note1.txt";
            nvim "$env:OneDriveCommercial\Documents\note1.txt" +$;
        } else {
            Write-Host "Couldn't find OneDrive directory to put the file in. Looking for local notes file @ $env:userprofile\Documents\note1.txt instead.";

            if (!(Test-Path "$env:userprofile\Documents\note1.txt")){
                Write-Host "Couldn't find local notes file. Trying to create it.";
                New-Item -ItemType File -Path "$env:userprofile\Documents\note1.txt";
            }
            nvim "$env:userprofile\Documents\note1.txt" +$;
        }
    }
}