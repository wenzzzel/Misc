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
& "$PROFILE/../Profile_Scripts/add_npm_packs.ps1"; #Don't check every time?
& "$PROFILE/../Profile_Scripts/check_ps_modules.ps1"; #Don't check every time?
& "$PROFILE/../Profile_Scripts/load_ps_secrets.ps1";
& "$PROFILE/../Profile_Scripts/add_aliases.ps1";
& "$PROFILE/../Profile_Scripts/setup_choco_tab_completion.ps1";
& "$PROFILE/../Profile_Scripts/add_user_defined_variables.ps1";
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
