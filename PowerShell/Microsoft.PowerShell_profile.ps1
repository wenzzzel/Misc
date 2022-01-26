Write-Host "Adding to path variable" -ForegroundColor Green;
$ENV:PATH += ";C:\Program Files\Git\bin";
$ENV:PATH += ";C:\Program Files\nodejs\";
$ENV:PATH += ";C:\Users\ewentzel\AppData\Roaming\npm";
$ENV:PATH += ";C:\Program Files\Neovim\bin";

Write-Host "Stepping into C:\Users\ewentzel\source\repos\" -ForegroundColor Green;
cd "C:\Users\ewentzel\source\repos";

Write-Host "Creating user defined functions" -ForegroundColor Green;
Write-Host "    Open-NvimNotes" -ForegroundColor Blue;
function Open-NvimNotes {
    Write-Host "Opening notes with nvim" -ForegroundColor Green;
    nvim "C:\Users\ewentzel\Crap\Notes\note1.txt";
}