$Groupname = read-host "Fill in groupname"

$collection = Get-ADGroupMember $Groupname | select samaccountname
foreach ($item in $collection)
{
$name = $item.samaccountname

get-aduser $name -Properties * | 
select Name, samaccountname,Mail,company,Department,Description,AccountExpirationDate,passwordneverexpires,Created,passwordlastset,lastlogondate,@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}},enabled,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}} |
export-csv -path c:\temp\$groupname.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode -Append -Force
    
}
