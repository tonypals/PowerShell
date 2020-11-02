Remove-Variable us*,log*,sam* #in*,Prop*,acc*,ac*,righ*,ob
#Del c:\temp\fixed.csv -force


#Set-ExecutionPolicy Unrestricted -Force
 
#              CHANGE THE FILE NAME
get-content C:\temp\CreateUsers2015-12-16.csv > C:\temp\Fixed.csv

$Users = Import-Csv -Delimiter ";" -Path C:\temp\Fixed.csv

foreach ($User in $Users)  
{  
    $OU = "OU=Imported,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com".trim()    
    $UserFirstname = $User.Firstname.trim()
    $userlastname = $user.lastname.trim()   
    $Sam = $user.samaccountname.trim()    # Can not be more than 20 characters long.  Ex:  kristoffer.fredrikss
    $Description = $user.Description.trim()
    $Officephone = $user.Mobilephone.trim()
    $Department = $user.department
    $Mail = $user.mail.trim()
    $company = $user.company.trim()
    #$Detailedname = $UserFirstname.trim() + " " + $userlastname.trim()
    $Detailedname = $User.Detailedname
    $userprinicpalname = $Sam.trim() + "@auto.geely.com" 
    $Title = $user.Title.trim()
    $Company = $user.company.trim()
    $Department = $user.Department.trim()
    $manager = $User.manager.trim()
    #$Pager = $user.pager.trim()
    $Description = $user.description.trim()         
    $Phone = $user.mobilephone.trim()
    $Password = $User.password.trim()
    $Expire = $user.AccountExpirationDate.trim() 
    #$Country = $user.Country.trim()  
    #$Group1 = $user.Group1.trim()
    #$Group2 = $user.Group2.trim()
    #$Group3 = $user.Group3.trim()
    #$Group4 = $user.Group4.trim()
    #$Group5 = $user.Group5.trim()
    #$Group6 = $user.Group6.trim()
    #$Group7 = $user.Group7.trim()
  
         
   
 New-ADUser -Name $Detailedname -SamAccountName $SAM -UserPrincipalName $userprinicpalname -DisplayName $Detailedname -GivenName $user.firstname -Surname $user.lastname -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $false -Path $OU 
 
 
 
 <#
  Add-ADGroupMember -Identity $Group1 $SAM
  Add-ADGroupMember -Identity $Group2 $SAM
  Add-ADGroupMember -Identity $Group3 $SAM
  Add-ADGroupMember -Identity $Group4 $SAM
  Add-ADGroupMember -Identity $Group5 $SAM
  #Add-ADGroupMember -Identity $Group6 $SAM 
  #Add-ADGroupMember -Identity $Group7 $SAM  

    set-aduser $sam -OfficePhone $Phone -MobilePhone $phone   
    set-aduser $sam -Description $Description -Department $Department 
    Set-aduser $sam -Title $Title
    set-aduser $sam -Company $Company  
    set-aduser $sam -Manager $manager
    Set-ADUser $Sam -AccountExpirationDate $Expire
    #Set-ADUser $user.Pager -Replace @{Pager=$user.Pager}
    Set-aduser $sam -EmailAddress $UserMail  
    #Set-Aduser $sam -Country $Country
    #>
   
set-aduser $sam -Description $Description -Department $Department
 Set-aduser $sam -Title $Title
    set-aduser $sam -Company $Company  
    set-aduser $sam -Manager $manager
    Set-ADUser $Sam -AccountExpirationDate $Expire
    Set-aduser $sam -EmailAddress $Mail 
     
 Get-aduser $sam -Properties * | select DisplayName,Samaccountname,Homedirectory,Company,Mobilephone,Pager, Title,created,@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}},@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}},mail,Description,Department,AccountExpirationDate,enabled
 
 }
 <#
 Write-host ******************************
write-host -ForegroundColor Green "The CostCenter for $SAM"
$group = Get-ADPrincipalGroupMembership -Identity $SAM  | where {($_.name -like “cevt-dept*”)} 


Get-ADgroup $group -Properties * | select Description

Write-Host -ForegroundColor Green "All groups $SAM is member of"

Get-ADPrincipalGroupMembership -Identity $SAM | 
select Name 

} 
Write-host "Create all Homefolders in AD. \\segot-s040\home$\users\%username%"  -ForegroundColor Yellow
Write-Host "Press Any key to continue"
read-host



#>









