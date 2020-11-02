

Get-ADGroupMember -Identity CEVT-Office365-E3-SE-License -Recursive | 
%{Get-ADUser -Identity $_.distinguishedName -Properties Enabled | ?{$_.Enabled -eq $false}} | Select DistinguishedName,Enabled | 
Export-Csv c:\temp\result.csv -NoTypeInformation

ii c:\temp\result.csv



(Get-ADGroupMember -Identity CEVT-Office365-E3-SE-License -Recursive | 
%{Get-ADUser -Identity $_.distinguishedName -Properties Enabled | ?{$_.Enabled -eq $false}} | Select DistinguishedName,Enabled).count