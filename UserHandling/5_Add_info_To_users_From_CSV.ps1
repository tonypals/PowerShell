Clear-Variable use*,dat*,sam*,old*,ne*
#$ErrorActionPreference = "silentlycontinue"

#cd \temp\scripts
#. .\1_StartUp-Script-CMDlets.ps1

#              CHANGE THE FILE NAME
#get-content C:\temp\set-pobox.csv > C:\temp\Fixed.csv

$Users = Import-Csv -Delimiter ";" -Path C:\temp\anette.csv

foreach ($user in $users) {

    $path = (get-addomain).distinguishedname       
    $Title = $user.Title
    $Company = $user.company
    $Department = $user.Department
    $manager = $User.manager 
    $Pager = $user.pager
    $Description = $user.description 
    $country = $user.Country  
    $UserMail = $user.mail
    $city = $user.city
    $streetaddress = $user.streetaddresh
    $Postalcode = $user.postalcode
    $Phone = $user.officephone
    $Expire = $user.AccountExpirationDate
    $date = get-date -Format d
    $oldinfo=$SAM.info -join "`r`n" 
    $newinfo=$user.Externalmail

    $SAM = $user.Samaccountname

    #$s = Get-ADUser -LDAPFilter "(&(mail=*$mail*))" -Properties *  | select samaccountname 
    # set-aduser $sam -Manager petter.frejinger
   
    #set-aduser $sam -Title $user.Title
  set-aduser $sam -Manager $user.Manager 
   #set-aduser $sam -Department $user.department 
   #set-aduser $sam -Description $user.Description
 #set-aduser $sam -Company CEVT

     #Add info to the Notes in the Phonefield
     #$SAM | Set-ADUSer -Replace @{info="$($oldinfo)`r`n`r`n$($newinfo)"}  

 #Set-ADUser $Sam -AccountExpirationDate $Expire
 #Clear-ADAccountExpiration -Identity $sam

 #Set-ADUser -Identity $sam -CannotChangePassword $false
 #set-aduser $sam -OfficePhone $Phone -MobilePhone $Phone 
 #Clear-ADAccountExpiration -Identity $sam

    # Set the Pager for OTP
    #Set-ADUser $user.Pager -Replace @{Pager=$user.Pager}

   # Add-ADGroupMember -Identity $user.Group -Members $sam


                                            #  *********MOVE A USER TO EMPLOYEE***********

                                           #set-aduser $sam -Company CEVT
                                           #get-aduser $sam | move-adobject -TargetPath "OU=CEVT,OU=CEVT Users,OU=CEVT,$path"
                                           #Set-ADUser $Sam -AccountExpirationDate $null

                                           # ***********************************************

                                          #  *********MOVE A USER TO Consultant***********

                                           #set-aduser $sam -Company $company
                                           #get-aduser $sam | move-adobject -TargetPath "OU=Consultants,OU=CEVT Users,OU=CEVT,$path"
                                           #Set-ADUser $Sam -AccountExpirationDate $expire

                                           #************************************************

get-aduser $sam -Properties * | select samaccountname, manager
#Get-ADPrincipalGroupMembership $sam | select name
#get-aduser $user.manager | select samaccountname
#get-aduser  $sam -Properties * | select samaccountname,Description,department,@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}} ,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}},company,accountexpirationdate
#get-ADPrincipalGroupMembership -Identity $sam  | where {($_.name -like “*dept*”)} | select samaccountname
#export-csv -Path c:\temp\missingphones-export.csv -Delimiter ";" -NoTypeInformation -Append
#Get-ADUser $user.samaccountname -Properties * | select -ExpandProperty info
#get-aduser  $sam -Properties * | select samaccountname,Company, mail, @{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}},@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}},Description, Department,enabled,created # | export-csv -Delimiter ";" -Path c:\temp\empsamfrommail.csv -NoTypeInformation -Append
#get-aduser $sam -Properties * | select samaccountname,extensionattribute1,accountexpirationdate

#get-userinfo $sam


    




 }


 