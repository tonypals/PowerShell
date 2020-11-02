# 2020-05-26
# This Script compares to Attributes in AD. In this case CN and Samaccountname


$path = (get-addomain).distinguishedname
$Date = Get-Date -Format "yy-MM-dd_HHmm"

#region OUs

# CEVT Users:
    $AllCEVT = "OU=CEVT,$path"

    $users = get-aduser -SearchBase $AllCEVT -Filter {enabled -ne $false } -Properties cn

    foreach ($user in $users) {

    $x = $user.samaccountname
    $y = $user.CN


if ($x -eq $y)
{
   #write-host "Variblerna är samma" -ForegroundColor Green
}
else
{
   write-host "Variblerna är INTE samma" $x -ForegroundColor Red
   
   Get-aduser $x -Properties cn | select cn,samaccountname # |
   #export-csv -Path c:\temp\Fel_SAM_CN_$date.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode -Append
}

    

    }

    #ii c:\temp\Fel_SAM_CN_$date.csv
