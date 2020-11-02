# This this script gives information about all users that are in the Group for E3-licenses
# The users are Enabled in AD
# Tony Pålsson 2020-04-24

$users = get-adgroupmember CEVT-Office365-E3-SE-License 

$Date = Get-Date -Format "yy-MM-dd_HHmm"


#region checkfolder
$path = "C:\temp"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
#endregion checkfolder

$Path = "$path\E3users_$date.csv"

foreach ($user in $users){

Get-aduser $user.samaccountname -Properties * | ?{$_.Enabled -eq $True} | 

Select SamAccountName,
UserPrincipalName, 
Enabled,
DisplayName, 
@{L="Manager";E={(Get-ADUser -Identity $_.Manager).SamAccountName}},
Company, 
@{ L="E3"; E={ "CN=CEVT-Office365-E3-SE-License,OU=Office 365,OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -eq ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=CEVT-Office365-E3-SE-License,OU=Office 365,OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" }) }) }}, 
EmployeeID, 
extensionAttribute1, # Ex CEVT.partner
extensionAttribute3, # Costcenter
extensionAttribute13 |   # Orphan Costcenter

Export-CSV -Delimiter ";" -NoTypeInformation -Encoding Unicode -Path $Path -Append }

Invoke-Item $Path