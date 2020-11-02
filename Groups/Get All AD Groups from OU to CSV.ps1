$date = get-date -format d
 get-adgroup  -Filter * -SearchBase  "OU=unit-dept groups,OU=CEVT groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties * | 

 #get-adgroup  -Filter * -SearchBase  "OU=unit-dept groups,OU=GD groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties * | 

 #get-adgroup  -Filter * -SearchBase  "OU=Admin-groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties *  | 

 select samaccountname,Description,info,managedby,whencreated | Export-Csv -path c:\temp\All-CEVT-Unit_Groups2_$date.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode

 ii c:\temp\All-CEVT-Unit_Groups2_$date.csv