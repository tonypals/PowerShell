 Get-ADuser -Filter {givenname -like 'tc*'} -Properties * | %{
$user = $_
$user | Get-ADPrincipalGroupMembership |
Select-Object @{N="User";E={$user.sAMAccountName}},@{N="Group";E={$_.Name}}
} | Select-Object User,Group | Export-Csv C:\temp\report.csv -Delimiter ";" -NoTypeInformation

ii c:\temp\report.csv