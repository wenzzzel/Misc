$asciiArt = "
          ____________________________________________         
_________|                                       _    |________
\        |   __      _____ _ __  _______________| |   |       /
 \       |   \ \ /\ / / _ \ '_ \|_  /_  /_  / _ \ |   |      / 
  \      |    \ V  V /  __/ | | |/ / / / / /  __/ |   |     /  
  /      |     \_/\_/ \___|_| |_/___/___/___\___|_|   |     \  
 /       |____________________________________________|      \ 
/_____________)                                 (_____________\
                                                                
";

Write-Host $asciiArt -ForegroundColor Green;

& "$PROFILE/../Profile_Scripts/add_to_path.ps1";
& "$PROFILE/../Profile_Scripts/add_choco_packs.ps1";
& "$PROFILE/../Profile_Scripts/add_npm_packs.ps1";
& "$PROFILE/../Profile_Scripts/check_ps_modules.ps1";
& "$PROFILE/../Profile_Scripts/load_ps_secrets.ps1";
& "$PROFILE/../Profile_Scripts/add_aliases.ps1";
& "$PROFILE/../Profile_Scripts/setup_choco_tab_completion.ps1";

Write-Host "Setting user defined variables" -ForegroundColor Blue;
Write-Host ' 🔠 $thisRepoRootDir' -ForegroundColor Green;
$thisRepoRootDir = "$PROFILE/.."
Write-Host ' 🔠 $nvimConfigFile' -ForegroundColor Green;
$nvimConfigFile = "$env:LOCALAPPDATA\nvim\init.vim"
Write-Host ' 🔠 $nvimConfigFolder' -ForegroundColor Green;
$nvimConfigFolder = "$env:LOCALAPPDATA\nvim"
Write-Host ' 🔠 $nvimPluginsFolder' -ForegroundColor Green;
$nvimPluginsFolder = "$env:OneDriveCommercial\Documents\nvim_plugins"
Write-Host ' 🔠 $crap' -ForegroundColor Green;
$crap = "$env:OneDriveCommercial\Documents\Crap"
Write-Host ' 🔠 $repos' -ForegroundColor Green;
$repos = "$env:userprofile\source\repos"
Write-Host ' 🔠 $dotnetSecretStore' -ForegroundColor Green;
$dotnetSecretStore = "$env:APPDATA\Microsoft\UserSecrets\"
Write-Host ' 🔠 $ds' -ForegroundColor Green; #Makes sense to have var for this since almost all repos are prefixed with dataservices
$ds = "dataservices"
Write-Host ' 🔠 $nugetConfigFilePath' -ForegroundColor Green;
$nugetConfigFilePath = "$env:appdata\nuget\nuget.config"

& "$PROFILE/../Profile_Scripts/add_user_defined_functions.ps1";
& "$PROFILE/../Profile_Scripts/check_reminders.ps1";
& "$PROFILE/../Profile_Scripts/setup_choco_tab_completion.ps1";
& "$PROFILE/../Profile_Scripts/activate_posh.ps1";
& "$PROFILE/../Profile_Scripts/activate_ps_intellisense.ps1";

#Setup nvim Plug
#TODO: Check if this already exists beofore downloading it. 
#TODO: Don't have this at the end of the file
# iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
#     ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
