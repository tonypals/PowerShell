<#
This script can move enabled or disabled OU to correct OU's
Computer are with name in a file.


#>



$collection = get-content C:\temp\checkcomputerinfo.txt
$Date = Get-Date -Format d 

# Description for Disabled Computers:
    $Description = "Disabled $date - Case: ChangeID-1284 //Tony Pålsson" 



foreach ($computer in $collection)
{ 

#Write-host $computer.'Machine Name' -ForegroundColor Green

# Change these for DISABLED!!!!

    # Set Description for DISABLED
       #Set-Adcomputer $computer -Description $Description 
    # Move to Disabled-OU
        #get-adcomputer $computer | move-adobject -TargetPath "OU=Disabled,OU=CEVT Computers,OU=CEVT,DC=auto,DC=geely,DC=com"
    # Disable computer
        set-adcomputer $computer -Enabled $false 





# Change these for ENABLED!!!! but moved:

    # Set Description for Enabled but Moved
        #Set-Adcomputer $computer -Description $Description
    # Move to GOT \ Computers OU
        #get-adcomputer $computer | move-adobject -TargetPath "OU=GOT,OU=Computers,OU=lynkco,DC=auto,DC=geely,DC=com"




# Get Result:


    Get-ADcomputer $computer -Properties * | sort lastlogondate | select dist*,name,enabled,Description,LASTLOGONDATE | sort lastlogondate

}

