$1 = "VCC"

# haveMems contains all groups 'with' members
# haveNotMems contains all groups that didn't match (i.e. - don't have members)

$haveMems, $haveNotMems = $(Get-ADGroup -Filter "name -like '*$1*'" -Properties members).Where({$_.members.Count -gt 0}, 'Split' -and $_.objectClass -eq "user" ) 
$haveMems | foreach { $_.Name ;@{expression =  (ADGroupMember $_.DistinguishedName | Select Name ).Count} }
$haveNotMems | foreach { $_.Name ;@{expression =  (ADGroupMember $_.DistinguishedName | Select Name ).Count} }


$haveMems | foreach { $_.Name ;@{expression =  (ADGroupMember $_.DistinguishedName | Select Name )}}

