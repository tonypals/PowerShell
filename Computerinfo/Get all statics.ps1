
 
function Get-ADComputersLastlogon()
{

 $dcs = $null
 $dc = $null
  $user = $null
   $path = $null 
$domain = $null
$hostname =$null




 $dcs = @("auto-dc-01.auto.geely.com","auto-dc-03.auto.geely.com","auto-dc-04.auto.geely.com","auto-dc-02.auto.geely.com")

  $domain = (get-addomain).distinguishedname
  #$domainPath = "OU=Static,OU=CTX VDI,OU=CEVT Computers,OU=CEVT,$domain"
   $domainPath = "OU=lynkco computers,OU=CEVT,$domain"
 $users = get-adcomputer -filter * -Properties * -SearchBase $domainPath
 

  $time = 0
  $exportFilePath = "h:\Exports\testOne4.csv"
  
  $columns = "name,datetime,DC-server"

  Out-File -filepath $exportFilePath -force -InputObject $columns

  foreach($user in $users)
  {
    foreach($dc in $dcs)
    { 
    write-host $dc -ForegroundColor Green
    Write-host $user.samaccountname -ForegroundColor green
   


$currentUser = Get-ADcomputer $user.SamAccountName | Get-ADObject -Server $dc -Properties lastLogon

      if($currentUser.LastLogon -gt $time) 
      {
        $time = $currentUser.LastLogon
      }
    }

    $dt = [DateTime]::FromFileTime($time)
    $row = $user.Name+","+$dt+,","+$dc
   

    Out-File -filepath $exportFilePath -append -noclobber -InputObject $row 


    $time = 0
  }
}
 
Get-ADComputersLastlogon

write-host "Nu är det klart"

ii $exportFilePath