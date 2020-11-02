$user = Read-host "Type user name"
$Prince = Get-aduser $user | select userp* 
$Prince.UserPrincipalName | Set-Clipboard