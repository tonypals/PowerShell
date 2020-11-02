
$collection = Get-ADGroupMember -Identity "CEVT-Unit-pmo" -Recursive |select samaccountname

foreach ($item in $collection)
{
    get-aduser $item.samaccountname -Properties * | select name,@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}},department, samaccountname |
     export-csv c:\temp\unitPMO.csv -NoTypeInformation -Delimiter ";" -Append -Encoding Unicode
} 