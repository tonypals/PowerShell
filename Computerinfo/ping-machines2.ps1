cls

$date = get-date -Format d
$Filepath = "c:\temp\VMPingStatus.csv"

$array = (30..60)
$array |
    foreach {
        
    $computername = "GOT500VI790$_"

          foreach ($item in $computername)
            {
        
      $item | ForEach-Object {
             if(
             Test-Connection $_ -Quiet -Count 1) {   
             
             New-Object -TypeName PSCustomObject -Property @{
             Date = Get-date -format d
             Time = Get-date -DisplayHint Time
             VMName = $_
             'Ping Status' = 'Ok'
             
         }
     } else {
         New-Object -TypeName PSCustomObject -Property @{
             Date = Get-date -format d
             Time = Get-date -DisplayHint Time
             VMName = $_
             'Ping Status' = 'Failed'
             
         }  
                  }

            }

            

  
     }
 } | Export-Csv -Path $Filepath -NoTypeInformation -Append -Delimiter ";"

 Write-host "Script ok and $filepath exists"

ii c:\temp\VMPingStatus.csv 

