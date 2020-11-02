Clear-Variable da*,cev*,des*,da*



cls
$path = (get-addomain).distinguishedname
$date = get-date -format d

# Checks if file exists, Deletes if exists

$FileName = "C:\Temp\Exports\$date-sortedusers.csv"
if (Test-Path $FileName) {
  Remove-Item $FileName
}


# CEVT Users:
$CEVTEmployees = "OU=CEVT,OU=Cevt users,OU=CEVT,$path"
$Consultants = "OU=Consultants,OU=Cevt users,OU=CEVT,$path"
$consultantsIT = "OU=consultants-it,OU=Cevt users,OU=CEVT,$path"
$suppliers = "OU=Supplier,OU=Cevt users,OU=CEVT,$path"
$VCC= "OU=VCC Employee,OU=Cevt users,OU=CEVT,$path"
$Partner = "OU=Partner,OU=Cevt users,OU=CEVT,$path"

# Geely Design Uses:
$GeelyDesign = "OU=Geely Design Users,OU=CEVT,$path"
$Lax = "OU=Lax,OU=Geely Design Users,OU=CEVT,$path"
$BCN = "OU=BCN,OU=Geely Design Users,OU=CEVT,$path"
$CVT = "OU=CVT,OU=Geely Design Users,OU=CEVT,$path"
$Admin= "OU=Admin-Accounts,OU=CEVT,$path"
$AllCEVT = "OU=CEVT,$path"

# LynkCo Users: 
$LynkCo = "OU=Geely Sales Users,OU=CEVT,$path"

$Admins = "OU=Admin-accounts,OU=CEVT,$path"


# Change here which OU's to search in:

$OU= @($AllCEVT)
#$OU= @($suppliers,$VCC,$Consultants,$Geelydesign,$LynkCo,$partner,$CEVTEmployees)
#$OU= @($suppliers,$VCC,$CEVT,$Consultants)
#$OU= @($vcc,$consultants,$suppliers,$consultantsIT)
#$OU= @($lax,$bcn)
#$OU= @($consultants,$suppliers)
#$OU= @($consultants)
#$OU= @($geelyDesign)
#$OU= @($Geelystaff)
#$OU= @($admins)
#$OU= @($CVT)


$ou |  
<#
ForEach {get-aduser -SearchBase $_ -Filter {enabled -ne $false }  -Properties * | 
select Displayname,samaccountname,created, homedirectory |
export-csv -Delimiter ";" -Path C:\Temp\Exports\$date-sortedusers.csv -NoTypeInformation -Encoding Unicode -Append -Force }

#>



ForEach {get-aduser -SearchBase $_ -Filter {enabled -ne $false }  -Properties * | 
select Displayname,samaccountname,AccountExpirationDate,company,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}},@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}}}  |
export-csv -Delimiter ";" -Path C:\Temp\Exports\$date-sortedusers.csv -NoTypeInformation -Encoding Unicode -Append -Force

#>
<#
ForEach {get-aduser -SearchBase $_ -Filter {enabled -ne $false }  -Properties * | 
select Displayname,samaccountname,mail,Company,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}},@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}},accountexpirationdate},@{n='directReports';e={$_.directreports -join '; '}} |
export-csv -Delimiter ";" -Path c:\temp\$date-All_Users.csv -NoTypeInformation -Encoding Unicode -Append

# All users, Disabled included:

#ForEach {get-aduser -SearchBase $_ -filter * -Properties * | select Displayname,samaccountname,mail,Company,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}},accountexpirationdate,@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}}} |
#export-csv -Delimiter ";" -Path c:\temp\$date-ALL-CEVT-Master.csv -NoTypeInformation -Encoding Unicode -Append

<#

$Design |  
ForEach {get-aduser -SearchBase $_ -Filter * -Properties * | select Name,samaccountname,Mail,mobilephone,title,company,Department,Description,Modified,AccountExpirationDate,passwordneverexpires,Created,passwordlastset,lastlogondate,@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}},enabled,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}}} |
export-csv -Delimiter ";" -Path c:\temp\MASTERCEVT2_$date.csv -NoTypeInformation -Encoding Unicode -append

#>


ii C:\Temp\Exports\$date-sortedusers.csv