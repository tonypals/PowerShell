# This script shows info for all computers in a OU and exports to CSV

$path = $null
$path = "h:\Exports\Inactivefor$DaysInactive-StaticComputers-$(get-date -format d).csv"
$domainPath = "OU=Static,OU=CTX VDI,OU=CEVT Computers,OU=CEVT,$domain"
$DaysInactive = 10
$time = (Get-Date).Adddays(-($DaysInactive))

  
  get-adcomputer -filter {LastLogonTimeStamp -lt $time} -Properties * -SearchBase $domainPath  |
    select name,lastlogondate |
    export-csv -Path $path -Delimiter ";" -NoTypeInformation -Encoding Unicode -Append


  









    cls
    Write-host " Då var det klart!" -ForegroundColor Green


    ii $path