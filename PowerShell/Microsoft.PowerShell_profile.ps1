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