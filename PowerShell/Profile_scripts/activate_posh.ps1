#Activate posh-git and oh-my-posh
Write-Host "Trying to start posh-git and oh-my-posh" -ForegroundColor Blue;
if((Test-Path "C:\tools\poshgit\dahlbyk-posh-git-9bda399\") -And (Test-Path "C:\Program Files (x86)\oh-my-posh\bin\")){
    Write-Host " ✔️ posh-git and oh-my-posh was found, starting..."   
    Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'
    #oh-my-posh font install agave #Nerd font (only need to run first time)
    oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/marcduiker.omp.json' | Invoke-Expression # --config parameter is for oh-my-posh-theme. Skip it to get default theme
} else {
    Write-Host " ❌ Couldn't start posh-git and oh-my-posh because at least one of them was not found." -ForegroundColor Blue;
}