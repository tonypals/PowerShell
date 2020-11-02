Clear-Variable da*,cev*,des*,da*


cls
$path = (get-addomain).distinguishedname
$date = get-date -format d
$FilePath = "c:\temp\AllUsers-$(Get-Date -Format "yyMMdd(HH.mm)").csv"
$CEVT = "OU=CEVT,OU=Cevt users,OU=CEVT,$path"
$Consultants = "OU=Consultants,OU=Cevt users,OU=CEVT,$path"
$consultantsIT = "OU=consultants-it,OU=Cevt users,OU=CEVT,$path"
$suppliers = "OU=Supplier,OU=Cevt users,OU=CEVT,$path"
$GeelyDesign = "OU=Geely Design Users,OU=CEVT,$path"
$Lax = "OU=Lax,OU=Geely Design Users,OU=CEVT,$path"
$BCN = "OU=BCN,OU=Geely Design Users,OU=CEVT,$path"
$Admin= "OU=Admin-Accounts,OU=CEVT,$path"
$AllCEVT = "OU=CEVT,$path"
$GeelyStaff ="OU=GeelyStaff,$path"
$LynkCO = "OU=Geely Sales Users,OU=CEVT,$path"
$Partner = "OU=Partner,OU=Cevt users,OU=CEVT,$path"
$Admins = "OU=Admin-accounts,OU=CEVT,$path"



# Change here which OU's to search in:

#$OU= @($AllCEVT)
#$OU= @($suppliers,$CEVT,$Consultants,$Geelydesign,$consultantsIT,$Lynkco,$partner)
$OU= @($CEVT,$Consultants,$partner)
#$OU= @($suppliers,$VCC,$CEVT,$Consultants)
#$OU= @($vcc,$consultants,$suppliers,$consultantsIT)
#$OU= @($lax,$bcn)
#$OU= @($consultants,$suppliers)
#$OU= @($consultants)
#$OU= @($geelyDesign)
#$OU= @($Geelystaff)


$ou |  
<#
ForEach {get-aduser -SearchBase $_ -Filter {enabled -ne $false }  -Properties *  | 
Select SamAccountName, UserPrincipalName, @{L="directReportsCount(Total)";E={($_.directReports|Group).Count}}, DisplayName, @{L="Manager";E={(Get-ADUser -Identity $_.Manager).SamAccountName}},mail,Company, @{L="OU (auto.geely.com\CEVT\)";E={(Split-Path $_.CanonicalName).Replace("auto.geely.com\CEVT\","")}}, @{ L="MemberOfCCDyn"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=CEVT-CCDyn*" }) }).split(',')[0].TrimStart("CN=CEVT-CCDyn-") }}, @{ L="MemberOfCCDynLynkCo"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=LynkCo-CCDyn*" }) }).split(',')[0].TrimStart("CN=LynkCo-CCDyn-") }}, @{ L="E3"; E={ "CN=CEVT-Office365-E3-SE-License,OU=Office 365,OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -eq ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=CEVT-Office365-E3-SE-License,OU=Office 365,OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" }) }) }}, EmployeeID, extensionAttribute1, extensionAttribute2, extensionAttribute3, extensionAttribute4, extensionAttribute13, Created, LastLogonDate, @{Name="PasswordExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}, Passwordexpired, @{Name="badPasswordTime";Expression={[datetime]::FromFileTime($_."badPasswordTime")}}} | 
Export-CSV  -Delimiter ";" -NoTypeInformation -Encoding Unicode -Path  $filepath
#>



ForEach {get-aduser -SearchBase $_ -Filter {enabled -ne $false }  -Properties *  | 
Select Firstname,Surname,MobilePhone,Department,Title,extensionAttribute1, extensionAttribute3,@{L="Manager";E={(Get-ADUser -Identity $_.Manager).SamAccountName}},mail,Company} |



Export-CSV  -Delimiter ";" -NoTypeInformation -Encoding Unicode -Path  $filepath

ii $filepath