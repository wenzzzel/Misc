function Open-NvimNotes {
    Write-Host "Opening notes with nvim" -ForegroundColor Blue;
    nvim "C:\Users\ewentzel\Crap\Notes\note1.txt" +$;
}