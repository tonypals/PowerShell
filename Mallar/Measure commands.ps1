


$mats = Measure-Command {Get-ADuser -filter {enabled -ne $false } -SearchBase "OU=CEVT,$path" -Properties * | select samaccountname,officephone,lastlogondate,extensionattribute1,company,department,displayname,pager,mail,accountexpirationdate,@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}}, @{n='directReports';e={$_.directreports -join '; '}},@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}}}
$mats.TotalSeconds