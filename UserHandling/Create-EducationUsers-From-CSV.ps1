
$Users = Import-Csv -Delimiter ";" -Path C:\temp\CreateEducationAccounts.csv          
foreach ($User in $Users)            
{            
    $Displayname = $User.Displayname         
    $UserFirstname = $User.Firstname                      
    $OU = $user.ou       
    $SAM = $User.Samaccountname            
    $UPN = $User.Firstname + "@" + $User.Maildomain            
    $Description = $User.Description            
    $Password = $User.Password  
    $Email = $user.Mail          
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -CannotChangePassword $True -EmailAddress $Email -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$UserFirstname" -Surname "$UserLastname" -Description "$Description" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $false -Path "$OU" -ChangePasswordAtLogon $false –PasswordNeverExpires $true           

$group1 = "G-CEVT-WiFi-Office-Users"
$Group2 = "G-CEVT-TCTraining"
$Group3 = "CEVT-Office365-OfficeProPlus-License"
$Group4 = "CEVT-Apps-Hotfix 34 for CATIA V5R26 SP4-User"
$Group5 = "CEVT-Apps-TCIC11.0.6.2_R26-User_PreProd"

$Groups
  Add-ADGroupMember -Identity $Group1 $SAM
  Add-ADGroupMember -Identity $Group2 $SAM
  Add-ADGroupMember -Identity $Group3 $SAM
  Add-ADGroupMember -Identity $Group4 $SAM
  Add-ADGroupMember -Identity $Group5 $SAM

}

Get-aduser $SAM -Properties Mail,description,cannotchangepassword | 
Select Samaccountname,Mail,description,cannotchangepassword,Givenname,dist*,Name,Userprinc*,enabled
Get-ADPrincipalGroupMembership $sam | select name
