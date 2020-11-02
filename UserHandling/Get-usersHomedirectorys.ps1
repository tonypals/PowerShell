$Path = (get-addomain).distinguishedname
$x = Read-host "Type part of Servername Ex 1105"
$NR = "*$x*"


        Get-aduser -SearchBase "ou=userids,$path" -filter {homedirectory -like $nr} -Properties homedirectory | select samaccountname,homedirectory | sort homedirectory


