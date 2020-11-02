<# This script shows all Computers in the Static-OU that has not logged in for 10 days.
   It uses the LastLogonTimeStamp for checking.




#>

# Sets Variables

    $Computer = $null
    $path = $null 
    $domain = $null
    $hostname =$null
    $domain = (get-addomain).distinguishedname

    # The path to the OU:
    $domainPath = "OU=Static,OU=CTX VDI,OU=CEVT Computers,OU=CEVT,$domain"

    # Change this value if needed: 
    $DaysInactive = 10

    $time = (Get-Date).Adddays(-($DaysInactive))
    $Computers = get-adcomputer -filter {LastLogonTimeStamp -lt $time} -Properties * -SearchBase $domainPath 
    $date = get-date -UFormat %H%M  

    # The Export file that might not be needed
    $exportFilePath = "h:\Exports\$date-statics.csv"
  
 
 foreach($Computer in $Computers)
      {
       get-adcomputer $Computer  -Properties * | select name,@{N='LastLogon'; E={[DateTime]::FromFileTime($_.LastLogon)}},@{N='LastLogontimestamp'; E={[DateTime]::FromFileTime($_.LastLogontimestamp)}} |
       export-csv -Path $exportFilePath -Delimiter ";" -NoTypeInformation -Append
      }


 


