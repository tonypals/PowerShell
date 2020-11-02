Get-ADUser -Identity qinghua.peng -Properties directreports |
    Select-Object -ExpandProperty directreports |
    Get-ADUser -Properties mail,directreports |
    Select-Object SamAccountName, mail,directreports | where samaccountname -NotLike 'z*' 