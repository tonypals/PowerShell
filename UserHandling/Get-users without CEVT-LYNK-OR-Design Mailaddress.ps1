Get-ADUser -SearchBase "OU=CEVT,DC=auto,DC=geely,DC=com" -Filter {EmailAddress -notlike "*cevt*" -and emailaddress -notlike '*lynkco*' -and emailaddress -notlike '*geely*' -and enabled -ne $false} -Properties * | 
Select samaccountname, emailaddress,enabled




