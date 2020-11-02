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

if($member.objectclass -eq 'user'){
                        $user = Get-ADUser $member  -Properties enabled,samaccountname,Description,ObjectClass | Select-Object -Property enabled,samaccountname,description,ObjectClass
                        Write-host "This is a user: "$user.samaccountname -ForegroundColor Green
                        $Record."Group Name" = $Group.Name
                        $Record."Group Description" = $Group.Description
                        $Record."User-Enabled" = $User.enabled
                        $Record."UserName" = $User.samaccountname
                        $Record."UserDescription" = $User.description
                        $Record."ObjectClass" = $User.ObjectClass    
                        
                         $objRecord = New-Object PSObject -property $Record 
                            $Table += $objrecord }                      
                                 }                          
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



                         $Table | export-csv -Path $OutFileName -NoTypeInformation 
 #$Table | Out-GridView
 Write-host "Open $OutFileName"

 ii $OutFileName