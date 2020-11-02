# This script shows the users groups, Mail-address and lastlogondate from a CSV with a samccountname-column.
# The Path to the CSV must be filled

$ErrorActionPreference = "continue"

#region checkfolder
        $path = "C:\temp"
        If(!(test-path $path))
{
        New-Item -ItemType Directory -Force -Path $path
}
#endregion checkfolder

# Import the Filename here:
$collection = import-csv C:\temp\*****.csv -Delimiter ";" 


$Date = Get-Date -Format "yy-MM-dd_HHmm"
cls

$ExportPath = c:\temp\export_$date.csv

foreach ($item in $collection)
{ $sam = $item.samaccountname
get-aduser $sam -Properties * | 
select samaccountname,mail,Company,accountexpirationdate,enabled,lastlogondate,department,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]} },@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}} |
export-csv $ExportPath -Delimiter ";" -NoTypeInformation -Append

}

 
