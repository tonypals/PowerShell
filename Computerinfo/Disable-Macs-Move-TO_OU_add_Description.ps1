<#
This script can move enabled or disabled OU to correct OU's
Computer are with name in a file.


#>



$collection = get-content C:\temp\disable-macs.txt
$Date = Get-Date -Format d 

# Description for Disabled Computers:
    $Description = "Not logged on in 60 days, Disabled $date - OPCLIENT-2594  //Tony Pålsson"





foreach ($computer in $collection)
{ 

Write-host $computer -ForegroundColor Green

# Change these for DISABLED!!!!

    # Set Description for DISABLED
        Set-Adcomputer $computer -Description $Description 
    # Move to Disabled-OU
        get-adcomputer $computer | move-adobject -TargetPath "OU=Disabled,OU=CEVT Computers,OU=CEVT,DC=auto,DC=geely,DC=com"
    # Disable computer
        #Disable-ADAccount $computer -WhatIf




# Change these for ENABLED!!!! but moved:

    # Set Description for Enabled but Moved
        #Set-Adcomputer $computer -Description $Description2
    # Move to GOT \ Computers OU
        #get-adcomputer $computer | move-adobject -TargetPath "OU=GOT,OU=Computers,OU=CEVT,DC=auto,DC=geely,DC=com"




# Get Result:


    Get-ADcomputer $computer -Properties * | select dist*,name,enabled,Description,LASTLOGONDATE


}