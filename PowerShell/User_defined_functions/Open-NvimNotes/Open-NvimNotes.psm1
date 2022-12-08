function Open-NvimNotes {
    Write-Host "Opening notes with nvim" -ForegroundColor Blue;
    nvim "C:\Users\wenzz\OneDrive - Volvo Cars\Documents\note1.txt" +$;
}