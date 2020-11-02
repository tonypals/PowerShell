$Date = Get-date -Format "yyMMdd-(HH.mm)"
$Path = "C:\Temp\MAC-Info_$date.csv"


$FileName = "c:\temp\exports\filename.txt"
        if (Test-Path $FileName) {
          Remove-Item $FileName
        }



Get-ADComputer -Filter 'OperatingSystem -eq "Mac OS X"' -Properties *  | 
select name,dist*,lastlogondate,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}},enabled,whencreated |
Export-csv $Path -Delimiter ";" -NoTypeInformation -Append

ii $Path