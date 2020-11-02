$collection = import-csv -Delimiter ";" C:\temp\svensson\RDUsers.csv
$date = get-date -Format d
$RD = "rd.geely.com"
$Geely = "Geely.auto"
$cevt = "auto.geely.com"

foreach ($item in $collection)
{

Try {
get-aduser $item.samaccountname -Server $RD  -Properties *  | select samaccountname 


}

Catch {

$_ | Out-File C:\temp\svensson\RD-errors.txt -Append

}
Finally{
get-aduser $item.samaccountname -Server $RD  -Properties *  | 
select givenName, sn, samaccountname,Company, Title, mail, officephone ,@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}},City,Description, Department,enabled,created  |
export-csv -Delimiter ";" -Path c:\temp\svensson\$rd-Users_export_$date.CSV -NoTypeInformation -Encoding Unicode -append
}
}
