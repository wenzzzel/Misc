#Activate posh-git and oh-my-posh
Write-Host "Trying to start posh-git and oh-my-posh" -ForegroundColor Blue;
if((Test-Path "C:\tools\poshgit\dahlbyk-posh-git-9bda399\") -And (Test-Path "C:\Program Files (x86)\oh-my-posh\bin\")){
    Write-Host " ✔️ posh-git and oh-my-posh was found, starting..."   
    Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'

    # $neededFonts = @(
    #     "Agave Nerd Font Propo Regular (TrueType)",
    #     "Agave Nerd Font Propo Bold (TrueType)",
    #     "Agave Nerd Font Mono Bold (TrueType)",
    #     "Agave Nerd Font Mono Regular (TrueType)",
    #     "Agave Nerd Font Regular (TrueType)",
    #     "Agave Nerd Font Bold (TrueType)"
    # );
    # $installedFonts = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" | Get-Member -MemberType Properties | Select-Object -ExpandProperty Name;
    # foreach($neededFont in $neededFonts){
    #     if ($installedFonts -notcontains $neededFont){
    #         oh-my-posh font install agave #AgaveNerdFont font (only need to run first time and will install all 6 fonts specified above)
    #         break;
    #     }
    # }

    oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/marcduiker.omp.json' | Invoke-Expression # --config parameter is for oh-my-posh-theme. Skip it to get default theme
} else {
    Write-Host " ❌ Couldn't start posh-git and oh-my-posh because at least one of them was not found." -ForegroundColor Blue;
}