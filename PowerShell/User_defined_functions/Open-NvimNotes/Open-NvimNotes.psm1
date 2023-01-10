function Open-NvimNotes {
    Write-Host "Opening notes with nvim" -ForegroundColor Blue;
    nvim "$env:OneDriveCommercial\Documents\note1.txt" +$;
}