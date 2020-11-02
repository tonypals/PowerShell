$user = "tony.palsson"

# Välja OUn. här


$props=@(
@{Name='Samaccountname';Expression={(Get-ADUser $user).Samaccountname}},

@{Name='EX Partner';Expression={(Get-ADUser $user -Properties extensionAttribute1).extensionAttribute1}},
@{Name='CostCenter';Expression={(Get-ADUser $user -Properties extensionAttribute3).extensionAttribute3}},
@{Name='Orphan CostCenter';Expression={(Get-ADUser $user -Properties extensionAttribute13).extensionAttribute13}},
@{Name="OU (auto.geely.com\CEVT\)";E={(Split-Path $_.CanonicalName).Replace("auto.geely.com\CEVT\","")}},

@{Name="MemberOfCCDyn"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=CEVT-CCDyn*" }) }).split(',')[0].TrimStart("CN=CEVT-CCDyn-") }},

@{Name="MemberOfCCDynLynkCo"; E={ ($_.memberof | 
foreach { ($_ | where { $_ -like "CN=LynkCo-CCDyn*" }) }).split(',')[0].TrimStart("CN=LynkCo-CCDyn-") }},

@{name="Mail";expression={(get-aduser $user -Properties Mail).mail}},
@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}},
@{Name='Created';Expression={(Get-ADUser $user -Properties created).created}}

)

Get-ADUser $user -Properties *  | 

select $props |  # All Properties in $Props are selected



export-Csv "C:\temp\new.csv" -notypeinfo -encoding "UTF8" -Delimiter ";"

Invoke-Item C:\temp\new.csv






(get-aduser $user -Properties Department).department