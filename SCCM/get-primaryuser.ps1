#Anslut mot SCCM
if ((get-module -Name ConfigurationManager) -eq $null)
{
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" # Import the ConfigurationManager.psd1 module 
Set-Location "LST:" # Set the current location to be the site code.
}
if ((Get-Location) -ne "LST:\"){Set-Location "LST:"}

#Input
$datorer = (Get-ADGroupMember -Identity Lst-Apps-WinCli-Cisco-WebexPlayer-2).name



#Process
$ErrorActionPreference = "silentlycontinue"
$arraydata = @()
foreach ($item in $datorer)
{
    Clear-Variable user, mail, desc, desc2
    $desc = ((Get-ADComputer $item -Properties Description).Description).replace(",","")
    $user = ((Get-CMUserDeviceAffinity -DeviceName $item).uniqueUsername).replace("lansstyrelsen\","")
    if ($user) {$mail = (get-aduser $user).userprincipalname}
    if (!$mail) {
        if ($desc){
            $desc2 = ($desc.Split(" ") | select -First 2)
            $desc2 = $desc2[1] +" " + $desc2[0]
            $mail = (Get-ADUser -Filter {displayname -like $desc2}).userprincipalname
            if (!$mail){
                $desc2 = ($desc.Split(" ") | select -First 2)
                $desc2 = $desc2[0] +" " + $desc2[1]
                $mail = (Get-ADUser -Filter {displayname -like $desc2}).userprincipalname
            }
        }
    }

    $data = @{
        dator = $item
        user = $user
        beskrivning = $desc
        epost = $mail
    }
    $arraydata += New-Object -TypeName psobject -Property $data
    cls
}

#Output on screen.
$arraydata


#Export to file
Set-Location c:
$namn = "users-$(Get-Date -format yyyyMMdd_hhmm).csv"
$arraydata | Export-Csv -Path "C:\Users\DA880823-003\Desktop\$namn" -Encoding UTF8 -NoTypeInformation