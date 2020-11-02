Remove-Variable collection*,item*,sam*
$collection = Get-ADGroup -Filter {name -like "*CEVT-Office365-ProjectOnline*"} -Properties * | select name

foreach ($item in $collection)
{$sam = $item.name

$collection2 = get-adgroupmember $sam -Recursive

foreach ($item2 in $collection2)
{
#$item2 | select samaccountname
$group = Get-ADPrincipalGroupMembership -Identity $item2  | where {($_.name -like “*CEVT-Office365-Project*”)} | select samaccountname
#$group.Count
if ($group.Count -ne "2") {$item2.SamAccountName; Get-ADPrincipalGroupMembership -Identity $item2  | where {($_.name -like “*CEVT-Office365-Project*”)} | select samaccountname | export-csv -Path c:\temp\Offic365ExportWrongusers.csv -Delimiter ";" -NoTypeInformation -Append}







}
}
