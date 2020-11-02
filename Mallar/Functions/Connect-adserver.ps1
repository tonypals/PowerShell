# Start RDP To AD-server

function connect-adserver
{
[cmdletbinding()]

param (
    #[string[]]$computername
    )
    
    # Start RDP To Ad-server
    Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "/v:gotclw1003.got.volvocars.net:9506" 


    }



