# This Script Shows that Get-Adgroup takes all subtrees


$date = get-date -Format hhmmss
$AdmingroupsNOsubtree = "h:\exports\admingroups-NOsubtree_$date.csv"


$AdminOUWithSubtree = "h:\exports\adminOU-Withsubtree_$date.csv"
$AdminOUNOSubtree = "h:\exports\adminOU-NOsubtree_$date.csv"

$AdminOUGroups = Get-ADGroup -Properties * -Filter * -SearchBase "OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -SearchScope Subtree
$AdminNamedGroups = Get-ADGroup -Filter {name -like "*Admin*"} -Properties * -SearchScope Subtree


$AdminOUGroupsCount = $AdminOUGroups.count
$AdminNamedGroupsCount=$AdminNamedGroups.count

Write-Host "This many in AdminOUGroups: $AdminOUGroupsCount" -ForegroundColor Green

write-host "This many in Named-AdminGroups: $AdminNamedGroupsCount" -ForegroundColor Green


 $AllAdminGroups = $AdminOUGroups+$AdminNamedGroups
 $AllAdminGroupCount = $AllAdminGroups.count

 Write-host "This many in All Admin Groups:$AllAdminGroupCount" -ForegroundColor Green


 Get-ADGroup -Properties name,Description,DistinguishedName,GroupCategory,GroupScope,ManagedBy,ProtectedFromAccidentalDeletion,samaccountname -Filter * -SearchBase "OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" | 
        select name,Description,DistinguishedName,GroupCategory,GroupScope,ManagedBy,ProtectedFromAccidentalDeletion,samaccountname | 
            Export-Csv -Path $AdminOUNOSubtree -Delimiter ";" -NoTypeInformation

 Get-ADGroup -Properties name,Description,DistinguishedName,GroupCategory,GroupScope,ManagedBy,ProtectedFromAccidentalDeletion,samaccountname -Filter * -SearchBase "OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -SearchScope Subtree | 
        Select name,Description,DistinguishedName,GroupCategory,GroupScope,ManagedBy,ProtectedFromAccidentalDeletion,samaccountname |
            Export-Csv -Path $AdminOUWithSubtree -Delimiter ";" -NoTypeInformation


 Get-ADGroup -Filter {name -like "*Admin*"} -Properties name,Description,DistinguishedName,GroupCategory,GroupScope,ManagedBy,ProtectedFromAccidentalDeletion,samaccountname | 
 Select name,Description,DistinguishedName,GroupCategory,GroupScope,ManagedBy,ProtectedFromAccidentalDeletion,samaccountname |
 export-csv -Path $AdmingroupsNOsubtree -Delimiter ";" -NoTypeInformation


 ii $AdmingroupsNOsubtree
 ii $AdminOUNOSubtree