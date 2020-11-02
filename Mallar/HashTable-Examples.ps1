# Man kan skriva på en rad

$h = @{bug="insect";roses="red";height="31"}

# Man kan skriva på flera rader 

$h = @{bug="insect";
       roses="red";
       height="31"}
$h

************************

# Detta är ett vanligt kommando:

get-aduser –filter {enabled –eq $false} –searchbase "OU=TPs,DC=bigfirm,dc=com" –properties title,office

# Kan göras så här istället:

$p=@{Filter = "Enabled -eq '$false'"; searchbase="dc=bigfirm,dc=com" ; properties=("Title","Office")}

get-aduser @p

**********************************
# $search='OU=Training,OU=CEVT users,OU=CEVT,DC=auto,DC=geely,DC=com'

$cdsid = Read-host "Type cdisd"

$props=@(
   'Name',
   'sAMAccountName',
   'Description',
   'Enabled',
   'created',
   'modified',
   @{n="MemberOf";e={($_.memberof | %{(Get-ADGroup $_).sAMAccountName}) -join ";"}},
   'LastLogonDate',
   'LockedOut'
)

Get-ADUser $cdsid -Properties *  | select $props  | select samaccountname,memberof | export-Csv "C:\temp\$cdsid.csv" -Delimiter ";" -notypeinfo -encoding Unicode

ii "C:\temp\$cdsid.csv"