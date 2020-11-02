$collection = get-adgroupmember -Identity CEVT-Office365-E3-SE-License | select samaccountname

$date = 


foreach ($item in $collection)
{

$sam = $item.samaccountname

Get-ADUser $sam -Properties * | 
Select Enabled, SamAccountName, UserPrincipalName, @{L="directReportsCount(Total)";E={($_.directReports|Group).Count}}, DisplayName, @{L="Manager";E={(Get-ADUser -Identity $_.Manager).SamAccountName}}, @{L="OU (auto.geely.com\CEVT\)";E={(Split-Path $_.CanonicalName).Replace("auto.geely.com\CEVT\","")}}, @{ L="MemberOfCCDyn"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=CEVT-CCDyn*" }) }).split(',')[0].TrimStart("CN=CEVT-CCDyn-") }}, @{ L="MemberOfCCDynLynkCo"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=LynkCo-CCDyn*" }) }).split(',')[0].TrimStart("CN=LynkCo-CCDyn-") }}, @{ L="E3"; E={ "CN=CEVT-Office365-E3-SE-License,OU=Office 365,OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -eq ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=CEVT-Office365-E3-SE-License,OU=Office 365,OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" }) }) }},extensionAttribute3, LastLogonDate, LockedOut | 
Export-CSV -Delimiter ";" -NoTypeInformation -Encoding Unicode -Path "c:\temp\E3Users-$(Get-Date -Format "yyMMdd(HH.mm)").csv" -Append


    
}

ii c:\temp\E3Users.csv




