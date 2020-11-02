Get-ADuser -Filter {givenname -like 'mr' -or surname -like 'mr'} -property mail,manager | select samaccountname,mail,manager
