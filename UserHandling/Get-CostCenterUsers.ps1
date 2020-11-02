



#Ver 2019-04-25
Get-ADUser -Filter * -Properties * -SearchBase "OU=CEVT,DC=auto,DC=geely,DC=com" | select samaccountname, extensionattribute1,extensionattribute3 |
export-csv c:\temp\costtillper.csv -NoTypeInformation -Delimiter ";" -Append

ii c:\temp\costtillper.csv 








