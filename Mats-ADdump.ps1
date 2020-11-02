



#Ver 2019-04-25
$Date = Get-Date -Format "yy-MM-dd_HHmm"
$Path = "C:\temp\Adusers_$date.csv"
Get-ADUser -Filter {enabled -ne $false} -Properties * -SearchBase "OU=CEVT,DC=auto,DC=geely,DC=com" |

 #Get-ADuser -Filter {givenname -like 'tc*'} -Properties * |

#Get-ADUser -Filter * -Properties samaccountname, Enabled -SearchBase "OU=CEVT,DC=auto,DC=geely,DC=com" | 

Select SamAccountName,
UserPrincipalName, 
#@{L="directReportsCount(Total)";
#E={($_.directReports|Group).Count}}, 
DisplayName, 
@{L="Manager";
E={(Get-ADUser -Identity $_.Manager).SamAccountName}},
#mail,
Company, 
@{L="OU (auto.geely.com\CEVT\)";E={(Split-Path $_.CanonicalName).Replace("auto.geely.com\CEVT\","")}}, 
@{ L="MemberOfCCDyn"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=CEVT-CCDyn*" }) }).split(',')[0].TrimStart("CN=CEVT-CCDyn-") }}, 
@{ L="MemberOfCCDynLynkCo"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=LynkCo-CCDyn*" }) }).split(',')[0].TrimStart("CN=LynkCo-CCDyn-") }}, 
@{ L="E3"; E={ "CN=CEVT-Office365-E3-SE-License,OU=Office 365,OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -eq ($_.memberof | foreach { ($_ | where { $_ -like "CN=CEVT-Office365-E3-SE-License,OU=Office 365,OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" }) }) }}, 
EmployeeID, 
extensionAttribute1, # Ex CEVT.partner
#extensionAttribute2, 
extensionAttribute3, # Costcenter
extensionAttribute4, # Ex CPU, Successfactor
extensionAttribute13 |   # Orphan Costcenter
#Created, 
#LastLogonDate, 
#@{Name="PasswordExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}, 
#Passwordexpired, @{Name="badPasswordTime";Expression={[datetime]::FromFileTime($_."badPasswordTime")}} | 

#Export-CSV -Delimiter ";" -NoTypeInformation -Encoding Unicode -Path "c:\temp\ADv4(CEVT-OU-All-InkDisabeld-Users)-$(Get-Date -Format "yyMMdd(HH.mm)").csv"

Export-CSV -Delimiter ";" -NoTypeInformation -Encoding Unicode -Path $Path -Append

ii $Path









