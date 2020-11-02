#$Groups = Get-ADGroup -Properties * -Filter * -SearchBase "OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" 
#$Groups = Get-ADGroup -Properties * -identity "CEVT-SRV-SEGOT-S238-RemoteDesktopUser"
#$Groups = Get-ADGroup -Properties * -Filter * -SearchBase "OU=CloudSecurityGroups,OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" 
#$Groups = Get-ADGroup -Filter {name -like "*Soc*"} -Properties * 
#$Groups = Get-ADGroup -Filter {name -like "*Admin*"} -Properties * 
$Groups = Get-ADGroup -Filter {name -like "*service*"} -Properties * 
 

$date = get-date -Format hhmmss
$OutFileName = "h:\exports\NamedAdmins_AdminsFromOU_$date.csv"
#$servers = "H:\exports\servers_$date.csv" 

$Table = @()
$Arrayofmembers =@()
$Record = [ordered]@{
                    }
                                                                            <#
                                                                            # BARA Soc-medlemmar funkar
                                                                            # $Groups = Get-ADGroup -Properties * -Filter * -SearchBase "OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" 
                                                                            Kör jag denna blir det fel i tex CEVT-Servicedesk. Alla medlemmar kommer inte med.

                                                                            Testar:
                                                                            $Groups = Get-ADGroup -Filter {name -like "*service*"} -Properties * 
                                                                            Då kommer CEVT-DEPT-ServiceDesk-Employees med som en user fastän CEVT-Servicdesk ligger I den gruppen.



                                                                            #>

 
 foreach($group in $groups) {
         foreach($member in $group.members) {
            $member = Get-ADObject $member

            if($member.objectclass -eq 'dog'){
                $user = Get-ADUser -Properties enabled,samaccountname $member | Select-Object -Property enabled,samaccountname
                  Write-host "This is a user: "$user.samaccountname -ForegroundColor Green

                $Record."Group Name" = $Group.Name
                $Record."Group Description" = $Group.Description
                $Record."Enabled" = $User.enabled
                $Record."UserName" = $User.samaccountname
                $objRecord = New-Object PSObject -property $Record 
                $Table += $objrecord  
                }

                if($member.ObjectClass -eq 'group') {
                    $record."Group Name" = $member.name
                    Write-Host "This is a Group:" $member.name-ForegroundColor Green

                    $record."MemberOf" = "$($Member.name) is a member of group $($Group.name)x"
                    $record."Group description" = $group.Description
                    $record."Username" =  $group.DisplayName
                    $objRecord = New-Object PSObject -property $Record 
                    $Table += $objrecord  
                }

                  if($member.ObjectClass -eq 'Computer') {
                    $record."Group Name" = $member.name
                       Write-Host "This is a Computer:" $member.name -ForegroundColor Green
                    $record."MemberOf" = "$($Member.name) is a member of group $($Group.name)x"
                    $record."Group description" = $group.Description
                    $record."Username" =  $group.DisplayName
                    $objRecord = New-Object PSObject -property $Record 
                    $Table += $objrecord  
                }
            
        
    }
 }


 $Table | export-csv -Path $OutFileName -NoTypeInformation 
 #$Table | Out-GridView
 Write-host "Open $OutFileName"

 ii $OutFileName