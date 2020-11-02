

Get-Aduser -filter {extensionattribute3 -like '201*'} -Properties * | Select samaccountname,mail |
export-csv c:\temp\somelynk.csv -NoTypeInformation -Delimiter ";"

ii c:\temp\somelynk.csv 