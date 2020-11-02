Clear-Host

$date = get-date -Format d
$time = Get-Date -UFormat %r

remove-item C:\temp\allmachines.txt


$array = (30..60)
$array |
    ForEach-Object {
        
    $computername = "GOT500VI790$_.dhcp.nordic.volvocars.net"

          foreach ($item in $computername)
            {
        
                    $computername | Out-File c:\temp\allmachines.txt -Append
                  }

            }

            

Get-Content C:\temp\allmachines.txt | ForEach-Object {
     if(Test-Connection $_ -Quiet -Count 1) {   
         New-Object -TypeName PSCustomObject -Property @{
             Date = $date
             Time = $time
             VMName = $_
             'Ping Status' = 'Ok'
             
         }
     } else {
         New-Object -TypeName PSCustomObject -Property @{
             Date = $date
             Time = $time
             VMName = $_
             'Ping Status' = 'Failed'
             
         }    
     }
 } | Export-Csv -Path c:\temp\vdistatus.csv -Append -NoTypeInformation -Delimiter ";"

 Invoke-Item c:\temp\vdistatus.csv

