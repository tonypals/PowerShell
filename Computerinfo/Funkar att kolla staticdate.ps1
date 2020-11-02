


 $dcs = $null
 $dc = $null
 $Computer = $null
 $path = $null 
$domain = $null
$hostname =$null




 $dcs = @("auto-dc-01.auto.geely.com","auto-dc-03.auto.geely.com","auto-dc-04.auto.geely.com","auto-dc-02.auto.geely.com")

  $domain = (get-addomain).distinguishedname
  $domainPath = "OU=Static,OU=CTX VDI,OU=CEVT Computers,OU=CEVT,$domain"
  # $domainPath = "OU=lynkco computers,OU=CEVT,$domain"
 $Computers = get-adcomputer -filter * -Properties * -SearchBase $domainPath 
 $date = get-date -UFormat %H%M
 

  
  $exportFilePath = "h:\Exports\$date-statics.csv"
  
 
       foreach($Computer in $Computers)
  {


  
   get-adcomputer $Computer -Properties * | select name,@{N='LastLogon'; E={[DateTime]::FromFileTime($_.LastLogon)}},@{N='LastLogontimestamp'; E={[DateTime]::FromFileTime($_.LastLogontimestamp)}} |
   export-csv -Path $exportFilePath -Delimiter ";" -NoTypeInformation -Append


  }


 


write-host "Nu är det klart"

ii $exportFilePath

