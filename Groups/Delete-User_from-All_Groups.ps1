$tony = "tony.test"

$ADgroups = Get-ADPrincipalGroupMembership -Identity $user | where {$_.Name -ne "Domain Users"}
Remove-ADPrincipalGroupMembership -Identity $tony -MemberOf $ADgroups -Confirm:$true

Get-aduser $tony -Properties | select samaccountname
Get-ADPrincipalGroupMembership -Identity $user | select name