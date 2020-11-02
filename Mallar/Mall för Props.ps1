$search='OU=Training,OU=CEVT users,OU=CEVT,DC=auto,DC=geely,DC=com'

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

Get-ADUser -filter * -Properties * -SearchBase $search | 

select $props |  # All Properties in $Props are selected

select samaccountname,enabled |  # Only Samaccountname and enabled is selected here

export-Csv "C:\temp\new.csv" -notypeinfo -encoding "UTF8" -Delimiter ";"

Invoke-Item C:\temp\new.csv