Clear-Variable use*,dat*,sam*,old*,ne*,ppm*,mai*


$Users = Import-Csv -Delimiter ";" -Path C:\temp\Remove_fromOffice365Licenses.csv


# Set Variables

    $date = get-date -Format d



foreach ($user in $users) {

 #$mail = $user.mail
 #$s = Get-ADUser -LDAPFilter "(&(mail=*$mail*))" -Properties *  | select samaccountname    
 $sam = $user.samaccountname
 $groupOffice = Get-ADPrincipalGroupMembership -Identity $sam  | where {($_.name -like “CEVT-Office365-E3-SE-License”)}  | select name

  Remove-ADGroupMember -Identity CEVT-Office365-E3-SE-License -Members $sam -Confirm:$false
  Remove-ADGroupMember -Identity CEVT-Office365-ems-License -Members $sam -Confirm:$false

# Get result

    Get-aduser $sam -Properties *  | select enabled,samaccountname,memberof
    #Get-ADPrincipalGroupMembership -Identity $sam  | where {($_.name -like "CEVT-Office365-E3-SE-License")}  | select name

 }


 