$x = Read-host "Type in firstname or lastname"
$user = "*$x*"
Get-ADUser -Filter{displayName -like $user} -Properties SamAccountName, GivenName, Surname, telephoneNumber, mail,lockedout | select samaccountname, Givenname, Surname, mail,lockedout 
