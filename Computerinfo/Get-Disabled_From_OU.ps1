﻿Clear-Variable da*,cev*,des*,da*



Clear-Host
$path = $null
$path = (get-addomain).distinguishedname
$Filename = "h:\Exports\DisabledComputers-$(get-date -format d).csv"

# Checks if file exists, Deletes if exists

if (Test-Path $FileName) {
  Remove-Item $FileName
}


# Computers:
$CVT = "OU=CVT,OU=Computers,OU=CEVT,$path"
$BCN = "OU=BCN,OU=Computers,OU=CEVT,$path"
$GOT = "OU=GOT,OU=Computers,OU=CEVT,$path"
$Lax = "OU=LAX,OU=Computers,OU=CEVT,$path"
$DisableOU = "OU=Disabled,OU=Cevt computers,OU=CEVT,$path"
$LYNKCO = "OU=LynkCO,$path"



# Change here which OU's to search in:


$OU= @($cvt,$bcn,$got,$lax,$LYNKCO,$DisableOU)
#$OU= @($cvt,$bcn,$got,$lax)
#$OU= @($lynkco)
#$OU= @($DisableOU)

$ou |  

# Unnabled Computers
    ForEach { Get-ADComputer -Filter {(Enabled -eq $False)} -SearchBase $_ -Properties * | 
              select name,description,enabled,whencreated,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}} | sort name |
              export-csv -Path $Filename -Delimiter ";" -NoTypeInformation -Encoding Unicode -Append

            }
<#
# UNEnabled Computers
    ForEach { Get-ADComputer -Filter {(Enabled -eq $True)} -SearchBase $domain -Properties * | 
              select name,description,enabled,whencreated,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}} | sort name |
              export-csv -Path $Filename -Delimiter ";" -NoTypeInformation -Encoding Unicode -Append

            }
#>

            
   cls
   dir $Filename
    Write-host " Då var det klart!" -ForegroundColor Green