#$Groups = Get-ADGroup -Properties * -Filter * -SearchBase "CN=CEVT-Intune-serviceadmins,OU=CloudSecurityGroups,OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" 
$Groups = Get-ADGroup -Properties * -Filter * -SearchBase "OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com"

 

$date = get-date -Format hhmmss
$OutFileName = "h:\exports\NamedAdmins_AdminsFromOU_$date.csv"


$Table = @()
$Arrayofmembers =@()
$Record = [ordered]@{}

 
 foreach($group in $groups) {
         foreach($member in $group.members) {
            $member = Get-ADObject $member




if($member.ObjectClass -eq 'group') {
                            $record."Group Name" = $member.name
                            Write-Host "This is a Group:" $member.name-ForegroundColor Green
                            $record."MemberOf" = "$($Member.name) is a member of group $($Group.name)x"
                            $record."Group description" = $group.Description
                            $record."Username" =  $group.DisplayName
                            }
                              $objRecord = New-Object PSObject -property $Record 
                              $Table += $objrecord  
                            }                             
                        
 
                            }
            
        
    
 

 $Table | export-csv -Path $OutFileName -NoTypeInformation 
 #$Table | Out-GridView
 Write-host "Open $OutFileName"

 ii $OutFileName