$date = get-date -format d
$path = "c:\temp\exports\Accessgroups_$date.csv"


 get-adgroup  -Filter * -SearchBase  "OU=folder Permissions,OU=CEVT groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties * | 
 select samaccountname,Description,info,managedby,whencreated | Export-Csv -path $path -Delimiter "ö" -NoTypeInformation -Encoding Unicode

 #get-adgroup  -Filter * -SearchBase  "OU=unit-dept groups,OU=GD groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties * | 

 #get-adgroup  -Filter * -SearchBase  "OU=Admin-groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties *  | 

  
 #get-adgroup  -Filter * -SearchBase  "OU=Costcenters;OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties * | 

 #select samaccountname,Description,info,managedby,whencreated | Export-Csv -path $path -Delimiter ";" -NoTypeInformation -Encoding Unicode

 get-adgroup  -Filter * -SearchBase  "OU=GD groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties * |
 select samaccountname,Description,info,managedby,whencreated | Export-Csv -path $path -Delimiter "ö" -NoTypeInformation -Encoding Unicode -Append

 ii $path