<#
 Ett verktyg för att söka en speciell Guid bland Gpo.er lokalt

 Resultat:
 DisplayName                                   Id                                  
 -----------                                   --                                  
 C-Sec-Lst-ServerRestrictedGroups-VANDB001-Inc b7d2d9bd-cbeb-4c60-8fc7-33c6236e47c9
#>


# Import the Activedirectoryh 
if((Get-Module activedirectory) -eq $null) {
    Import-Module activedirectory
}
if((Get-Module GroupPolicy) -eq $null) {
    Import-Module GroupPolicy
}


$x = Read-host "Fyll i första tecknen från Guiden, tex ffdb"
$Guid = "$x*"
$Guidname = Get-Gpo -all | ? {$_.id -like $guid}

$Guidname | select Displayname, id | sort id