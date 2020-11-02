



#Ver 2019-04-25
$Date = Get-Date -Format "yy-MM-dd_HHmm"

$Path = "C:\temp\Adusers_$date.csv"

if (Test-Path $Path) {
  Remove-Item $Path
}
#Get-ADUser -Filter {enabled -ne $false} -Properties * -SearchBase "OU=Geely Sales Users,OU=CEVT,DC=auto,DC=geely,DC=com" |
get-aduser tony.palsson -Properties * |


Select SamAccountName,
#UserPrincipalName,
#@{L="Manager";
#E={(Get-ADUser -Identity $_.Manager).SamAccountName}},
#mail,
Company, 
#@{L="OU (auto.geely.com\CEVT\)";E={(Split-Path $_.CanonicalName).Replace("auto.geely.com\CEVT\","")}}, 
#@{ L="MemberOfCCDyn"; E={ ($_.memberof | 
#foreach { ($_ | where { $_ -like "CEVT-CCDyn*" }) }).split(',')[0].TrimStart("CN=CEVT-CCDyn-") }}

@{ L="MemberOfCEVTPapp"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CEVT-Papp*" }) }).split(',')[0].TrimStart("CN=CEVT-Papp-") }}, 

@{ L="MemberOfTC-Workplace"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=CEVT-VDI-TC-Workplace*" }) }).split(',')[0].TrimStart("CN=CEVT-VDI-TC-Workplace-") }}, 

@{ L="MemberOfTC-WorkplaceStatic"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=CEVT-VDI-TC-Workplace-static*" }) }).split(',')[0].TrimStart("CN=CEVT--VDI-TC-Workplace-static-") }}, 

@{ L="MemberOfCCDynLynkCo"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=LynkCo-CCDyn*" }) }).split(',')[0].TrimStart("CN=LynkCo-CCDyn-") }} 






#Export-CSV -Delimiter ";" -NoTypeInformation -Encoding Unicode -Path "c:\temp\ADUsers_$Date.csv"

#ii c:\temp\ADUsers_$Date.csv









