$a =Get-ADUser -Filter {enabled -ne $false} -Properties * -SearchBase "OU=Geely Sales Users,OU=CEVT,DC=auto,DC=geely,DC=com" | Select-Object -first 3




$c = ForEach ($b in $a.samaccountname) {
     [PSCustomObject]@{
        Aaa = $b
        Owner = @{ L="MemberOfCEVTPapp"; E={ ($_.memberof | 
               foreach { ($b.memberof | where { $b.memberof -like "CN=CEVT-Papp*" }) }).split(',')[0].TrimStart("CN=CEVT-Papp-") }}
       # Group = (Get-ADPrincipalGroupMembership $b).samaccountname 
                       }#PSCustomObject
                        }#ForEach

$c 