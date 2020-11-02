# This script shows all Citrix-Applicaton-Groups users from the Geely Sales OU are members of
#Ver 20-04-24Tony Pålsson


# Set Variables
    #region checkfolder
$path = "C:\temp"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
#endregion checkfolder
    $Date = Get-Date -Format "yy-MM-dd_HHmm"
    $Path = "$Path\CitrixGroupsLYNKCo_$date.csv"



Get-ADUser -Filter {enabled -ne $false} -Properties * -SearchBase "OU=Geely Sales Users,OU=CEVT,DC=auto,DC=geely,DC=com"  | 


# All rows below chooses different groups or properties for the user.
Select SamAccountName,
Company,

# Show the group that are named *Papp*
    @{ L="CEVT-Papp"; E={ ($_.memberof | 
    foreach { ($_ | where { $_ -like "CN=CEVT-Papp*" }) }).split(',')[0].TrimStart("CN=CEVT-Papp-") }},
 

# Show if the user is member of "CEVT-VDI-TC-Workplace"
    @{ L="CEVT-VDI-TC-Workplace"; E={ ($_.memberof | 
    foreach { ($_ | where { $_ -like "CN=CEVT-VDI-TC-Workplace*" -and $_ -notlike "CN=CEVT-VDI-TC-Workplace-static*" -and $_ -notlike "CN=CEVT-VDI-TC-Workplace-ExtMEM*" -and $_ -notlike "CN=CEVT-VDI-TC-Workplace-Longrun*" -and $_ -notlike "CN=CEVT-VDI-TC-Workplace-1q*" }) }).split(',')[0].TrimStart("CN=CEVT-VDI-TC-") }},
 

# Show if the user is member of "CEVT-VDI-TC-Workplace-static"
    @{ L="CEVT-VDI-TC-Workplace-static"; E={ ($_.memberof | 
    foreach { ($_ | where { $_ -like "*CN=CEVT-VDI-TC-Workplace-static*" }) }).split(',')[0].TrimStart("CN=CEVT-VDI-TC-Workplace-") }},

                                       # ****** Office *********

# Show if the user is member of "CEVT-VDI-Office-Workplace"
    @{ L="CEVT-VDI-Office-Workplace"; E={ ($_.memberof | 
    foreach { ($_ | where { $_ -like "CN=CEVT-VDI-Office-Workplace*" -and $_ -notlike "CN=CEVT-VDI-Office-Workplace-static*"   }) }).split(',')[0].TrimStart("CN=CEVT-VDI-Office-") }},
 

# Show if the user is member of "CEVT-VDI-Office-Workplace-static"
    @{ L="CEVT-VDI-Office-Workplace-Static"; E={ ($_.memberof | 
    foreach { ($_ | where { $_ -like "*CN= *" }) }).split(',')[0].TrimStart("CN=CEVT-VDI-Office-Workplace-") }} |



Export-CSV -Delimiter ";" -NoTypeInformation -Encoding Unicode -Path $Path

Invoke-Item $Path



