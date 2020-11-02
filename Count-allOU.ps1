$ous = Get-ADOrganizationalUnit -Filter * -SearchBase "OU=CEVT,DC=auto,DC=geely,DC=com" | Select-Object -ExpandProperty DistinguishedName
$ous | ForEach-Object{

    [psobject][ordered]@{
        OU = $_
        Count = (Get-ADUser -Filter {enabled -ne $false } -SearchBase "$_").count
        
    }
} 

