Write-Host "Adding to path variable" -ForegroundColor Blue;
$ENV:PATH += ";C:\Program Files\Git\bin";
$ENV:PATH += ";C:\Program Files\nodejs\";
$ENV:PATH += ";C:\Users\ewentzel\AppData\Roaming\npm";
$ENV:PATH += ";C:\Program Files\Neovim\bin";
$ENV:PATH += ";C:\Program Files\azure-documentdb-datamigrationtool-1.8.3";

Write-Host "Stepping into C:\Users\ewentzel\source\repos\" -ForegroundColor Blue;
cd "C:\Users\ewentzel\source\repos";

Write-Host "Creating user defined functions" -ForegroundColor Blue;
Write-Host "    Open-NvimNotes" -ForegroundColor Yellow;
function Open-NvimNotes {
    Write-Host "Opening notes with nvim" -ForegroundColor Blue;
    nvim "C:\Users\ewentzel\Crap\Notes\note1.txt" +$;
}

Write-Host "Setting user defined variables" -ForegroundColor Blue;
$nvimConfigFile = "C:\Users\ewentzel\AppData\Local\nvim\init.vim"
Write-Host '    $nvimConfigFile' -ForegroundColor Yellow;
